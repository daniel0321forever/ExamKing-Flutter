import 'dart:async';

import 'package:examKing/blocs/auth/auth_bloc.dart';
import 'package:examKing/blocs/main/main_bloc.dart';
import 'package:examKing/component/account_text_field.dart';
import 'package:examKing/component/login_button.dart';
import 'package:examKing/component/logout_icon.dart';
import 'package:examKing/models/user.dart';
import 'package:examKing/pages/ability_analyse_page.dart';
import 'package:examKing/pages/login_page.dart';
import 'package:examKing/pages/main_page.dart';
import 'package:examKing/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:examKing/component/main_page_button.dart';
import 'package:examKing/pages/index_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountLoginPage extends StatefulWidget {
  const AccountLoginPage({super.key});

  @override
  State<AccountLoginPage> createState() => _AccountLoginPageState();
}

class _AccountLoginPageState extends State<AccountLoginPage> with SingleTickerProviderStateMixin {
  late AuthBloc authBloc;
  late StreamSubscription authBlocListener;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _signUpPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _signUpUsernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool isSignUp = false;
  int signUpStep = 0;
  bool isPasswordEmpty = false;
  bool isPasswordDifferent = false;
  bool isEmailValid = true;
  bool isEmailEmpty = false;
  bool isUsernameEmpty = false;
  bool isUsernameValid = true;
  bool isLogInFailed = false;
  bool isNameEmpty = false;

  ImageProvider backgroundImageProvider = const NetworkImage('https://media.tenor.com/bx7hbOEm4gMAAAAj/sakura-leaves.gif');

