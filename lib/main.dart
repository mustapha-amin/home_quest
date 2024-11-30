import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_quest/core/colors.dart';
import 'package:home_quest/features/auth/view/auth_screen.dart';
import 'package:home_quest/features/auth/view/home_username_wrapper.dart';
import 'package:home_quest/firebase_options.dart';
import 'package:home_quest/services/onboarding_settings.dart';
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
            : Stack(
                alignment: Alignment.center,
                children: [
                  ref.watch(authChangesProvider).when(
                        data: (user) {
                          if (user != null) {
                            return const HomeUserDataWrapper();
                          } else {
                            return const AuthScreen();
                          }
                        },
                        error: (_, __) => const AuthScreen(),
                        loading: () => const SizedBox(),
                      ),
                  if (ref.watch(isLoading))
                    const Material(
                      child: Center(
                        child: SpinKitWaveSpinner(
                          size: 80,
                          color: Color.fromARGB(255, 70, 41, 0),
                        ),
                      ),
                    )
                ],
              ),
      
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: AppColors.brown,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black,
            enableFeedback: false,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      );
    });
  }
}
