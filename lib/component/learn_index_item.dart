import 'package:examKing/models/level.dart';
import 'package:examKing/pages/learn_word_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LearnIndexItem extends StatelessWidget {
  final Level level;
  final bool isLocked;

  const LearnIndexItem({
    super.key,
    required this.level,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: GestureDetector(
        onTap: isLocked
            ? null
            : () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LearnWordPage(level: level.level)));
              },
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isLocked ? Colors.grey : level.color,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.circle, color: Colors.white),
            ),
            const SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level.title,
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: isLocked ? Colors.grey : Colors.black,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9 - 100,
                  child: const Divider(
                    color: Color.fromARGB(196, 96, 96, 96),
                    thickness: 1,
                    height: 10,
                  ),
                ),
                Text(
                  level.description,
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 16,
                    color: isLocked ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
