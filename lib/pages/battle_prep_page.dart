import 'package:examKing/styling/router.dart';
import 'package:flutter/material.dart';
import 'package:examKing/pages/battle_page.dart';

class BattlePrepPage extends StatefulWidget {
  final String playerName;
  final String opponentName;

  const BattlePrepPage({
    super.key,
    required this.playerName,
    required this.opponentName,
  });

  @override
  State<BattlePrepPage> createState() => _BattlePrepPageState();
}

class _BattlePrepPageState extends State<BattlePrepPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideInLeft;
  late Animation<double> _slideInRight;
  late Animation<double> _vsScaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    _slideInLeft = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _slideInRight = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _vsScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.8, curve: Curves.elasticOut),
      ),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            FadeScalePageRoute(page: const BattlePage()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Background with some anime-style effects
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://i.pinimg.com/originals/62/f6/0e/62f60eb00055ce5a3580bd91559f9f94.gif'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Player 1
              Positioned(
                left: MediaQuery.of(context).size.width * (_slideInLeft.value - 0.2),
                top: MediaQuery.of(context).size.height * 0.3,
                child: Transform.scale(
                  scale: 1.0,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 39, 0, 10).withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/player1.webp',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.playerName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.blue,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Player 2
              Positioned(
                right: MediaQuery.of(context).size.width * (_slideInRight.value - 0.2),
                top: MediaQuery.of(context).size.height * 0.3,
                child: Transform.scale(
                  scale: 1.0,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 39, 0, 10).withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/player2.webp',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.opponentName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.red,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // VS Text
              Center(
                child: Transform.scale(
                  scale: _vsScaleAnimation.value,
                  child: const Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 20.0,
                          color: Colors.orange,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
