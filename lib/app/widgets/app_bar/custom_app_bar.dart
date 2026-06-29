import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.height,
    this.styleType,
    this.leadingWidth,
    this.leading,
    this.title,
    this.centerTitle,
    this.actions,
    this.bottom,
  }) : super(
          key: key,
        );

  final double? height;

  final Style? styleType;

  final double? leadingWidth;

  final Widget? leading;

  final Widget? title;

  final bool? centerTitle;

  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: height ?? 54.v,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: _getStyle(),
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size(
        mediaQueryData.size.width,
        height ?? 54.v,
      );

  _getStyle() {
    switch (styleType) {
      case Style.bgOutline_1:
        return Container(
          height: 44.v,
          width: 333.h,
          margin: EdgeInsets.symmetric(horizontal: 1.h),
          decoration: BoxDecoration(
            color: appTheme.gray5001,
            border: Border(
              bottom: BorderSide(
                color: appTheme.blue10001,
                width: 1.h,
              ),
            ),
          ),
        );
      case Style.bgFill_1:
        return Container(
          height: 60.v,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: appTheme.indigo800,
          ),
        );
      case Style.bgOutline:
        return Container(
          height: 54.v,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
            border: Border.all(
              color: appTheme.blue10001,
              width: 1.h,
            ),
          ),
        );
      case Style.standard:
        return Container(
          height: 54.v,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
            border: Border(
              bottom: BorderSide(
                color: appTheme.blue10001,
                width: 1.h,
              ),
            ),
          ),
        );
      case Style.bgFill_2:
        return Container(
          height: 60.v,
          width: 335.h,
          decoration: BoxDecoration(
            color: appTheme.indigo800,
            borderRadius: BorderRadius.circular(
              12.h,
            ),
          ),
        );
      case Style.bgOutline_2:
        return Container(
          height: 54.v,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
            border: Border.all(
              color: appTheme.blue10001,
              width: 1.h,
              // strokeAlign: strokeAlignOutside,
            ),
          ),
        );
      case Style.bgShadow:
        return Container(
          height: 54.v,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: appTheme.cyan60001,
            boxShadow: [
              BoxShadow(
                color: appTheme.black900.withOpacity(0.1),
                spreadRadius: 2.h,
                blurRadius: 2.h,
                offset: Offset(
                  0,
                  0,
                ),
              ),
            ],
          ),
        );
      case Style.bgOutline_3:
        return Container(
          height: 64.v,
          width: 335.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
            border: Border(
              bottom: BorderSide(
                color: appTheme.blue10001,
                width: 1.h,
              ),
            ),
          ),
        );
      case Style.bgFill:
        return Container(
          height: 54.v,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: appTheme.cyan600,
          ),
        );
      default:
        return null;
    }
  }
}

enum Style {
  bgOutline_1,
  bgFill_1,
  bgOutline,
  bgFill_2,
  bgOutline_2,
  bgShadow,
  bgOutline_3,
  bgFill,
  standard
}
