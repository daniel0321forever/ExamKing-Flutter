import 'package:flutter/material.dart';
import 'package:examKing/pages/main_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:examKing/blocs/battle/battle_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BattleResultPage extends StatelessWidget {
  const BattleResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final battleBloc = context.read<BattleBloc>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),

            // score card
            ScoreCard(
              avatarImage: 'assets/player1.webp',
              userName: 'YOU',
              score: battleBloc.playerScore,
              moneyChange: battleBloc.playerScore - battleBloc.opponentScore,
            ),

            // back to main page button
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MainPage()));
              },
              child: Text(
                '回到首頁',
                style: GoogleFonts.yuseiMagic(
                    decoration: TextDecoration.underline, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreCard extends StatefulWidget {
  final String avatarImage;
  final String userName;
  final int score;
  final int moneyChange;

  const ScoreCard({
    super.key,
    required this.avatarImage,
    required this.userName,
    required this.score,
    required this.moneyChange,
  });

  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 60.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWinner = widget.moneyChange > 0;

    return Container(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 450,
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isWinner
                      ? [
                          const Color.fromARGB(60, 228, 57, 57),
                          const Color.fromARGB(60, 245, 183, 67)
                        ]
                      : [
                          const Color.fromARGB(60, 92, 209, 245),
                          const Color.fromARGB(25, 1, 29, 43)
                        ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isWinner
                        ? const Color.fromARGB(130, 243, 255, 177)
                        : const Color.fromARGB(60, 233, 66, 66),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // winner or loser
                  Text(
                    isWinner ? 'WINNER' : 'LOSER',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isWinner
                          ? const Color.fromARGB(255, 255, 136, 0)
                          : const Color.fromARGB(255, 202, 97, 97),
                    ),
                  ),

                  // avatar
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 90,
                        backgroundImage: AssetImage(widget.avatarImage),
                      ),
                      if (isWinner)
                        Transform.rotate(
                          angle: _controller.value * 2 * 3.14159,
                          child: Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    Colors.amber.withOpacity(_controller.value),
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // score
                  const Spacer(),
                  Text(
                    'Score',
                    style: TextStyle(
                      fontSize: 19,
                      color: isWinner ? Colors.amber[800] : Colors.grey[800],
                    ),
                  ),
                  Text(
                    widget.score.toString(),
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: isWinner ? Colors.amber[900] : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
