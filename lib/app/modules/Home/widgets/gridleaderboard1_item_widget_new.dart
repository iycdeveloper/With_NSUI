import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';

// ignore: must_be_immutable
class GridLeaderBoardItemWidgetNew extends StatelessWidget {
  GridLeaderBoardItemWidgetNew(this.title, this.logo,
      {Key? key, this.onTap, this.boxcolor,this.textboxcolor})
      : super(
          key: key,
        );
  VoidCallback? onTap;
  String title;
  String logo;
  Color? boxcolor = Colors.white;
  Color? textboxcolor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        // padding: EdgeInsets.symmetric(
        //   horizontal: 10.h,
        //   vertical: 27.v,
        // ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
            color: boxcolor),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 2.v),
              CustomImageView(
                svgPath: logo,
                height: 40.adaptSize,
                width: 40.adaptSize,
              ),
              // SizedBox(height: 10.v),
              // const Divider(),
              Container(
                decoration:  BoxDecoration(color: textboxcolor),
                // padding: const EdgeInsets.all(2),
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height * 0.045,
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  // overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall!.copyWith(
                      color: appTheme.deepPurple700,
                      fontWeight: FontWeight.w600),
                ),
              ),

              // SizedBox(height: 2.v),
            ],
          ),
        ),
      ),
    );
  }
}
