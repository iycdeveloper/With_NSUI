import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';

class CustomBottomAppBar extends StatelessWidget {
  CustomBottomAppBar({
    Key? key,
    this.onChanged,
  }) : super(
          key: key,
        );

  RxList<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
        icon: ImageConstant.imgNavtasks,
        activeIcon: ImageConstant.imgNavtasks,
        title: "lbl_tasks".tr,
        type: BottomBarEnum.Tasks,
        isSelected: true),
    BottomMenuModel(
      icon: ImageConstant.imgNavcampaigns,
      activeIcon: ImageConstant.imgNavcampaigns,
      title: "lbl_campaigns2".tr,
      type: BottomBarEnum.Campaigns2,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgHome12,
      activeIcon: ImageConstant.imgHome12,
      title: "lbl_tasks".tr,
      type: BottomBarEnum.Tasks,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavboothjodo,
      activeIcon: ImageConstant.imgNavboothjodo,
      title: "lbl_booth_jodo2".tr,
      type: BottomBarEnum.Boothjodo2,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavstats,
      activeIcon: ImageConstant.imgNavstats,
      title: "lbl_stats".tr,
      type: BottomBarEnum.Stats,
    )
  ].obs;

  Function(BottomBarEnum)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: SizedBox(
          height: 24.v,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              bottomMenuList.length,
              (index) {
                return InkWell(
                  onTap: () {
                    for (var element in bottomMenuList) {
                      element.isSelected = false;
                    }
                    bottomMenuList[index].isSelected = true;
                    onChanged?.call(bottomMenuList[index].type);
                    bottomMenuList.refresh();
                  },
                  child: bottomMenuList[index].isSelected
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomImageView(
                              svgPath: bottomMenuList[index].activeIcon,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              color: appTheme.black900,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5.v),
                              child: Text(
                                bottomMenuList[index].title ?? "",
                                style: CustomTextStyles.bodySmallBluegray300
                                    .copyWith(
                                  color: appTheme.blueGray300,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomImageView(
                              svgPath: bottomMenuList[index].icon,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              color: appTheme.blueGray300,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 6.v),
                              child: Text(
                                bottomMenuList[index].title ?? "",
                                style: CustomTextStyles.bodySmallBluegray300
                                    .copyWith(
                                  color: appTheme.blueGray300,
                                ),
                              ),
                            ),
                          ],
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

enum BottomBarEnum {
  Tasks,
  Campaigns2,
  Boothjodo2,
  Stats,
}

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
    this.isSelected = false,
  });

  String icon;

  String activeIcon;

  String? title;

  BottomBarEnum type;

  bool isSelected;
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
