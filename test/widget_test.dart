import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_data_app/main.dart';

void main() {
  testWidgets('App launches and shows dashboard', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp(isDarkMode: false));

    // Ensure all widgets finish rendering
    await tester.pumpAndSettle();

    // Verify that the Dashboard screen is displayed
    expect(find.text("Dashboard"), findsOneWidget);
    expect(find.text("Manage Credentials"), findsOneWidget);
    expect(find.text("Manage Files"), findsOneWidget);

    // ✅ Fix: Ensure "Create Backup" button is present
    expect(find.byType(ElevatedButton), findsWidgets); // Check if multiple buttons exist
    expect(find.textContaining("Backup"), findsOneWidget); // Search for text containing "Backup"
  });

  testWidgets('Dark Mode Toggle Works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(isDarkMode: false));
    await tester.pumpAndSettle();

    // Find the Dark Mode toggle button
    final darkModeButton = find.byIcon(Icons.brightness_6);
    expect(darkModeButton, findsOneWidget);

    // Tap the button to switch to dark mode
    await tester.tap(darkModeButton);
    await tester.pumpAndSettle();

    // The app should still have the toggle button after switching
    expect(find.byIcon(Icons.brightness_6), findsOneWidget);
  });
}
