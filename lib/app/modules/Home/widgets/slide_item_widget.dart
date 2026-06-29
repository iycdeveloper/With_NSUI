import 'package:iyc/app/modules/Home/home_controller.dart';
import 'package:iyc/app/modules/Home/model/slide_item_model.dart';

import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';

// ignore: must_be_immutable
class Slider1ItemWidget extends StatelessWidget {
  Slider1ItemWidget(
      this.slider1ItemModelObj, {
        Key? key,
      }) : super(
    key: key,
  );

  Slider1ItemModel slider1ItemModelObj;

  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgImage42,
                height: 180.v,
                width: 335.h,
                radius: BorderRadius.circular(
                  16.h,
                ),
              ),
              CustomImageView(
                imagePath: ImageConstant.imgImage44,
                height: 180.v,
                width: 335.h,
                radius: BorderRadius.circular(
                  16.h,
                ),
                margin: EdgeInsets.only(left: 20.h),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
