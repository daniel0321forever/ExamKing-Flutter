import 'dart:io';
import 'dart:convert';

import 'package:examKing/global/exception.dart';
import 'package:examKing/global/properties.dart';
import 'package:examKing/models/ability_record.dart';
import 'package:examKing/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:examKing/models/challenge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:examKing/global/keys.dart' as keys;

class BackendService {
  WebSocketChannel? channel;
  GoogleSignIn? googleSignIn;
  List<String> signInScope = [
    'openid',
    'email',
    'profile',
  ];

  /// The function would attempt to make socket connetion with the server
  /// The following behaviour are expected
  /// 1) The user might wait for a while without getting game-data before there is match for the user
  /// 2) The server would return game-data with following format by the key 'game-data' once the connection is built
  Future<void> connectToBattle(Challenge challenge, {required String username}) async {
    String gameSocketURL = "${dotenv.get('SOCKET_HOST')}battle?user=$username&challenge=${challenge.key}";
    try {
      channel = WebSocketChannel.connect(Uri.parse(gameSocketURL));
      await channel?.ready;
    } catch (e) {
      debugPrint("backend_service | connectToControllerSocket | error occurs when waiting for channel to be ready: $e");
      throw const SocketException("fail to connect to game consumer");
    }
  }

  /// The function would send the answer event to the channel
  /// The following behaviour is expected when the function has been called
  /// 1) An event including information about userID and score would be sent to server websocket
  /// 2) Server websocket would broadcast data about the scoring event
  void answer(int score, {int? optionIndex, required String userId}) {
    debugPrint("backend | answer | triggered");
    Map<String, dynamic> payload = {
      'type': 'answer',
      'userID': userId,
      'score': score,
    };

    if (optionIndex != null) {
      payload['optionIndex'] = optionIndex;
    }

    channel?.sink.add(json.encode(payload));
  }

  /// Close the connection to websocket
  /// The following behavior are expected as the socket is closed
  /// 1) If the user is still waiting for match, the cancel of event would be recorded
  /// 2) The connection would be close
  void closeConnection() {
    channel?.sink.close();
    channel = null;
  }

  /// Signing in with google
  Future<UserData> signInWithGoogle() async {
    debugPrint("signing in with google");

    //If current device is Android, do not use any parameters except from scopes.
    if (Platform.isAndroid) {
      googleSignIn = GoogleSignIn(
        scopes: signInScope,
      );
    }

    //If current device IOS, We have to declare clientID
    //Please, look STEP 2 for how to get Client ID for IOS
    else if (Platform.isIOS) {
      googleSignIn = GoogleSignIn(
        clientId: dotenv.get('GOOGLE_CLOUD_IOS_CLIENT_ID'),
        scopes: signInScope,
      );
    }

    // Other device
    else {
      throw Exception("Invalid platform ${Platform.operatingSystem} (Why the hell it would happen?)");
    }

    final GoogleSignInAccount? googleAccount = await googleSignIn!.signIn();
    debugPrint("backend | signInWithGoogle | got google account");

    // If you want further information about Google accounts, such as authentication, use this.
    if (googleAccount == null) {
      throw GoogleAuthFailedException();
    }

    final GoogleSignInAuthentication googleAuthentication = await googleAccount.authentication;

    debugPrint("backend | signInWithGoogle | email, ${googleAccount.displayName}");
    debugPrint("backend | signInWithGoogle | auth, ${googleAuthentication.idToken}");

    // log in to backend with id_token
    var res = await http.post(
      Uri.parse("${dotenv.get('HTTP_HOST')}auth"),
      headers: {
        "Content-type": "Application/json",
      },
      body: json.encode({
        "id_token": googleAuthentication.idToken ?? "",
      }),
    );

    Map body = json.decode(utf8.decode(res.bodyBytes));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keys.prefTokenKey, body[keys.accountTokenKey]);

