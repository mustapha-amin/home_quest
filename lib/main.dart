import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/colors.dart';
import 'package:home_quest/features/auth/view/auth_screen.dart';
import 'package:home_quest/features/auth/view/home_user_wrapper.dart';
import 'package:home_quest/firebase_options.dart';
import 'package:home_quest/services/onboarding_settings.dart';
import 'package:home_quest/shared/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'core/providers.dart';
import 'features/onboarding/view/onboarding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent));
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(sharedPreferences),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MyApp(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.brown),
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black,
            enableFeedback: false,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Sizer(
      builder: (___, _, __) {
        if (ref.watch(onBoardingSettingsProvider).isFirstTime()) {
          return const OnboardingScreen();
        }
        return ref.watch(authChangesProvider).when(
              data: (user) {
                if (user != null) {
                  return const HomeUserDataWrapper();
                } else {
                  return const AuthScreen();
                }
              },
              error: (_, __) => const AuthScreen(),
              loading: () => const LoadingScreen(),
            );
      },
    );
  }
}
