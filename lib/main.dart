import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/auth/view/auth_screen.dart';
import 'package:sizer/sizer.dart';

import 'features/onboarding/view/onboarding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (___, _, __) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const OnboardingScreen(),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
      );
    });
  }
}
