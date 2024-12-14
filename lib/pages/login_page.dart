import 'dart:async';

import 'package:examKing/component/login_button.dart';
import 'package:examKing/component/normal_signin_button.dart';
import 'package:examKing/pages/main_page.dart';
import 'package:examKing/styling/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:examKing/blocs/auth/auth_bloc.dart';
import 'package:examKing/component/google_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late final AuthBloc authBloc;
  late final StreamSubscription authBlocListener;
  late final AnimationController _contentController;
  late final AnimationController _backgroundController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _backgroundFadeAnimation;
  bool _imageLoaded = false;

  ImageProvider backgroundImageProvider = const NetworkImage('https://media.tenor.com/3hKQ_ZtSPd4AAAAM/luffy-snake-man.gif');

  void preloadImages() {
    List<String> preloadPaths = [
      "assets/player1.webp",
      "assets/player2.webp",
    ];

    for (String path in preloadPaths) {
      precacheImage(AssetImage(path), context);
    }
  }

  @override
  void initState() {
    super.initState();

    // Setup animations
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    // Add new background controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _backgroundFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.5),
      ),
    );

    // Auth listener
    authBloc = context.read<AuthBloc>();

    if (authBloc.state is AuthInitial) {
      authBloc.add(AuthEventAppStart());
    }

    authBlocListener = authBloc.stream.listen((state) {
      if (state is AuthStateAuthenticated) {
        if (mounted) {
          Navigator.of(context).push(FadeScalePageRoute(page: const MainPage()));
        }
        authBlocListener.cancel();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(backgroundImageProvider, context).then((_) {
      if (mounted) {
        setState(() {
          _imageLoaded = true;
          _backgroundController.forward().then((_) {
            _contentController.forward();
          });
        });
      }
    });
  }

  @override
  void dispose() {
    // preloadImages();
    authBlocListener.cancel();
    _contentController.dispose();
    _backgroundController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Black background with white circle
          Container(
            width: double.infinity,
            color: Colors.black,
            child: Center(
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Animated background image
          FadeTransition(
            opacity: _backgroundFadeAnimation,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: backgroundImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'The King of Exam',
                        style: GoogleFonts.yuseiMagic(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            const Shadow(
                              blurRadius: 10.0,
                              color: Colors.black26,
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // username field
                      // Container(
                      //   width: 300,
                      //   margin: const EdgeInsets.symmetric(vertical: 8),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white.withOpacity(0.9),
                      //     borderRadius: BorderRadius.circular(30),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.black.withOpacity(0.1),
                      //         blurRadius: 10,
                      //         offset: const Offset(0, 5),
                      //       ),
                      //     ],
                      //   ),
                      //   child: TextField(
                      //     controller: _usernameController,
                      //     style: const TextStyle(color: Colors.black87),
                      //     onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      //     decoration: InputDecoration(
                      //       labelText: 'Username',
                      //       labelStyle: const TextStyle(color: Colors.black54),
                      //       prefixIcon: const Icon(Icons.person, color: Colors.black54),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(30),
                      //         borderSide: BorderSide.none,
                      //       ),
                      //       filled: true,
                      //       fillColor: Colors.transparent,
                      //     ),
                      //   ),
                      // ),

                      // Google signin button

                      const GoogleSigninButton(),

                      // sign up button
                      const SizedBox(height: 20),
                      NormalSigninButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