    return UserData.fromMap(body);
  }

  Future<UserData> signInWithToken() async {
    debugPrint("backend | signInWithToken | triggered");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(keys.prefTokenKey);

    if (token == null) {
      debugPrint("backend | signInWithTOken | token not found");
      throw UnAuthenticatedException();
    }

    Uri url = Uri.parse("${dotenv.get('HTTP_HOST')}token_login");
    var res = await http.post(
      url,
      headers: {
        "Content-type": "Application/json",
        "Authorization": "Bearer $token",
      },
    );

    switch (res.statusCode) {
      case 200:
        debugPrint("backend service | updatedBattleRecord | get success response ${res.body}");
        Map body = json.decode(utf8.decode(res.bodyBytes));
        return UserData.fromMap(body);
      case 404:
        debugPrint("backend service | updatedBattleRecord | end point not found");
        throw PageNotFoundException();
      case 401:
        debugPrint("backend service | updatedBattleRecord | ${res.body}");
        throw UnAuthenticatedException();
      default:
        debugPrint("backend service | updatedBattleRecord | error status ${res.statusCode}");
        debugPrint("body ${res.body}");
        throw UnhandledStatusException();
    }
  }

  Future<UserData> signIn(String username, String password) async {
    debugPrint("backend | signIn | triggered");

    Uri url = Uri.parse("${dotenv.get('HTTP_HOST')}login");
    var res = await http.post(
      url,
      headers: {
        "Content-type": "Application/json",
      },
      body: json.encode({
        keys.authUserNameKey: username,
        keys.authPasswordKey: password,
      }),
    );

    switch (res.statusCode) {
      case 200:
        debugPrint("backend service | signIn | get success response ${res.body}");
        Map body = json.decode(utf8.decode(res.bodyBytes));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(keys.prefTokenKey, body[keys.accountTokenKey]);
        return UserData.fromMap(body);
      case 404:
        debugPrint("backend service | signIn | end point not found");
        throw PageNotFoundException();
      case 401:
        debugPrint("backend service | signIn | username or password is incorrect");
        throw UnAuthenticatedException();
      default:
        debugPrint("backend service | signIn | error status ${res.statusCode}");
        debugPrint("body ${res.body}");
        throw UnhandledStatusException();
    }
  }

  Future<UserData> signUp(String username, String password, String email, String name) async {
    debugPrint("backend | signUp | triggered");

    Uri url = Uri.parse("${dotenv.get('HTTP_HOST')}signup");
    var res = await http.post(
      url,
      headers: {
        "Content-type": "Application/json",
      },
      body: json.encode({
        keys.authUserNameKey: username,
        keys.authPasswordKey: password,
        keys.authEmailKey: email,
        keys.authNameKey: name,
      }),
    );

    switch (res.statusCode) {
      case 200:
        debugPrint("backend service | signUp | get success response ${res.body}");
        Map body = json.decode(utf8.decode(res.bodyBytes));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(keys.prefTokenKey, body[keys.accountTokenKey]);
        return UserData.fromMap(body);
      case 404:
        debugPrint("backend service | signUp | end point not found");
        throw PageNotFoundException();
      case 401:
        debugPrint("backend service | signUp | ${res.body}");
        throw UnAuthenticatedException();
      default:
        debugPrint("backend service | signUp | error status ${res.statusCode}");
        debugPrint("body ${res.body}");
        throw UnhandledStatusException();
    }
  }

  Future<void> checkUsername(String username) async {
    debugPrint("backend | checkUsername | triggered");
    Uri url = Uri.parse("${dotenv.get('HTTP_HOST')}check_username");
    var res = await http.post(
      url,
      headers: {
        "Content-type": "Application/json",
      },
      body: json.encode({
        keys.authUserNameKey: username,
      }),
    );

    switch (res.statusCode) {
      case 200:
        debugPrint("backend service | checkUsername | get success response ${res.body}");
      case 409:
        debugPrint("backend service | checkUsername | username is already taken");
        throw UsernameAlreadyTakenException();
      default:
        throw UnhandledStatusException();
    }
  }

  Future<void> checkEmail(String email) async {
    debugPrint("backend | checkEmail | triggered");
    Uri url = Uri.parse("${dotenv.get('HTTP_HOST')}check_email");
    var res = await http.post(
      url,
      headers: {
        "Content-type": "Application/json",
      },
      body: json.encode({
        keys.authEmailKey: email,
      }),
    );

    switch (res.statusCode) {
      case 200:
        debugPrint("backend service | checkEmail | get success response ${res.body}");
      case 400:
        debugPrint("backend service | checkEmail | email is invalid");
        throw EmailInvalidException();
      default:
        debugPrint("backend service | checkEmail | error status ${res.statusCode}");
        debugPrint("body ${res.body}");
        throw UnhandledStatusException();
    }
  }

  Future<void> logOut(bool isKeepSignedIn) async {
    // if (!isKeepSignedIn) {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.remove(keys.prefTokenKey);
    // }
  }

  Future<void> updateUserInfo(Map<String, dynamic> updateMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(keys.prefTokenKey);

    if (token == null) {
      throw UnAuthenticatedException();
    }

    Uri url = Uri.parse("${dotenv.get('HTTP_HOST')}user");
    var res = await http.patch(
      url,
      headers: {
        "Content-type": "Application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(updateMap),
    );

    switch (res.statusCode) {
      case 200:
        debugPrint("backend service | updateUserInfo | get success response ${res.body}");
      case 404:
        debugPrint("service | updateUserInfo | end point not found");
        throw PageNotFoundException();
      case 401:
        debugPrint("backend service | updateUserInfo | ${res.body}");
        throw UnAuthenticatedException();
      default:
        debugPrint("backend service | updateUserInfo | error status ${res.statusCode}");
        debugPrint("body ${res.body}");
        throw UnhandledStatusException();
    }
  }

  Future<void> updatedBattleRecord({
    required String opponentID,
    required String field,
    required int totCorrect,
    required int totWrong,
    required bool userWin,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(keys.prefTokenKey);

    if (token == null) {
      throw UnAuthenticatedException();
    }

    Uri url = Uri.parse("${dotenv.get('HTTP_HOST')}record");
    var res = await http.post(
      url,
      headers: {
        "Content-type": "Application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        "field": field,
        "totCorrect": totCorrect,
        "totWrong": totWrong,
        "opponent": opponentID,
        "victory": userWin,
      }),
    );

    switch (res.statusCode) {
      case 200:
        debugPrint("backend service | updatedBattleRecord | get success response ${res.body}");
      case 404:
        debugPrint("service | updatedBattleRecord | end point not found");
        throw PageNotFoundException();
      case 401:
        debugPrint("backend service | updatedBattleRecord | ${res.body}");
        throw UnAuthenticatedException();
      default:
        debugPrint("backend service | updatedBattleRecord | error status ${res.statusCode}");
        debugPrint("body ${res.body}");
        throw UnhandledStatusException();
    }
  }

  Future<List<AbilityRecord>> getAbilityRecord() async {
    debugPrint("backend | getAbilityRecord triggered");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(keys.prefTokenKey);

    if (token == null) {
      throw UnAuthenticatedException();
    }

    Uri url = Uri.parse("${dotenv.get('HTTP_HOST')}record");

    var res = await http.get(
      url,
      headers: {
        "Content-type": "Application/json",
        "Authorization": "Bearer $token",
      },
    );

    switch (res.statusCode) {
      case 200:
        debugPrint("backend service | getAbilityRecord | get success response ${res.body}");
        Map body = json.decode(res.body);

        List<AbilityRecord> abilityRecords = List<AbilityRecord>.generate(
          body.values.length,
          (i) => AbilityRecord.fromMap(body.values.toList()[i]),
        );

        return abilityRecords;
      case 404:
        debugPrint("service | getAbilityRecord | end point not found");
        throw PageNotFoundException();
      case 401:
        debugPrint("backend service | getAbilityRecord | ${res.body}");
        throw UnAuthenticatedException();
      default:
        debugPrint("backend service | getAbilityRecord | error status ${res.statusCode}");
        debugPrint("body ${res.body}");
        throw UnhandledStatusException();
    }
  }
}
