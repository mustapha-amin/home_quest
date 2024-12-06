import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_quest/core/colors.dart';
import 'package:home_quest/features/auth/view/auth_screen.dart';
import 'package:home_quest/features/auth/view/home_user_wrapper.dart';
import 'package:home_quest/firebase_options.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/models/client.dart';
import 'package:home_quest/models/user.dart';
import 'package:home_quest/services/onboarding_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'core/providers.dart';
import 'features/onboarding/view/onboarding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AgentModelAdapter());
  Hive.registerAdapter(ClientModelAdapter());
  await Hive.openBox<User>('userBox');
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

ValueNotifier<Key> myAppKey = ValueNotifier(UniqueKey());

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Sizer(builder: (___, _, __) {
      return ValueListenableBuilder(
          valueListenable: myAppKey,
          builder: (context, keyVal, _) {
            return MaterialApp(
              key: keyVal,
              debugShowCheckedModeBanner: false,
              home: ref.watch(onBoardingSettingsProvider).isFirstTime()
                  ? const OnboardingScreen()
                  : ref.watch(authChangesProvider).when(
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
            );
          });
    });
  }
}
