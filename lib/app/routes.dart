import 'package:flutter/material.dart';
import '../features/splash/splash_screen.dart';
import '../features/home/home_screen.dart';
import '../features/nearby_animals/nearby_animals_screen.dart';
import '../features/communication/communication_screen.dart';
import '../features/history/history_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/about/about_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String nearbyAnimals = '/nearby-animals';
  static const String communication = '/communication';
  static const String history = '/history';
  static const String settings = '/settings';
  static const String about = '/about';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        home: (context) => const HomeScreen(),
        nearbyAnimals: (context) => const NearbyAnimalsScreen(),
        communication: (context) => const CommunicationScreen(),
        history: (context) => const HistoryScreen(),
        settings: (context) => const SettingsScreen(),
        about: (context) => const AboutScreen(),
      };
}
