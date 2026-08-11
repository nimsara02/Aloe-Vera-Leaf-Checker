import 'package:flutter/material.dart';
import 'system_controller.dart';

class SessionWrapper extends StatelessWidget {
  final Widget child;

  const SessionWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        // Reset timer whenever user taps screen
        SystemController.instance.resetSessionTimer(context);
      },
      child: child,
    );
  }
}