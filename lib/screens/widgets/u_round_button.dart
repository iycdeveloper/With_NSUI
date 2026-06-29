import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iyc/utils/constants.dart';

class URoundButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final Color? color;
  final Color labelColor;
  final double? width;
  final double? height;
  final String? svgIcon;
final EdgeInsetsGeometry? margin;
  const URoundButton(
      {Key? key,
      required this.title,
      required this.onTap,
      this.color,
      this.width,
      this.margin,
      this.height,
      this.labelColor = Colors.white,
      this.svgIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      height: height ??
          ((MediaQuery.of(context).size.height / 11) < 70
              ? 70
              : (MediaQuery.of(context).size.height / 11)),
      margin: margin??EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
          color: color ?? Constants.themeGradientsMain[0],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: labelColor)),
      child: TextButton(
          onPressed: onTap,
          child: Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  svgIcon != null
                      ? Container(
                          margin: EdgeInsets.only(right: 8),
                          child: SvgPicture.asset(
                            svgIcon!,
                            color: labelColor,
                            height: 18,
                          ))
                      : Container(),
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
