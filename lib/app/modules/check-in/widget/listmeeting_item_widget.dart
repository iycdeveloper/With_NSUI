import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/api_model/events/checkin_data.dart';

// ignore: must_be_immutable
class CheckInTile extends StatelessWidget {
  CheckInTile( {
    this.checkInData,
    Key? key,
  }) : super(
          key: key,
        );
  final CheckInData? checkInData;

  @override
  Widget build(BuildContext context) {
    String date = checkInData!.dateTime.split(' ')[0];
    String time = checkInData!.dateTime.split(' ')[1];
    DateTime dateTime = DateTime.parse(date);
    date = DateFormat("dd MMM yyyy").format(dateTime);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: appTheme.blue10001,
            width: 1.h,
        ),
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.h,
                top: 22.v,
              ),
              child: Text(checkInData!.eventDescription??'',
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20.h,
              top: 8.v,
              right: 29.h,
            ),
            child:Text(checkInData!.eventLocation,
                // overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.bodyMediumBluegray70001_2.copyWith(
                  height: 1.60,
                ),
              ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 9.v),
            child: Divider(
              indent: 20.h,
              endIndent: 20.h,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.h,
                top: 12.v,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomImageView(
                    svgPath: ImageConstant.imgTablercalendardue,
                    height: 16.adaptSize,
                    width: 16.adaptSize,
                    margin: EdgeInsets.only(bottom: 23.v),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 4.h,
                      bottom: 22.v,
                    ),
                    child: Text(date,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.bodyMediumBluegray70001_2,
                      ),

                  ),
                  CustomImageView(
                    svgPath: ImageConstant.imgClock1,
                    height: 16.adaptSize,
                    width: 16.adaptSize,
                    margin: EdgeInsets.only(
                      left: 20.h,
                      bottom: 23.v,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 4.h,
                      bottom: 22.v,
                    ),
                    child: Text(time,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.bodyMediumBluegray70001_2,
                      ),
                  ),
                  Spacer(),
                  Opacity(
                    opacity: 0.1,
                    child: Container(
                      height: 34.adaptSize,
                      width: 34.adaptSize,
                      margin: EdgeInsets.only(top: 6.v),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.39),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.h),
                          topRight: Radius.circular(2.h),
                          bottomLeft: Radius.circular(2.h),
                          bottomRight: Radius.circular(20.h),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
