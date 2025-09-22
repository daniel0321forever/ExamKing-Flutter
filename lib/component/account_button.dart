import 'package:examKing/pages/setting_page.dart';
import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  final double radius;
  const AccountButton({super.key, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SettingPage(),
        ));
      },
      child: CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage('assets/player1.webp'),
      ),
    );
  }
}
