import 'package:flutter/material.dart';

/// Enum that defines available transition types for route changes.
enum TransitionType { fade, slide, scale }

/// Utility class to create custom page transitions when navigating between screens.
class PageTransitionUtil {
  /// Creates a [Route] with the specified transition effect and duration.
  ///
  /// [page] → The target screen to display.
  /// [transitionType] → Type of animation (fade, slide, scale).
  /// [duration] → Duration of the transition animation.
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
            // Simple opacity transition
            return FadeTransition(
              opacity: animation,
              child: child,
            );

          case TransitionType.slide:
            // Slide from right to left
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );

          case TransitionType.scale:
            // Combined scale and fade-in transition
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
