import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'welcome_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final storage = const FlutterSecureStorage();

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Welcome to Secure Data App",
      "description": "Store and manage your sensitive data securely.",
      "image": "assets/images/security.png",
    },
    {
      "title": "Easy File & Credential Management",
      "description": "Store, retrieve, and secure your credentials with ease.",
      "image": "assets/images/credentials.png",
    },
    {
      "title": "Your Data, Encrypted & Safe",
      "description": "AES-256 encryption keeps your data protected.",
      "image": "assets/images/encryption.png",
    },
  ];

  /// ✅ Save onboarding completion status
  Future<void> _completeOnboarding() async {
    await storage.write(key: "seen_onboarding", value: "true");
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildOnboardingPage(
                  _onboardingData[index]["image"]!,
                  _onboardingData[index]["title"]!,
                  _onboardingData[index]["description"]!,
                );
              },
            ),
          ),

          /// ✅ Page Indicator & Navigation Buttons
          _buildBottomControls(),
        ],
      ),
    );
  }

  /// ✅ Onboarding Page UI with Animation
  Widget _buildOnboardingPage(String imagePath, String title, String description) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath, height: 250)
            .animate()
            .fade(duration: 600.ms)
            .scaleXY(begin: 0.8, end: 1.0, duration: 800.ms),
        const SizedBox(height: 30),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ).animate().fade(duration: 700.ms),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ).animate().fade(duration: 800.ms),
      ],
    );
  }

  /// ✅ Bottom Controls: Page Indicator & Navigation Buttons
  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// ✅ Skip Button
          if (_currentPage < _onboardingData.length - 1)
            TextButton(
              onPressed: _completeOnboarding,
              child: const Text("Skip"),
            ).animate().fade(duration: 500.ms),

          /// ✅ Page Indicator
          Row(
            children: List.generate(
              _onboardingData.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index ? 20 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.blueAccent : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ).animate().fade(duration: 500.ms),

          /// ✅ Next / Done Button
          ElevatedButton(
            onPressed: () {
              if (_currentPage == _onboardingData.length - 1) {
                _completeOnboarding();
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              }
            },
            child: Text(_currentPage == _onboardingData.length - 1 ? "Done" : "Next"),
          ).animate().fade(duration: 600.ms),
        ],
      ),
    );
  }
}
