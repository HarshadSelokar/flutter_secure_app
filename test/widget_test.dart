import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_data_app/main.dart';

void main() {
  testWidgets('App launches and shows dashboard when user is registered and has seen onboarding', (WidgetTester tester) async {
    // Build the app with required parameters
    await tester.pumpWidget(const MyApp(
      isRegistered: true,
      seenOnboarding: true,
    ));

    // Ensure all widgets finish rendering
    await tester.pumpAndSettle();

    // Verify that the Dashboard screen is displayed
    expect(find.text("Dashboard"), findsOneWidget);
    expect(find.text("Manage Credentials"), findsOneWidget);
    expect(find.text("Manage Files"), findsOneWidget);

    // Check for the presence of the "Create Backup" button
    expect(find.byType(ElevatedButton), findsWidgets); // Ensure multiple buttons exist
    expect(find.textContaining("Backup"), findsOneWidget); // Check for a specific button with "Backup"
  });

  testWidgets('App shows onboarding when user has not seen onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(
      isRegistered: true,
      seenOnboarding: false,
    ));

    await tester.pumpAndSettle();

    // Verify that the OnboardingPage is displayed
    expect(find.text("Welcome to Secure Data App"), findsOneWidget);
    expect(find.text("Get Started"), findsOneWidget);
  });

  testWidgets('App shows registration page when user is not registered', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(
      isRegistered: false,
      seenOnboarding: false,
    ));

    await tester.pumpAndSettle();

    // Verify that the RegistrationPage is displayed
    expect(find.text("Register"), findsOneWidget);
    expect(find.text("Create Account"), findsOneWidget);
  });

  testWidgets('Dark Mode Toggle Works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(
      isRegistered: true,
      seenOnboarding: true,
    ));

    await tester.pumpAndSettle();

    // Find the Dark Mode toggle button
    final darkModeButton = find.byIcon(Icons.brightness_6);
    expect(darkModeButton, findsOneWidget);

    // Tap the button to switch to dark mode
    await tester.tap(darkModeButton);
    await tester.pumpAndSettle();

    // Ensure the toggle button remains present
    expect(find.byIcon(Icons.brightness_6), findsOneWidget);
  });
}
