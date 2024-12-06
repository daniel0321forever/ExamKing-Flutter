import 'package:flutter/material.dart';
import 'package:examKing/component/main_page_button.dart';
import 'package:examKing/pages/index_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  ImageProvider backgroundImageProvider = const NetworkImage('https://media.tenor.com/bx7hbOEm4gMAAAAj/sakura-leaves.gif');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRadarChart() {
    Color mainColor = const Color.fromARGB(209, 255, 228, 228);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.8,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          radarBackgroundColor: const Color.fromARGB(94, 110, 110, 110),
          ticksTextStyle: const TextStyle(
            color: Colors.transparent,
          ),
          tickBorderData: BorderSide(
            color: mainColor,
            width: 0.5,
          ),
          gridBorderData: BorderSide(
            color: Colors.white.withOpacity(0.5),
            width: 2,
          ),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'PressStart2P',
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 3,
                offset: Offset(2, 2),
              ),
            ],
          ),
          dataSets: [
            RadarDataSet(
              fillColor: const Color.fromARGB(255, 255, 102, 91).withOpacity(0.5),
              borderColor: Colors.white,
              entryRadius: 5,
              borderWidth: 2,
              dataEntries: [
                const RadarEntry(value: 80), // Mathematics
                const RadarEntry(value: 70), // English
                const RadarEntry(value: 90), // Science
                const RadarEntry(value: 85), // Social Studies
                const RadarEntry(value: 75), // Chinese
              ],
            ),
          ],
          getTitle: (index, angle) {
            switch (index) {
              case 0:
                return RadarChartTitle(text: '高中', angle: angle);
              case 1:
                return RadarChartTitle(text: '大學', angle: angle);
              case 2:
                return RadarChartTitle(text: 'Sanrio', angle: angle);
              case 3:
                return RadarChartTitle(text: '娛樂', angle: angle);
              case 4:
                return RadarChartTitle(text: '語言', angle: angle);
              default:
                return const RadarChartTitle(text: '');
            }
          },
          borderData: FlBorderData(
            show: false,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          tickCount: 5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: backgroundImageProvider,
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              // User Avatar
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/player1.webp'),
                ),
              ),
              const SizedBox(height: 20),

              // username
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Daniel",
                    style: GoogleFonts.girassol(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 9),
                  GestureDetector(
                    onTap: () {
                      // Handle edit button press
                    },
                    child: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Win/Lose Record
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRecordCard('勝', '23', Colors.black),
                  const SizedBox(width: 20),
                  _buildRecordCard('敗', '12', Colors.black),
                ],
              ),
              const SizedBox(height: 70),
              // Ability Analysis Button
              MainPageButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const IndexPage(),
                  ));
                },
                title: "能力分析",
                backgroundColor: Colors.red,
                textColor: const Color.fromARGB(255, 185, 0, 0),
              ),
              const SizedBox(height: 30),
              // Battle Arena Button
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: MainPageButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const IndexPage(),
                        ));
                      },
                      title: "進入競技場",
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.yuseiMagic(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: GoogleFonts.yuseiMagic(
              fontSize: 24,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
