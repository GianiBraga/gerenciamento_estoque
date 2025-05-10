import 'package:flutter/material.dart';

enum TransitionType { fade, slide, scale }

class PageTransitionUtil {
  static Route createRoute({
    required Widget page,
    TransitionType transitionType = TransitionType.fade,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transitionType) {
          case TransitionType.fade:
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          case TransitionType.slide:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0), // Começa da direita
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          case TransitionType.scale:
            final scaleAnimation = Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ));

            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(animation);

            return FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );
        }
      },
      transitionDuration: duration,
    );
  }
}
