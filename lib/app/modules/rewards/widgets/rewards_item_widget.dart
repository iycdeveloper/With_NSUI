import 'package:iyc/app/modules/rewards/rewards_controller.dart';

import '../models/rewards_item_model.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';

// ignore: must_be_immutable
class RewardsItemWidget extends StatelessWidget {
  RewardsItemWidget(
    {
      this.title,
      this.subTitle
  }) : super(
        );

  String? title;
  String? subTitle;
  var controller = Get.find<RewardsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 112.v,
      decoration: AppDecoration.outlineBlue.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 93.v,
            width: 143.h,
            margin: EdgeInsets.only(
              left: 7.h,
              top: 3.v,
              bottom: 16.v,
            ),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    height: 80.v,
                    width: 134.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgCloseupmicrop,
                          height: 80.v,
                          width: 134.h,
                          radius: BorderRadius.circular(
                            8.h,
                          ),
                          alignment: Alignment.center,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgCloseupmicrop,
                          height: 80.v,
                          width: 134.h,
                          radius: BorderRadius.circular(
                            8.h,
                          ),
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                  ),
                ),
                CustomImageView(
                  svgPath: ImageConstant.imgCall,
                  height: 18.v,
                  width: 12.h,
                  alignment: Alignment.topLeft,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomImageView(
                  svgPath: ImageConstant.imgAirplane,
                  height: 8.v,
                  width: 7.h,
                  margin: EdgeInsets.only(right: 8.h),
                ),
                SizedBox(height: 11.v),
                SizedBox(
                  height: 84.v,
                  width: 165.h,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                title!,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium,
                              ),

                            SizedBox(height: 3.v),
                            Text(
                                subTitle!,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall!.copyWith(
                                  height: 1.40,
                                ),
                              ),
                          ],
                        ),
                      ),
                      CustomImageView(
                        svgPath: ImageConstant.imgVolume,
                        height: 43.v,
                        width: 64.h,
                        alignment: Alignment.bottomRight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
