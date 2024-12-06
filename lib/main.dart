import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:examKing/blocs/auth/auth_bloc.dart';
import 'package:examKing/blocs/battle/battle_bloc.dart';
import 'package:examKing/blocs/index/index_bloc.dart';
import 'package:examKing/blocs/main/main_bloc.dart';
import 'package:examKing/pages/login_page.dart';
import 'package:examKing/pages/main_page.dart';
import 'package:examKing/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(userProvider: context.read<UserProvider>())),
          BlocProvider(create: (context) => BattleBloc(userProvider: context.read<UserProvider>())),
          BlocProvider(create: (context) => IndexBloc()),
          BlocProvider(create: (context) => MainBloc()),
        ],
        child: MaterialApp(
          title: 'Exam King',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a purple toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 202, 0, 0)).copyWith(
              surface: Color.fromARGB(255, 255, 234, 245),
            ),
            useMaterial3: true,
          ),
          home: const LoginPage(),
        ),
      ),
    );
  }
}
