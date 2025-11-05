import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/styles/colors.dart';

Widget _buttonTmp({
  required Widget child,
  Gradient? gradient,
  Color? color,
  Function()? onPress,
}) {
  return CupertinoButton(
    padding: EdgeInsets.zero,
    onPressed: onPress,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: gradient,
        color: onPress == null ? btnDisable : color,
      ),
      width: double.infinity,
      height: 48,
      alignment: AlignmentGeometry.center,
      child: child,
    ),
  );
}

Widget gradientButton({required String caption, Function()? onPress}) {
  return _buttonTmp(
    onPress: onPress,
    gradient: btnBgGradient,
    child: Text(
      caption,
      style: TextStyle(color: textGradientButton, fontWeight: FontWeight.w500),
    ),
  );
}

Widget fillButton({required String caption, Function()? onPress}) {
  return _buttonTmp(
    onPress: onPress,
    color: btnBgWhite,
    child: Text(
      caption,
      style: TextStyle(color: textFillButton, fontWeight: FontWeight.w500),
    ),
  );
}
