import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/election_report/election_report_controller.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/loading_widget.dart';
import 'package:iyc/utils/constants.dart';

class ElectionReportScreen extends StatelessWidget {
  const ElectionReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<ElectionReportController>(builder: (logic) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Constants.themeGradients[0],
            title: Text(
              "Report",
              // "MB-005-00-16",
              style: Constants.appbarTitleTextStyle,
            ),),
          //  CustomAppBar(
          //     leadingWidth: 44.h,
          //     leading: AppbarImage(
          //         onTap: Get.back,
          //         svgPath: ImageConstant.imgBiarrowleftIndigo800,
          //         margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
          //     title: AppbarSubtitle1(
          //         text: "Report", margin: EdgeInsets.only(left: 12.h)),
          //     styleType: Style.standard),
          body: logic.isLoading
              ? LoadingWidget()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: List.generate(
                        logic.report.length,
                        (index) => InkWell(
                              onTap: () =>
                                  RoutesManagement.goToViewElectionReportScreen(
                                      logic.report[index] ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 9),
                                margin: const EdgeInsets.only(bottom: 8),
                                // height: 75,
                                width: mediaQueryData.size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: const Color(0xFFE6E6E6),
                                        width: 1)),
                                child: SizedBox(
                                  height: 39,
                                  child: Row(
                                    children: [
                                      Text(
                                        logic.report[index]['report_name'] ??
                                            'Unknown',
                                        style: const TextStyle(
                                          color: Color(0xff244974),
                                          fontFamily: 'Roboto',
                                          fontSize: 15.0,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Color(0xff869DB6),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                  ),
                ),
        );
      }),
    );
  }
}
