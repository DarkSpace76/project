import 'package:flutter/material.dart';
import 'package:project/utils/const.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(bgPath), fit: BoxFit.fill),
          ),
        ),
        child,
      ],
    );
  }
}
