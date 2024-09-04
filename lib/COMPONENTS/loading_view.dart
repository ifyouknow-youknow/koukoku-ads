import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/blur_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: BlurView(
        intensity: 3,
        color: Color.fromARGB(183, 20, 19, 19),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextView(
                text: "One moment please...",
                color: Colors.white,
                size: 16,
              ),
              SizedBox(
                height: 10,
              ),
              CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
