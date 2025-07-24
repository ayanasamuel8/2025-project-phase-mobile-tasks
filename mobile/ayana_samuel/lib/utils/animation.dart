import 'package:flutter/material.dart';

class Animate {
  static Route createSlideUpRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // The Tween defines the start and end points of the slide
        const begin = Offset(0.0, 1.0); // Start from the bottom
        const end = Offset.zero; // End at the top
        const curve = Curves.easeOut; // A nice easing curve

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  static Route createFadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // The FadeTransition widget handles the animation based on the controller
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
