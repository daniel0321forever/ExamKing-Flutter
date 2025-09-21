import 'package:examKing/component/back_to_main_button.dart';
import 'package:examKing/component/learn_index_item.dart';
import 'package:examKing/global/properties.dart';
import 'package:examKing/pages/learn_word_page.dart';
import 'package:flutter/material.dart';

class GREMainPage extends StatelessWidget {
  const GREMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const AnimatedBackButton(),
              const SizedBox(height: 30),

              // level list
              _buildLevelList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelList() {
    return Column(
      children: [
        for (int lv = 0; lv < levels.length; lv++)
          LearnIndexItem(level: levels[lv]),
      ],
    );
  }
}