  @override
  void initState() {
    super.initState();

    authBloc = context.read<AuthBloc>();
    authBlocListener = authBloc.stream.listen((state) {
      if (state is AuthStateUsernameAvailable) {
        setState(() {
          signUpStep = 1;
          isUsernameValid = true;
          isUsernameEmpty = false;
        });
      } else if (state is AuthStateEmailAvailable) {
        setState(() {
          signUpStep = 2;
          isEmailValid = true;
          isEmailEmpty = false;
        });
      } else if (state is AuthStateEmailEmpty) {
        setState(() {
          isEmailEmpty = true;
        });
      } else if (state is AuthStateEmailInvalid) {
        setState(() {
          isEmailEmpty = false;
          isEmailValid = false;
        });
      } else if (state is AuthStateUsernameNotAvailable) {
        setState(() {
          isUsernameValid = false;
          isUsernameEmpty = false;
        });
      } else if (state is AuthStateUsernameEmpty) {
        setState(() {
          isUsernameEmpty = true;
        });
      } else if (state is AuthStateAuthenticated) {
        if (mounted) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));
        }
      } else if (state is AuthStateFailed) {
        setState(() {
          isLogInFailed = true;
        });
      }
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _signUpUsernameController.dispose();
    _signUpPasswordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    authBlocListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: backgroundImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),

                  // User Avatar
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/player1.webp'),
                    ),
                  ),
                  const SizedBox(height: 20),

                  isSignUp ? [buildSignUpForm1(), buildSignUpForm2(), buildSignUpForm3()][signUpStep] : buildLoginForm(),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: LogoutIcon(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
              }),
            ),
          ],
        ),
      ),
    );
  }

  void handleLoginToggle() {
    setState(() {
      signUpStep = 0;
      isSignUp = false;
      isUsernameValid = true;
      isEmailValid = true;
      isPasswordDifferent = false;
      isNameEmpty = false;
    });
  }

  Widget buildLoginToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("已經有帳號了？"),
        GestureDetector(
          onTap: handleLoginToggle,
          child: Text(
            "登入帳號",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNameField() {
    return SizedBox(
      width: 200,
      child: TextField(
        autofocus: true,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        controller: _nameController,
        style: GoogleFonts.girassol(
          fontSize: 35,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          errorText: isNameEmpty ? "名字不能為空" : null,
          hintText: 'Your Name',
          hintStyle: GoogleFonts.girassol(
            fontSize: 35,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }

  Widget buildSignUpForm1() {
    return Column(
      children: [
        buildNameField(),
        const SizedBox(height: 10),

        AccountTextField(
          controller: _signUpUsernameController,
          labelText: '帳號',
          prefixIcon: Icons.person,
          obscureText: false,
          errorText: isUsernameEmpty
              ? "帳號不能為空"
              : isUsernameValid
                  ? null
                  : "帳號已經被使用",
        ),

        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: LoginButton(
                onPressed: () {
                  if (_nameController.text.isEmpty) {
                    setState(() {
                      isNameEmpty = true;
                    });
                    return;
                  }
                  authBloc.add(AuthEventCheckUsername(username: _signUpUsernameController.text));
                },
                title: "下一步",
              ),
            );
          },
        ),

        // log in toggle
        const SizedBox(height: 20),
        buildLoginToggle(),
      ],
    );
  }

  Widget buildSignUpForm2() {
    return Column(
      children: [
        buildNameField(),
        const SizedBox(height: 10),

        AccountTextField(
          controller: _emailController,
          labelText: '電子郵件',
          prefixIcon: Icons.email,
          obscureText: false,
          errorText: isEmailEmpty
              ? "電子郵件不能為空"
              : isEmailValid
                  ? null
                  : "電子郵件格式錯誤或已經被使用",
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginButton(
              onPressed: () {
                setState(() {
                  signUpStep--;
                });
              },
              title: "上一步",
              backgroundColor: Colors.grey,
              textColor: Colors.white,
            ),
            const SizedBox(width: 20),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: LoginButton(
                    onPressed: () {
                      authBloc.add(AuthEventCheckEmail(email: _emailController.text));
                    },
                    title: "下一步",
                  ),
                );
              },
            ),
          ],
        ),

        // log in toggle
        const SizedBox(height: 20),
        buildLoginToggle(),
      ],
    );
  }

  Widget buildSignUpForm3() {
    return Column(
      children: [
        buildNameField(),
        const SizedBox(height: 10),

        AccountTextField(
          controller: _signUpPasswordController,
          labelText: '密碼',
          prefixIcon: Icons.lock,
          obscureText: true,
          errorText: isPasswordEmpty ? "密碼不能為空" : null,
        ),
        AccountTextField(
          controller: _confirmPasswordController,
          labelText: '確認密碼',
          prefixIcon: Icons.lock,
          obscureText: true,
          errorText: isPasswordDifferent ? "密碼不一致" : null,
        ),

        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: LoginButton(
                onPressed: () {
                  if (_signUpPasswordController.text.isEmpty) {
                    setState(() {
                      isPasswordEmpty = true;
                      isPasswordDifferent = false;
                    });
                    return;
                  }

                  if (_signUpPasswordController.text != _confirmPasswordController.text) {
                    setState(() {
                      isPasswordEmpty = false;
                      isPasswordDifferent = true;
                    });
                    return;
                  }
                  authBloc.add(AuthEventSignUp(
                      username: _signUpUsernameController.text,
                      password: _signUpPasswordController.text,
                      email: _emailController.text,
                      name: _nameController.text));
                  setState(() {
                    signUpStep = 0;
                    isPasswordDifferent = false;
                    isPasswordEmpty = false;
                  });
                },
                title: "註冊",
              ),
            );
          },
        ),

        // log in toggle
        const SizedBox(height: 20),
        buildLoginToggle(),
      ],
    );
  }

  Widget buildLoginForm() {
    return Column(
      children: [
        // title
        Text(
          "Login",
          style: GoogleFonts.girassol(
            fontSize: 35,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        // username field
        AccountTextField(controller: _usernameController, labelText: '帳號', prefixIcon: Icons.person, obscureText: false),
        AccountTextField(
          controller: _passwordController,
          labelText: '密碼',
          prefixIcon: Icons.lock,
          obscureText: true,
          errorText: isLogInFailed ? "帳號或密碼錯誤" : null,
        ),

        // Keep signed in checkbox
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Checkbox(
        //       value: authBloc.isKeepSignedIn,
        //       onChanged: (bool? value) {
        //         setState(() {
        //           if (value != null) {
        //             authBloc.isKeepSignedIn = value;
        //           }
        //         });
        //       },
        //       fillColor: WidgetStateProperty.resolveWith((states) {
        //         if (states.contains(WidgetState.selected)) {
        //           return Theme.of(context).primaryColor;
        //         }
        //         return Colors.white;
        //       }),
        //       checkColor: Colors.white,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(6),
        //       ),
        //       side: BorderSide(
        //         color: Theme.of(context).primaryColor.withOpacity(0.8),
        //         width: 1.5,
        //       ),
        //     ),
        //     Text(
        //       '保持登入狀態',
        //       style: GoogleFonts.notoSans(
        //         color: Colors.black87,
        //         fontSize: 14,
        //         fontWeight: FontWeight.w500,
        //         letterSpacing: 0.3,
        //       ),
        //     ),
        //   ],
        // ),

        // Login Button
        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: LoginButton(
                onPressed: () {
                  authBloc.add(AuthEventLogIn(username: _usernameController.text, password: _passwordController.text));
                },
                title: "登入",
              ),
            );
          },
        ),

        // toggle sign up and login
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("還沒有帳號？"),
            GestureDetector(
              onTap: () {
                setState(() {
                  isSignUp = !isSignUp;
                });
              },
              child: Text(
                "註冊帳號",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
