import 'dart:async';

import 'package:examKing/blocs/main/main_bloc.dart';
import 'package:examKing/models/user.dart';
import 'package:examKing/pages/ability_analyse_page.dart';
import 'package:examKing/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:examKing/component/main_page_button.dart';
import 'package:examKing/pages/index_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late MainBloc mainBloc;
  late StreamSubscription mainBlocListener;
  late UserData user;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();

  ImageProvider backgroundImageProvider = const NetworkImage('https://media.tenor.com/bx7hbOEm4gMAAAAj/sakura-leaves.gif');

  @override
  void initState() {
    super.initState();

    mainBloc = context.read<MainBloc>();
    mainBlocListener = mainBloc.stream.listen((state) {
      if (state is MainStateUpdateUserName) {
        setState(() {});
      }
    });

    user = context.read<UserProvider>().userData!;
    _nameController.text = user.name;

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
    _nameController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

              // TODO: show win rate chart as carousal
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
                  if (_isEditing)
                    SizedBox(
                      width: 200,
                      child: TextField(
                        autofocus: true,
                        onTapOutside: (event) {
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        controller: _nameController,
                        style: GoogleFonts.girassol(
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            mainBloc.add(MainEventUpdateUserName(name: value.trim()));
                            setState(() {
                              _isEditing = false;
                            });
                          }
                        },
                      ),
                    )
                  else
                    Text(
                      user.name,
                      style: GoogleFonts.girassol(
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(width: 9),
                  if (!_isEditing)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEditing = true;
                        });
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
                  _buildRecordCard('勝', user.winRecord, Colors.black),
                  const SizedBox(width: 20),
                  _buildRecordCard('敗', user.loseRecord, Colors.black),
                ],
              ),
              const SizedBox(height: 70),
              // Ability Analysis Button
              MainPageButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AbilityAnalysePage(),
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

  Widget _buildRecordCard(String title, int count, Color color) {
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
            count.toString(),
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
