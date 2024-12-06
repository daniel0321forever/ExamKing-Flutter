import 'dart:io';
import 'dart:convert';

import 'package:examKing/global/exception.dart';
import 'package:examKing/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:examKing/models/challenge.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String httpURL = "http://10.0.2.2:8000/api/";
const String socketURL = "ws://10.0.2.2:8000/api/";

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
  Future<void> connectToBattle(Challenge challenge) async {
    debugPrint("challenge key: ${challenge.key}");
    String gameSocketURL = "${socketURL}battle?user=daniel_00&challenge=${challenge.key}";
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
  void answer(int score, int? optionIndex) {
    debugPrint("answer | score: $score, optionIndex: $optionIndex");
    Map<String, dynamic> payload = {
      'type': 'answer',
      'userID': "daniel_00",
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

  Future<void> updateRecord(int totMoney) async {
    debugPrint("record updated");
  }

  /// Signing in with google
  Future<UserData> signInWithGoogle() async {
    debugPrint("signing in with google");

    //If current device is Android, do not use any parameters except from scopes.
    if (Platform.isAndroid) {
      googleSignIn = GoogleSignIn(
        scopes: signInScope,
      );

      debugPrint("google signin is set");
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

    debugPrint("getting google account");
    final GoogleSignInAccount? googleAccount = await googleSignIn!.signIn();
    debugPrint("got google account");

    // If you want further information about Google accounts, such as authentication, use this.
    if (googleAccount == null) {
      throw GoogleAuthFailedException();
    }

    final GoogleSignInAuthentication googleAuthentication = await googleAccount.authentication;

    debugPrint("email, ${googleAccount.displayName}");
    debugPrint("auth, ${googleAuthentication.idToken}");

    // log in to backend with id_token
    var res = await http.post(
      Uri.parse("${httpURL}auth"),
      headers: {
        "Content-type": "Application/json",
      },
      body: json.encode({
        "id_token": googleAuthentication.idToken ?? "",
      }),
    );

    debugPrint("get res ${res.statusCode}, ${res.body}");

    return UserData.fromJson(res.body);
  }
}
