import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'authentication_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ✅ Background Image
          Positioned.fill(
            child: Image.asset("assets/images/welcome_bg.jpg", fit: BoxFit.cover),
          ),

          /// ✅ Welcome Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Secure Data App",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ).animate().fade(duration: 600.ms),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: const Text(
                  "Your data, fully protected with the highest security standards.",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ).animate().fade(duration: 700.ms),
              ),

              const SizedBox(height: 40),

              /// ✅ Animated Get Started Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthenticationPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Get Started", style: TextStyle(fontSize: 18)),
              ).animate().scale(duration: 600.ms),
            ],
          ),
        ],
      ),
    );
  }
}
