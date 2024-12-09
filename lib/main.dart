import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:examKing/blocs/auth/auth_bloc.dart';
import 'package:examKing/blocs/battle/battle_bloc.dart';
import 'package:examKing/blocs/index/index_bloc.dart';
import 'package:examKing/blocs/main/main_bloc.dart';
import 'package:examKing/pages/login_page.dart';
import 'package:examKing/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load();
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
          BlocProvider(create: (context) => MainBloc(userProvider: context.read<UserProvider>())),
        ],
        child: MaterialApp(
          title: '考試王',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 202, 0, 0)).copyWith(
              surface: const Color.fromARGB(255, 255, 234, 245),
            ),
            useMaterial3: true,
          ),
          home: const LoginPage(),
        ),
      ),
    );
  }
}
