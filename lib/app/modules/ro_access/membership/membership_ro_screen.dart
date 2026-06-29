import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/ro_access/membership/membership_ro_controller.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_floating_text_field.dart';

class MembershipRoScreen extends StatelessWidget {
  const MembershipRoScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<MemberShipRoController>(builder: (logic) {
        return Scaffold(
          appBar: CustomAppBar(
              leadingWidth: 44.h,
              leading: AppbarImage(
                  onTap: Get.back,
                  svgPath: ImageConstant.imgBiarrowleftIndigo800,
                  margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
              title: AppbarSubtitle1(
                  text: 'Membership Scrutiny',
                  margin: EdgeInsets.only(left: 12.h)),
              actions: [
                const InkWell(
                    onTap: RoutesManagement.goToMembershipDashBoardScreen,
                    child: Icon(
                      Icons.dashboard,
                      size: 30,
                    )),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                    onTap: RoutesManagement.goToFilterBottomSheet,
                    child: Stack(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 13, 0, 0),
                          child: Icon(
                            Icons.filter_alt_sharp,
                            size: 30,
                          ),
                        ),
                        if (logic.selectedFilter.isNotEmpty)
                          Positioned(
                              right: 0,
                              top: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.cyanAccent,
                                radius: 10,
                                child: Text('${logic.selectedFilter.length}'),
                              ))
                      ],
                    )),
                const SizedBox(
                  width: 20,
                )
              ],
              styleType: Style.standard),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                    height: 46.v,
                    width: 335.h,
                    decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onPrimaryContainer.withOpacity(1),
                        borderRadius: BorderRadius.circular(12.h)),
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
                        unselectedLabelColor: appTheme.indigo800,
                        unselectedLabelStyle: TextStyle(
                            fontSize: 14.fSize,
                            fontFamily: 'Be Vietnam Pro',
                            fontWeight: FontWeight.w400),
                        indicatorPadding: EdgeInsets.all(7.0.h),
                        indicator: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(6.h)),
                        tabs: const [
                          Tab(child: Padding(
        padding: EdgeInsets.all(10), // Horizontal padding around the label
                            child: Text("Pending"),
                          )),
                          Tab(child: Padding(
        padding: EdgeInsets.all(10), // Horizontal padding around the label
                            child: Text("Complete"),
                          ))
                        ])),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    // height: 690.v,
                    child: TabBarView(
                        controller: logic.tabviewController,
                        children: [
                      tabView(logic, logic.pending),
                      tabView(logic, logic.completed),
                    ])),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget tabView(MemberShipRoController logic, List<dynamic> membershipList) {
    return Column(
      children: [
        CustomFloatingTextField(
          controller: logic.mobileId,
          labelText: "Search by Mobile / Voter ID / Member ID",
          labelStyle: theme.textTheme.bodyMedium!,
          hintText: "Mobile or Member ID",
          hintStyle: theme.textTheme.bodyLarge!,
          suffix: logic.enableSearchButton
              ? logic.searchDataFound
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: logic.clearSearch,
                  child: Text(
            'Clear',
            style: TextStyle(color: theme.colorScheme.primary, fontSize: 20),
          ),
                ),
              )
              : IconButton(
                  onPressed: () {
                    logic.searchMemberDetails(logic.roId, logic.mobileId.text);
                  },
                  icon: Icon(
                    Icons.search,
                    color: theme.colorScheme.primary,
                    size: 40,
                  ))
              : const SizedBox(),
        ),
        const SizedBox(
          height: 20,
        ),
        if (membershipList.isNotEmpty) ...[
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: membershipList.length,
                itemBuilder: (context, index) {
                  if (logic.selectedFilter.isNotEmpty) {
                    // if (logic.selectedFilter
                    //     .contains('${membershipList[index]['scrutiny_code']}'))
                    if (logic.checkFilter(
                        '${membershipList[index]['scrutiny_code']}')) {
                      return InkWell(
                        onTap: () {
                          RoutesManagement.goToMembershipDetailScreen(
                              membershipList[index]);
                          logic.initData(membershipList[index]);
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1,
                                    color: Colors.lightBlue.withOpacity(0.1)),
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('$index'),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${membershipList[index]['first_name']} ${membershipList[index]['last_name']}',
                                        style: theme.textTheme.bodyLarge,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          '${membershipList[index]['member_id']}'),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${logic.scrutinyStatus[membershipList[index]['scrutiny_status']]}',
                                        style: TextStyle(
                                            color: logic.getStatusColor(
                                                '${membershipList[index]['scrutiny_status']}')),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  } else {
                    return InkWell(
                      onTap: () {
                        RoutesManagement.goToMembershipDetailScreen(
                            membershipList[index]);
                        logic.initData(membershipList[index]);
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color: Colors.lightBlue.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2),
                                child: Text(
                                  '${index + 1}.',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${membershipList[index]['first_name']} ${membershipList[index]['last_name']}',
                                      style: theme.textTheme.bodyLarge,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text('${membershipList[index]['member_id']}'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${logic.scrutinyStatus[membershipList[index]['scrutiny_status']]}',
                                      style: TextStyle(
                                          color: logic.getStatusColor(
                                              '${membershipList[index]['scrutiny_status']}')),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios)
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                }),
          ),
          if (membershipList.isEmpty) const Center(child: Text("Data not found"))
        ]
      ],
    );
  }
}
