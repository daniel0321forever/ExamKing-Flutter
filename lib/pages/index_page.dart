import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morphable_shape/morphable_shape.dart';

// bloc
import 'package:examKing/blocs/battle/battle_bloc.dart';

// component
import 'package:examKing/component/challeng_tile.dart';
import 'package:examKing/component/dialog_button.dart';

// model
import 'package:examKing/models/challenge.dart';

// page
import 'package:examKing/pages/battle_page.dart';
import 'package:examKing/pages/battle_prep_page.dart';
import 'package:examKing/pages/main_page.dart';
import 'package:examKing/styling/clipper.dart';

// global
import 'package:examKing/global/properties.dart';

// TODO:
// 1. make it a big wheel animation
// 2. when click on one element of the wheel, it will animate into a page that contains smaller challenge of the item

// Add this new widget at the top level of the file, before IndexPage
class AnimatedBackButton extends StatefulWidget {
  const AnimatedBackButton({super.key});

  @override
  State<AnimatedBackButton> createState() => _AnimatedBackButtonState();
}

class _AnimatedBackButtonState extends State<AnimatedBackButton> with SingleTickerProviderStateMixin {
  late AnimationController _backButtonController;
  late Animation<double> _backButtonScale;

  @override
  void initState() {
    super.initState();
    _backButtonController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _backButtonScale = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _backButtonController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _backButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backButtonScale,
      builder: (context, child) => Transform.scale(
        scale: _backButtonScale.value,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Color.fromARGB(255, 40, 19, 46),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              iconSize: 30,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainPage()));
              },
            ),
          ),
        ),
      ),
    );
  }
}

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimations = List.generate(
      challenges.length,
      (index) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.15,
          index * 0.15 + 0.5,
          curve: Curves.easeIn,
        ),
      )),
    );

    _scaleAnimations = List.generate(
      challenges.length,
      (index) => Tween<double>(
        begin: 0.5,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.15,
          index * 0.15 + 0.5,
          curve: Curves.elasticOut,
        ),
      )),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> showStartBattleDialog(Challenge challenge, {required bool isLeft}) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return StartBattleDialog(
          challenge: challenge,
          isLeft: isLeft,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 240 * challenges.length.toDouble() + 200,
          decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: (NetworkImage('https://storage.googleapis.com/pod_public/1300/176142.jpg')),
            //   fit: BoxFit.cover,
            // ),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(198, 241, 182, 182),
                Color.fromARGB(255, 250, 178, 178),
                Color.fromARGB(255, 248, 172, 172),
              ],
            ),
          ),
          child: Stack(
            children: <Widget>[
                  const Positioned(
                    top: 40,
                    left: 20,
                    child: AnimatedBackButton(),
                  ),
                ] +
                List<Widget>.generate(
                  challenges.length,
                  (i) => Positioned(
                    top: i * 240,
                    child: FadeTransition(
                      opacity: _fadeAnimations[i],
                      child: ScaleTransition(
                        scale: _scaleAnimations[i],
                        child: ChallengTile(
                          challenge: challenges.values.toList()[i],
                          onPressed: () {
                            showStartBattleDialog(challenges.values.toList()[i], isLeft: i % 2 == 1);
                          },
                          isLeft: i % 2 == 1,
                        ),
                      ),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

class StartBattleDialog extends StatefulWidget {
  final Challenge challenge;
  final bool isLeft;
  const StartBattleDialog({super.key, required this.challenge, required this.isLeft});

  @override
  State<StartBattleDialog> createState() => _StartBattleDialogState();
}

class _StartBattleDialogState extends State<StartBattleDialog> with SingleTickerProviderStateMixin {
  late final BattleBloc battleBloc;
  late final StreamSubscription<BattleState> battleSubscription;
  late final AnimationController _controller;
  late final Animation<double> _contentAnimation;

  bool _isWaiting = false;

  @override
  void initState() {
    super.initState();
    battleBloc = context.read<BattleBloc>();
    battleSubscription = battleBloc.stream.listen((state) {
      if (state is BattleWaitingState) {
        setState(() {
          _isWaiting = true;
        });
      } else if (state is BattleStartBattleState) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BattlePrepPage(
                playerName: "You",
                opponentName: battleBloc.opponentName ?? "Unknown Player",
              ),
            ),
          );
        }
      }
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _contentAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    battleSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 30,
      child: Hero(
        tag: "${widget.challenge.key}_herotag",
        child: Container(
          width: double.infinity,
          height: 450,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.challenge.imageURL),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: FadeTransition(
            opacity: _contentAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(_contentAnimation),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isWaiting) ...[
                    const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(220, 238, 226, 255),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Text(
                    widget.challenge.name,
                    style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(220, 238, 226, 255),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _isWaiting ? "配對中..." : "開始配對",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(220, 236, 222, 255),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DialogButton(
                          title: "Cancel",
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      _isWaiting ? const SizedBox() : const SizedBox(width: 24),
                      _isWaiting
                          ? const SizedBox()
                          : DialogButton(
                              title: "Continue",
                              onPressed: () {
                                battleBloc.add(BattleStartEvent(challenge: widget.challenge));
                              }),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
