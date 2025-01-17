import 'package:examKing/pages/setting_page.dart';
import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  const AccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SettingPage(),
        ));
      },
      child: CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage('assets/player1.webp'),
      ),
    );
  }
}
