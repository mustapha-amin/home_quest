import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/auth/view/auth_screen.dart';
import 'package:home_quest/firebase_options.dart';
import 'package:home_quest/services/onboarding_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'core/providers.dart';
import 'features/onboarding/view/onboarding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure the app is displayed in fullscreen mode
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [], );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Sizer(builder: (___, _, __) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ref.watch(onBoardingSettingsProvider).isFirstTime() ? const OnboardingScreen() : const AuthScreen(),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
      );
    });
  }
}
