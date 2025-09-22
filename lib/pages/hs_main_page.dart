import 'package:examKing/component/back_to_main_button.dart';
import 'package:examKing/component/learn_index_item.dart';
import 'package:examKing/global/properties.dart';
import 'package:examKing/models/level.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HSMainPage extends StatelessWidget {
  const HSMainPage({super.key});

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
        // Title for the section
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "HS7000 Learning Categories",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Display each level with the first book (book 0) as representative
        for (int lv = 0; lv < hsLevels.length; lv++)
          LevelBoard(levels: hsLevels[lv]),
      ],
    );
  }
}

class LevelBoard extends StatefulWidget {
  final List<Level> levels;
  const LevelBoard({super.key, required this.levels});

  @override
  State<LevelBoard> createState() => _LevelBoardState();
}

class _LevelBoardState extends State<LevelBoard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Level mainLevel = widget.levels[0];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // expand/collapse button
                  GestureDetector(
                    onTap: _toggleExpanded,
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: mainLevel.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: AnimatedRotation(
                        turns: _isExpanded ? 0.25 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.chevron_right,
                          size: 38,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),

                  // title
                  const SizedBox(width: 10),
                  Text(
                    mainLevel.title.split('-').first.trim(),
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // description
              const SizedBox(height: 6),
              Text(
                mainLevel.description,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: SizeTransition(
              sizeFactor: _expandAnimation,
              child: _isExpanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final level in widget.levels)
                          HSLearnIndexItem(level: level),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
