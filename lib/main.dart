import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/auth/view/auth_screen.dart';
import 'package:home_quest/firebase_options.dart';
import 'package:home_quest/services/onboarding_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/providers.dart';
import 'features/onboarding/view/onboarding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const supabaseUrl = 'https://avbxbdkxmucgvtlftcwh.supabase.co';
  const supabaseKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF2YnhiZGt4bXVjZ3Z0bGZ0Y3doIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE4MTkwNzAsImV4cCI6MjA0NzM5NTA3MH0.4eMqMuPsZOhl0Rk_ztpScXTmA8iqagzkiY0LfRw9_pA";
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
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
        home: ref.watch(onBoardingSettingsProvider).isFirstTime()
            ? const OnboardingScreen()
            : const AuthScreen(),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
      );
    });
  }
}
