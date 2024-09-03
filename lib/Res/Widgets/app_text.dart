import 'package:flutter/material.dart';


class AppText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? fontSize;
  final double? height;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  const AppText({
    super.key,
    required this.text,
    this.textColor,
    this.fontSize,
    this.fontWeight, this.height, this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(

      text,
      textAlign: textAlign,
      style: TextStyle(
          fontWeight: fontWeight ?? FontWeight.w400,
          fontSize: fontSize ?? 14,
          color: textColor ?? Colors.black,
          height: height,
        ),
    );
  }
}
