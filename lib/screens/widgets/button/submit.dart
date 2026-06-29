import 'package:flutter/material.dart';
import 'package:iyc/utils/constants.dart';

class SubmitButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final Color? color;
  final Color labelColor;

  const SubmitButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.color,
    this.labelColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: color ?? Constants.themeGradientsMain[0],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: labelColor)),
      child: TextButton(
          onPressed: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: labelColor, fontWeight: FontWeight.w500),
            ),
          )),
    );
  }
}
