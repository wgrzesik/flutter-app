import 'package:flutter/material.dart';
import 'package:note_app/feature/presentation/cubit/auth/auth_cubit.dart';
import 'package:note_app/feature/presentation/cubit/note/note_cubit.dart';
import 'package:note_app/feature/presentation/cubit/stats/stats_cubit.dart';
import 'package:note_app/on_generate_route.dart';
import 'feature/presentation/cubit/flashcard/flashcard_cubit.dart';
import 'feature/presentation/cubit/set/set_cubit.dart';
import 'feature/presentation/cubit/user/user_cubit.dart';
import 'feature/presentation/pages/home_page.dart';
import 'injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/feature/presentation/pages/sign_in_page.dart';

import 'on_generate_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
            create: (_) => di.sl<AuthCubit>()..appStarted()),
        BlocProvider<UserCubit>(create: (_) => di.sl<UserCubit>()),
        BlocProvider<NoteCubit>(create: (_) => di.sl<NoteCubit>()),
        BlocProvider<SetCubit>(create: (_) => di.sl<SetCubit>()),
        BlocProvider<FlashcardCubit>(create: (_) => di.sl<FlashcardCubit>()),
        BlocProvider<StatsCubit>(create: (_) => di.sl<StatsCubit>()),
      ],
      child: MaterialApp(
          title: 'FlashcardWizard',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            fontFamily: 'Montserrat',
          ),
          initialRoute: '/',
          onGenerateRoute: OnGenerateRoute.route,
          routes: {
            "/": (context) {
              return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                if (authState is Authenticated) {
                  return FlashcardHomePage(uid: authState.uid);
                }
                if (authState is UnAuthenticated) {
                  return SignInPage();
                }
                return CircularProgressIndicator();
              });
            }
          }),
    );
  }
}
