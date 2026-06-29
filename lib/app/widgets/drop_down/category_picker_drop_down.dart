import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/category.dart';

class CategoryDropDrown extends StatelessWidget {
  const CategoryDropDrown({
    Key? key,
    this.value,
    this.title,
    this.listValues,
    required this.onChanged,
  });

  final String? title;
  final Category? value;
  final List<Category>? listValues;
  final void Function(dynamic v) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (listValues == null) {
            CustomSnackBar.showWarningSnackBar("No item to select");
          } else {
            Get.dialog(
                Center(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 326),
                    height: 40.0 * listValues!.length,
                    width: 335,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Color(0xFFC0D5F3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 10),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20.h,
                        top: 13.v,
                        bottom: 13.v,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              listValues!.length,
                              (index) => GestureDetector(
                                    onTap: () {
                                      onChanged(listValues![index]);
                                      Get.back();
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          listValues![index].name,
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                        if (!(index ==
                                            (listValues!.length - 1)))
                                          SizedBox(height: 16.v),
                                      ],
                                    ),
                                  )),
                        ),
                      ),
                    ),
                  ),
                ),
                barrierColor: Colors.transparent,
                barrierDismissible: true);
          }
        },
        child: Container(
            margin: EdgeInsets.only(left: 20.h, top: 24.v, right: 20.h),
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 9.v),
            decoration: AppDecoration.strokeWhite
                .copyWith(borderRadius: BorderRadiusStyle.roundedBorder12),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 6.v),
                  Text(title!, style: theme.textTheme.bodyLarge),
                  SizedBox(height: 3.v),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 3.v),
                            child: Text(
                                value != null
                                    ? listValues!
                                        .firstWhere((element) =>
                                            element.categoryCode ==
                                            value!.categoryCode)
                                        .name
                                    : "",
                                style: theme.textTheme.bodyLarge)),
                        CustomImageView(
                            svgPath: ImageConstant.imgArrowupBlueGray300,
                            height: 20.adaptSize,
                            width: 20.adaptSize,
                            margin: EdgeInsets.only(bottom: 4.v))
                      ])
                ])));
  }
}
