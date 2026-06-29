import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';

// ignore: must_be_immutable
class UserProgressItemWidgetNew extends StatelessWidget {
  UserProgressItemWidgetNew({
    this.completedTask,this.totalTask,
    Key? key,
  }) : super(
          key: key,
        );
  final String? totalTask;
  final String? completedTask;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 162.v,
      width: 335.h,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: appTheme.blue80001, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 14.v,
                  bottom: 10.v,
                ),
                child: Text("Your Today's Progress",
                                  style: theme.textTheme.titleLarge!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
              ),
              CustomImageView(
                svgPath: ImageConstant.imgMinimize,
                height: 48.adaptSize,
                width: 48.adaptSize,
                // margin: EdgeInsets.only(left: 49.h),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                    top: 14.v,
                    bottom: 10.v,
                  ),
                  child: Text(
                    'Tasks - $completedTask/$totalTask Completed',
                    style:  theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
                      fontSize: 14.fSize,
                    )
                  )),
            ],
          ),
          Stack(
            children: [
              Container(
                height: 24.v,
                width: 295.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xffD9E6F9)
                ),
              ),
              if(int.parse(totalTask!)>0)
              Container(
                height: 24.v,
                width: 295.h*(int.parse(completedTask!) / int.parse(totalTask!)) * 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xff2CC7E2)
                ),
                child: Center(child: Text('${(int.parse(completedTask!) / int.parse(totalTask!)) * 100}%', style: TextStyle(color: Colors.white),)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
