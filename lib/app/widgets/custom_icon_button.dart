import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.alignment,
    this.margin,
    this.height,
    this.width,
    this.padding,
    this.decoration,
    this.child,
    this.onTap,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final EdgeInsetsGeometry? margin;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;

  final Widget? child;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: iconButtonWidget,
          )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => Padding(
        padding: margin ?? EdgeInsets.zero,
        child: SizedBox(
          height: height ?? 0,
          width: width ?? 0,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Container(
              padding: padding ?? EdgeInsets.zero,
              decoration: decoration ??
                  BoxDecoration(
                    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
                    borderRadius: BorderRadius.circular(8.h),
                    border: Border.all(
                      color: appTheme.blue10001,
                      width: 1.h,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: appTheme.black900.withOpacity(0.04),
                        spreadRadius: 2.h,
                        blurRadius: 2.h,
                        offset: Offset(
                          0,
                          0,
                        ),
                      ),
                    ],
                  ),
              child: child,
            ),
            onPressed: onTap,
          ),
        ),
      );
}

/// Extension on [CustomIconButton] to facilitate inclusion of all types of border style etc
extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get outlineCyan => BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.cyan50,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              6,
              6,
            ),
          ),
        ],
      );
  static BoxDecoration get fillPrimary => BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(4.h),
      );
  static BoxDecoration get fillOnPrimaryContainer => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        borderRadius: BorderRadius.circular(4.h),
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray5001,
        borderRadius: BorderRadius.circular(10.h),
      );
  static BoxDecoration get outlineOrange => BoxDecoration(
        color: appTheme.yellow50,
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(
          color: appTheme.orange50,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: appTheme.blue100,
        borderRadius: BorderRadius.circular(17.h),
        border: Border.all(
          color: appTheme.black900,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineBlackTL17 => BoxDecoration(
        color: appTheme.pink10001,
        borderRadius: BorderRadius.circular(17.h),
        border: Border.all(
          color: appTheme.black900,
          width: 1.h,
        ),
      );
  static BoxDecoration get gradientPrimaryToIndigo => BoxDecoration(
        borderRadius: BorderRadius.circular(16.h),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            theme.colorScheme.primary,
            appTheme.indigo700.withOpacity(0.8),
          ],
        ),
      );
  static BoxDecoration get fillBlue => BoxDecoration(
        color: appTheme.blue10001,
        borderRadius: BorderRadius.circular(12.h),
      );
  static BoxDecoration get fillIndigo => BoxDecoration(
        color: appTheme.indigo800,
        borderRadius: BorderRadius.circular(4.h),
      );
  static BoxDecoration get fillBlueTL10 => BoxDecoration(
        color: appTheme.blue80001,
        borderRadius: BorderRadius.circular(10.h),
      );
}
