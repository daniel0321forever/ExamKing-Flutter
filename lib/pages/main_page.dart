import 'dart:async';

import 'package:examKing/blocs/auth/auth_bloc.dart';
import 'package:examKing/blocs/main/main_bloc.dart';
import 'package:examKing/component/account_button.dart';
import 'package:examKing/component/histogram.dart';
import 'package:examKing/component/logout_icon.dart';
import 'package:examKing/models/user.dart';
import 'package:examKing/pages/ability_analyse_page.dart';
import 'package:examKing/pages/gre_main_page.dart';
import 'package:examKing/pages/login_page.dart';
import 'package:examKing/pages/subject_index_page.dart';
import 'package:examKing/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:examKing/component/main_page_button.dart';
import 'package:examKing/pages/battle_index_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late MainBloc mainBloc;
  late StreamSubscription mainBlocListener;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    mainBloc = context.read<MainBloc>();
    mainBloc.add(MainEventInitialize());
    mainBloc.add(MainEventGetDailyProgress());

    mainBlocListener = mainBloc.stream.listen((state) {
      if (state is MainStateInitialized) {
        setState(() {});
      } else if (state is MainStateInitializing) {
        setState(() {});
      }
    });

    // Initialize animation controller for the loading text
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the repeating animation
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!mainBloc.isWordInitialized) {
      return buildInitLoading();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 100),

                  // title
                  Text(
                    "Daily Words Progress",
                    style: GoogleFonts.barlowCondensed(
                        color: Colors.black, fontSize: 27),
                  ),
                  const SizedBox(height: 15),

                  // histogram
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AbilityAnalysePage(),
                      ));
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Histogram(),
                    ),
                  ),

                  // learn words button
                  const SizedBox(height: 100),
                  MainPageButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SubjectIndexPage(),
                      ));
                    },
                    title: "LEARN",
                    backgroundColor: const Color.fromARGB(255, 158, 199, 231),
                    textColor: const Color.fromARGB(255, 0, 0, 0),
                  ),

                  // Battle Arena Button
                  const SizedBox(height: 30),
                  MainPageButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const BattleIndexPage(),
                      ));
                    },
                    backgroundColor: const Color.fromARGB(255, 255, 219, 141),
                    textColor: const Color.fromARGB(255, 175, 108, 1),
                    title: "BATTLE",
                  ),
                ],
              ),
            ),
            const Positioned(
              top: 15,
              right: 15,
              child: AccountButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInitLoading() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AccountButton(radius: 80),
          const SizedBox(
            height: 20,
            width: double.infinity,
          ),
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Text(
                  "Syncing...",
                  style: GoogleFonts.barlowCondensed(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
