import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';

// ignore: must_be_immutable
class AppbarSubtitle9 extends StatelessWidget {
  AppbarSubtitle9({
    Key? key,
    required this.text,
    this.margin,
    this.onTap,
  }) : super(
          key: key,
        );

  String text;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Container(
          padding: EdgeInsets.all(4.h),
          decoration: AppDecoration.fillPrimary.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder2,
          ),
          child: Text(
            text,
            style: CustomTextStyles.bodyMediumGray5001.copyWith(
              color: appTheme.gray5001,
            ),
          ),
        ),
      ),
    );
  }
}
