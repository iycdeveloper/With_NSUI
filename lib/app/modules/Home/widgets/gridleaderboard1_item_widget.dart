import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';

// ignore: must_be_immutable
class GridLeaderBoardItemWidget extends StatelessWidget {
  GridLeaderBoardItemWidget(
      this.title,
      this.logo,
      {
    Key? key,
    this.onTap,
  }) : super(
          key: key,
        );
  VoidCallback? onTap;
  String title;
  String logo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.h,
          vertical: 27.v,
        ),
        decoration: AppDecoration.strokeWhite.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
              svgPath: logo,
              height: 40.adaptSize,
              width: 40.adaptSize,
            ),
            SizedBox(height: 14.v),
            Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),

            SizedBox(height: 2.v),
          ],
        ),
      ),
    );
  }
}
