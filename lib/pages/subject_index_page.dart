import 'package:examKing/component/back_to_main_button.dart';
import 'package:examKing/models/subject.dart';
import 'package:examKing/pages/gre_main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:expandable_page_view/expandable_page_view.dart';

const List<Subject> subjects = [
  Subject(
    name: "GRE",
    key: "gre",
    color: Color.fromARGB(255, 138, 170, 196),
    subColor: Color.fromARGB(255, 8, 60, 105),
    progress: 0.3,
    intro: "GRE常見1000單字",
    icon: Icons.grade,
    linkedPage: GREMainPage(),
  ),
  Subject(
    name: "7000單",
    key: "7000",
    color: Color.fromARGB(255, 255, 195, 66),
    subColor: Color.fromARGB(255, 176, 120, 0),
    progress: 0.5,
    intro: "學測、分科必備英文單字",
    icon: Icons.book,
    linkedPage: GREMainPage(),
  ),
  // Subject(
  //   name: "MATH",
  //   key: "toefl",
  //   color: Color.fromARGB(255, 119, 181, 145),
  //   subColor: Color.fromARGB(255, 0, 30, 57),
  //   progress: 0.6,
  //   intro: "開發中...",
  //   icon: Icons.calculate,
  //   linkedPage: GREMainPage(),
  // ),
  // Subject(
  //   name: "Biology",
  //   key: "sat",
  //   color: Color.fromARGB(255, 181, 132, 119),
  //   subColor: Color.fromARGB(255, 0, 30, 57),
  //   progress: 0.8,
  //   intro: "開發中...",
  //   icon: Icons.book,
  //   linkedPage: GREMainPage(),
  // ),
];

class SubjectIndexPage extends StatefulWidget {
  const SubjectIndexPage({super.key});

  @override
  State<SubjectIndexPage> createState() => _SubjectIndexPageState();
}

class _SubjectIndexPageState extends State<SubjectIndexPage> {
  late final ScrollController subjectListScrollController;
  late final PageController subjectItemPageController;

  double subjectOptionWidth = 170.0;
  int currentSubjectIndex = 1;

  @override
  void initState() {
    super.initState();

    subjectListScrollController = ScrollController(initialScrollOffset: 200);
    subjectItemPageController =
        PageController(initialPage: currentSubjectIndex);

    subjectListScrollController.addListener(() {
      int newSubjectIndex =
          subjectListScrollController.offset ~/ subjectOptionWidth;

      if (newSubjectIndex != currentSubjectIndex) {
        setState(() {
          currentSubjectIndex =
              subjectListScrollController.offset ~/ subjectOptionWidth;
          subjectItemPageController.animateToPage(currentSubjectIndex,
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear);
        });
      }
    });
  }

  @override
  void dispose() {
    subjectListScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const AnimatedBackButton(),
              const SizedBox(height: 35),
              ExpandablePageView.builder(
                itemCount: subjects.length,
                reverse: true,
                controller: subjectItemPageController,
                onPageChanged: (index) {
                  setState(() {
                    subjectListScrollController.animateTo(
                        index * subjectOptionWidth,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  });
                },
                itemBuilder: (context, index) {
                  return SubjectCard(subject: subjects[index]);
                },
              ),
              const SizedBox(height: 15),
              _buildSubjectList(context),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectList(BuildContext context) {
    // To create a horizontal wheel effect, we use a RotatedBox to rotate the ListWheelScrollView,
    // and then rotate each child back to upright.
    return SizedBox(
      height: 170,
      // width: MediaQuery.of(context).size.width,
      child: RotatedBox(
        quarterTurns: 1,
        child: ListWheelScrollView.useDelegate(
          controller: subjectListScrollController,
          itemExtent: 170,
          physics: const BouncingScrollPhysics(),
          perspective: 0.01,
          diameterRatio: 3.0,
          offAxisFraction: 0.8,
          squeeze: 1.1,
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              if (index < 0 || index >= subjects.length) return null;
              final subject = subjects[index];
              return RotatedBox(
                quarterTurns: 3,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Divider(
                      height: 32,
                      thickness: 2,
                      color: Colors.grey.shade300,
                    ),
                    Text(
                      subject.name,
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: index == currentSubjectIndex
                            ? Colors.black
                            : Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              );
            },
            childCount: subjects.length,
          ),
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final Subject subject;
  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: subject.color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          // icon
          Icon(subject.icon, size: 60, color: subject.color),

          // title
          Text(
            subject.name,
            style: GoogleFonts.barlowCondensed(
              fontSize: 70,
              fontWeight: FontWeight.bold,
              color: subject.color,
            ),
          ),

          // intro
          Text(
            subject.intro,
            textAlign: TextAlign.center,
            style: GoogleFonts.barlowCondensed(
              fontSize: 22,
              color: subject.subColor.withValues(alpha: 0.3),
            ),
          ),

          // progress
          const SizedBox(height: 30),
          _buildProgressBar(context, subject),

          // button
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => subject.linkedPage));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                color: subject.color.withValues(alpha: 0.5),
                border: Border.all(
                  color: const Color.fromARGB(255, 254, 254, 254),
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "START",
                style: GoogleFonts.mandali(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, Subject subject) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 17,
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: subject.color.withValues(alpha: 0.2),
          ),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 17,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade200,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                width:
                    MediaQuery.of(context).size.width * 0.6 * subject.progress,
                height: 17,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(102, 146, 146, 146),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
