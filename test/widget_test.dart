import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animal_talk_ai/app/app.dart';
import 'package:animal_talk_ai/core/providers/service_providers.dart';

void main() {
  testWidgets('AnimalTalk AI app launches to SplashScreen and renders brand title', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const AnimalTalkApp(),
      ),
    );

    // Verify SplashScreen renders
    expect(find.text('faunanova-ai'), findsOneWidget);
    expect(find.text('Listen. Understand. Communicate.'), findsOneWidget);

    // Fast-forward animation & auto-navigation timer
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    // Verify navigated to HomeScreen
    expect(find.text('Real-Time Animal\nCommunication'), findsOneWidget);
    expect(find.text('START COMMUNICATION'), findsOneWidget);
  });
}
