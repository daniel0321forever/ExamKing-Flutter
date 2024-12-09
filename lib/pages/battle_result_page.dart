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
      body: Column(
        children: [
          const SizedBox(height: 100),
          SizedBox(
            height: 450,
            child: PageView(
              controller: PageController(viewportFraction: 0.8),
              children: [
                ScoreCard(
                  avatarImage: 'assets/player1.webp',
                  userName: 'YOU',
                  score: battleBloc.playerScore,
                  moneyChange: battleBloc.playerScore - battleBloc.opponentScore,
                ),
                ScoreCard(
                  avatarImage: 'assets/player2.webp',
                  userName: battleBloc.opponentName ?? 'UNKNOWN',
                  score: battleBloc.opponentScore,
                  moneyChange: battleBloc.opponentScore - battleBloc.playerScore,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainPage()));
            },
            child: Text(
              '回到首頁',
              style: GoogleFonts.yuseiMagic(decoration: TextDecoration.underline, fontSize: 20),
            ),
          ),
        ],
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

class _ScoreCardState extends State<ScoreCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotateAnimation;

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

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: widget.moneyChange > 0 ? 0.1 : -0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
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

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isWinner
                      ? [const Color.fromARGB(255, 228, 57, 57).withOpacity(0.3), const Color.fromARGB(255, 245, 183, 67).withOpacity(0.1)]
                      : [const Color.fromARGB(255, 92, 209, 245).withOpacity(0.3), const Color.fromARGB(255, 1, 29, 43).withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isWinner ? const Color.fromARGB(255, 243, 255, 177).withOpacity(0.5) : const Color.fromARGB(255, 233, 66, 66).withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    isWinner ? 'WINNER' : 'LOSER',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isWinner ? Colors.amber[700] : const Color.fromARGB(255, 202, 97, 97),
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80,
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
                                color: Colors.amber.withOpacity(_controller.value),
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.userName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isWinner ? Colors.amber[800] : Colors.grey[800],
                    ),
                  ),
                  Text(
                    widget.score.toString(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isWinner ? Colors.amber[900] : Colors.black87,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.attach_money,
                        color: isWinner ? Colors.amber[700] : const Color.fromARGB(255, 202, 97, 97),
                      ),
                      Text(
                        widget.moneyChange.toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isWinner ? Colors.amber[700] : const Color.fromARGB(255, 202, 97, 97),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
