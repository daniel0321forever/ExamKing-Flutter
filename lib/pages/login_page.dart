import 'dart:async';

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

    _backgroundFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeIn,
      ),
    );

    // Auth listener
    authBloc = context.read<AuthBloc>();
    authBloc.add(AuthEventAppStart());
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
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _imageLoaded ? 1.0 : 0.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _opacityAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Text(
                          'The king of exams',
                          style: GoogleFonts.yuseiMagic(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black26,
                                offset: Offset(5.0, 5.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    FadeTransition(
                      opacity: _opacityAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: const GoogleSigninButton(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
