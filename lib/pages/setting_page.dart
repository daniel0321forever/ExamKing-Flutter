import 'dart:async';

import 'package:examKing/blocs/auth/auth_bloc.dart';
import 'package:examKing/blocs/main/main_bloc.dart';
import 'package:examKing/component/back_to_main_button.dart';
import 'package:examKing/component/logout_icon.dart';
import 'package:examKing/models/user.dart';
import 'package:examKing/pages/ability_analyse_page.dart';
import 'package:examKing/pages/login_page.dart';
import 'package:examKing/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:examKing/component/main_page_button.dart';
import 'package:examKing/pages/index_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with SingleTickerProviderStateMixin {
  late AuthBloc authBloc;
  late StreamSubscription authBlocListener;
  late UserData user;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();

  ImageProvider backgroundImageProvider = const NetworkImage('https://media.tenor.com/bx7hbOEm4gMAAAAj/sakura-leaves.gif');

  @override
  void initState() {
    super.initState();

    authBloc = context.read<AuthBloc>();
    authBlocListener = authBloc.stream.listen((state) {
      if (state is AuthStateLoggedOut) {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
        }
      }
    });

    setState(() {});

    user = context.read<GlobalProvider>().userData!;
    _nameController.text = user.name;

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
    _nameController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
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

              const AnimatedBackButton(),

              const SizedBox(height: 30),

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

              // username
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isEditing)
                    SizedBox(
                      width: 200,
                      child: TextField(
                        autofocus: true,
                        onTapOutside: (event) {
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        controller: _nameController,
                        style: GoogleFonts.girassol(
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            authBloc.add(AuthEventUpdateUserName(name: value.trim()));
                            setState(() {
                              _isEditing = false;
                            });
                          }
                        },
                      ),
                    )
                  else
                    Text(
                      user.name,
                      style: GoogleFonts.girassol(
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(width: 9),
                  if (!_isEditing)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 40),
              // Ability Analysis Button
              MainPageButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AbilityAnalysePage(),
                  ));
                },
                title: "My Record",
                backgroundColor: const Color.fromARGB(255, 130, 199, 195),
                textColor: Colors.black,
              ),
              const SizedBox(height: 30),
              // Battle Arena Button
              MainPageButton(
                onPressed: () {
                  authBloc.add(AuthEventLogOut());
                },
                title: "Logout",
                backgroundColor: Colors.red,
                textColor: const Color.fromARGB(255, 185, 0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
