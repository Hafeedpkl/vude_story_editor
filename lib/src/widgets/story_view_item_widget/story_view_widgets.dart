import 'package:flutter/material.dart';

class StoryViewLoadingwidget extends StatelessWidget {
  const StoryViewLoadingwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 70,
      height: 70,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 3,
      ),
    );
  }
}
