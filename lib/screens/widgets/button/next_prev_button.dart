import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iyc/utils/constants.dart';

class NextPrevButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final Color? color;
  final Color labelColor;
  final double? width;
  final double? height;

  const NextPrevButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.color,
    this.width,
    this.height,
    this.labelColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: color ?? Constants.themeGradientsMain[0],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: labelColor)),
      child: TextButton(
          onPressed: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: labelColor, fontWeight: FontWeight.w500),
                  )
                ]),
          )),
    );
  }
}
