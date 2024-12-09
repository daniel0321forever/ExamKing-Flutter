import 'package:flutter/material.dart';
import 'package:examKing/pages/main_page.dart';

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
