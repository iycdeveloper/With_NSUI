import 'package:flutter/material.dart';
import 'package:iyc/utils/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function onBackPressed;
  final BuildContext context;
final bool centerTitle;
  CustomAppBar(
      {required this.title,
      this.isBackButtonExist = true,
      required this.onBackPressed,
      required this.context,
      this.centerTitle=false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Constants.appbarTitleTextStyle,
      ),
      centerTitle: centerTitle,
      leading: isBackButtonExist
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              color: Constants.themeGradients[1],
              onPressed: () => onBackPressed != null
                  ? onBackPressed()
                  : Navigator.pop(context),
            )
          :null,
      backgroundColor: Constants.themeGradients[0],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}
