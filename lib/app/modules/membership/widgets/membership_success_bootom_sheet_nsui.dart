import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/size_utils.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';

membershipNSUISuccessBottomSheet(BuildContext context, {String? message}) {
  mediaQueryData = MediaQuery.of(Get.context!);
  Get.bottomSheet(
    isDismissible: false,
    Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
                color: appTheme.indigo800,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24))),
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 17.v),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Member Submission",
                    style: CustomTextStyles.titleMediumOnPrimaryContainer18),
                AppbarImage1(
                  onTap: () {
                    Navigator.pop(Get.context!, false);
                  },
                  svgPath: ImageConstant.imgEpcircleclose,
                ),
              ],
            ),
          ),
          SizedBox(height: 28.v),
          // Success check
          Container(
            height: 84.adaptSize,
            width: 84.adaptSize,
            decoration: BoxDecoration(
              color: const Color(0xFF16A34A).withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded,
                color: Color(0xFF16A34A), size: 54),
          ),
          SizedBox(height: 22.v),
          // Single message
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.h),
            child: Text(
              "Thanks for submission. This NSUI membership is a voluntary membership and free of any threat, promise or inducement",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: const Color(0xFF1F2A44),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 28.v),
          // Okay button (app gradient)
          GestureDetector(
            onTap: () {
              Get.back();
              Navigator.of(context).pop();
            },
            child: Container(
              width: mediaQueryData.size.width * 0.7,
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1356BF), Color(0xFF2CC7E2)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1356BF).withOpacity(0.30),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Text(
                'Okay',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 28.v),
        ],
      ),
    ),
  );
}
