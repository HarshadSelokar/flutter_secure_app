import 'package:flutter/material.dart';

/// ✅ Custom Slide Transition
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  SlidePageRoute({required Widget page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const Offset begin = Offset(1.0, 0.0); // Slide from right
      const Offset end = Offset.zero;
      const Curve curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

/// ✅ Custom Fade Transition
class FadePageRoute<T> extends PageRouteBuilder<T> {
  FadePageRoute({required Widget page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

/// ✅ Custom Scale Transition
class ScalePageRoute<T> extends PageRouteBuilder<T> {
  ScalePageRoute({required Widget page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween<double>(begin: 0.8, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut));

      return ScaleTransition(
        scale: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}
