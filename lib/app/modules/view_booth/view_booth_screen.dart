import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/view_booth/view_booth_controller.dart';
import 'package:iyc/app/modules/view_booth/widget/booth_tile.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/loading_widget.dart';

class ViewBoothScreen extends StatelessWidget {
  const ViewBoothScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
            leadingWidth: 44.h,
            leading: AppbarImage(
                onTap: Get.back,
                svgPath: ImageConstant.imgBiarrowleftIndigo800,
                margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
            title: AppbarSubtitle1(
                text: "Voter List", margin: EdgeInsets.only(left: 12.h)),
            styleType: Style.standard),
        body: GetBuilder<ViewBoothController>(builder: (logic) {
          return logic.loadingPage
              ? Center(
                  child: LoadingWidget(),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (
                      context,
                      index,
                    ) {
                      return SizedBox(
                        height: 12.v,
                      );
                    },
                    itemCount: logic.boothJodoList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          logic.updateIndex(index);
                        },
                        child: ViewBoothTile(
                            logic.boothJodoList[index], index == logic.currentIndex),
                      );
                    },
                  ),
                );
        }),
        // body: ListView.separated(itemBuilder: itemBuilder, separatorBuilder: separatorBuilder, itemCount: itemCount),
      ),
    );
  }
}
