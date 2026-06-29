import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/report_booth_jodo/booth_jodo_report_controller.dart';
import 'package:iyc/app/modules/report_booth_jodo/widget/aggregator_tile.dart';
import 'package:iyc/app/modules/report_booth_jodo/widget/assembly_tile.dart';
import 'package:iyc/app/modules/report_booth_jodo/widget/booth_wise_tile.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_search_view.dart';
import 'package:iyc/app/widgets/loading_widget.dart';

class BoothJodoReportScreen extends StatelessWidget {
  const BoothJodoReportScreen();

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
              text: 'Booth Jodo Report', margin: EdgeInsets.only(left: 12.h)),
          styleType: Style.standard),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: GetBuilder<BoothJodoReportController>(builder: (logic) {
          return Column(
            children: [
              Container(
                  height: 72.v,
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    color: Color(0xff244974),
                  ),
                  child: TabBar(
                      onTap: logic.updateCurrentIndex,
                      controller: logic.tabviewController,
                      labelPadding: EdgeInsets.zero,
                      labelColor:
                          theme.colorScheme.onPrimaryContainer.withOpacity(1),
                      labelStyle: TextStyle(
                          fontSize: 14.fSize,
                          fontFamily: 'Be Vietnam Pro',
                          fontWeight: FontWeight.w400),
                      unselectedLabelColor: Colors.white,
                      unselectedLabelStyle: TextStyle(
                          fontSize: 14.fSize,
                          fontFamily: 'Be Vietnam Pro',
                          fontWeight: FontWeight.w400),
                      indicatorPadding: EdgeInsets.all(12.0.h),
                      indicator: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12.h)),
                      tabs: [
                        const Tab(child: Text("Assembly")),
                        const Tab(child: Text("Aggregator")),
                        const Tab(child: Text("Booth Wise"))
                      ])),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: CustomSearchView(
                  onChanged: (str) => logic.onSearchByName(str),
                  autofocus: false,
                  controller: logic.searchController,
                  hintText: "lbl_search".tr,
                  suffix: Container(
                    margin: EdgeInsets.fromLTRB(30.h, 13.v, 16.h, 13.v),
                    child: CustomImageView(
                      svgPath: ImageConstant.imgSearchBlueGray300,
                    ),
                  ),
                  suffixConstraints: BoxConstraints(
                    maxHeight: 42.v,
                  ),
                  contentPadding: EdgeInsets.only(
                    left: 16.h,
                    top: 12.v,
                    bottom: 12.v,
                  ),
                ),
              ),
              Expanded(
                child: logic.isLoading
                    ? const Center(
                        child: LoadingWidget(),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          itemCount: logic.boothJodoReportSearchList.length > 0
                              ? logic.boothJodoReportSearchList.length
                              : logic.boothJodoReportList.length,
                          itemBuilder: (context, index) {
                            if (logic.currentIndex == 0) {
                              return InkWell(
                                  onTap: () => logic.updateSelectedIndex(index),
                                  child: AssemblyTile(
                                      logic.boothJodoReportSearchList.length > 0
                                          ? logic
                                              .boothJodoReportSearchList[index]
                                          : logic.boothJodoReportList[index],
                                      logic.selectedIndex == index));
                            }
                            if (logic.currentIndex == 1) {
                              return InkWell(
                                  onTap: () => logic.updateSelectedIndex(index),
                                  child: AggregatorTile(
                                      logic.boothJodoReportSearchList.length > 0
                                          ? logic
                                          .boothJodoReportSearchList[index]
                                          : logic.boothJodoReportList[index],
                                      logic.selectedIndex == index));
                            }
                            if (logic.currentIndex == 2) {
                              return InkWell(
                                  onTap: () => logic.updateSelectedIndex(index),
                                  child: BoothWiseTile(
                                      logic.boothJodoReportSearchList.length > 0
                                          ? logic
                                          .boothJodoReportSearchList[index]
                                          : logic.boothJodoReportList[index],
                                      logic.selectedIndex == index));
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
              ),
            ],
          );
        }),
      ),
    ));
  }
}
