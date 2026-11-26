import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  final String text;
  final double height;
  final Color color;
  final Color textColor;
  final bool wide;
  final VoidCallback onTap;

  const CalcButton({
    super.key,
    required this.text,
    required this.height,
    required this.color,
    required this.textColor,
    required this.onTap,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        alignment: wide ? Alignment.centerLeft : Alignment.center,
        padding: wide ? EdgeInsets.only(left: height * 0.38) : EdgeInsets.zero,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: height * 0.42,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
