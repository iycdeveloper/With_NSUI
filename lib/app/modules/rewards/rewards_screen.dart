import 'package:iyc/app/modules/rewards/rewards_controller.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/screens/ui/home/profile/create_certificate.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/profile/inbox/create_certificate_vm.dart';
import 'package:provider/provider.dart';

import '../../core/app_export.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class RewardsScreen extends StatelessWidget {
  const RewardsScreen({Key? key})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: GetBuilder<RewardsController>(
        builder: (logic) {
          return Scaffold(
            appBar: CustomAppBar(
              leadingWidth: 44.h,
              leading: AppbarImage(
                onTap: Get.back,
                svgPath: ImageConstant.imgBiarrowleftIndigo800,
                margin: EdgeInsets.only(
                  left: 20.h,
                  top: 15.v,
                  bottom: 15.v,
                ),
              ),
              title: AppbarSubtitle1(
                text: "Rewards",
                margin: EdgeInsets.only(left: 12.h),
              ),
              styleType: Style.standard,
            ),
            body: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  SizedBox(height: 24.v),
                  SizedBox(
                    height: 148.v,
                    width: 335.h,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgFemalehandraisingtrophy,
                          height: 148.v,
                          width: 335.h,
                          radius: BorderRadius.circular(
                            16.h,
                          ),
                          alignment: Alignment.center,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 170.h,
                            margin: EdgeInsets.only(left: 24.h),
                            child: Text(
                              "Rewards for Your\nExclusive\nAchievements",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyles.titleLargeOnPrimaryContainer
                                  .copyWith(
                                height: 1.40,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20.h,
                        top: 32.v,
                        right: 20.h,
                      ),
                      child:ListView.separated(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (
                              context,
                              index,
                              ) {
                            return SizedBox(
                              height: 20.v,
                            );
                          },
                          itemCount: logic.rewardsData.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap:(){
                                toPage(
                                    context,
                                    ChangeNotifierProvider(
                                      create: (_) => CreateCertificateVM(),
                                      child: CreateCertificate(certificateDate: logic.rewardsData[index],),
                                    ));
                              } ,//RoutesManagement.goToRewardsDetailScreen,
                              child: Container(
                                width: double.maxFinite,
                                height: 112.v,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Color(0xffC0D5F3), width: 1)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 93.v,
                                      width: 143.h,
                                      margin: EdgeInsets.only(
                                        left: 7.h,
                                        top: 3.v,
                                        bottom: 3.v,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16)
                                      ),
                                      child: CustomImageView(
                                        imagePath: ImageConstant.imgTrophyRewards,
                                        radius: BorderRadius.circular(5),
                                      )
                                      // Stack(
                                      //   alignment: Alignment.topLeft,
                                      //   children: [
                                      //     Align(
                                      //       alignment: Alignment.bottomRight,
                                      //       child: SizedBox(
                                      //         height: 80.v,
                                      //         width: 134.h,
                                      //         child: Stack(
                                      //           alignment: Alignment.center,
                                      //           children: [
                                      //             CustomImageView(
                                      //               imagePath: ImageConstant.imgCloseupmicrop,
                                      //               height: 80.v,
                                      //               width: 134.h,
                                      //               radius: BorderRadius.circular(
                                      //                 8.h,
                                      //               ),
                                      //               alignment: Alignment.center,
                                      //             ),
                                      //             CustomImageView(
                                      //               imagePath: ImageConstant.imgCloseupmicrop,
                                      //               height: 80.v,
                                      //               width: 134.h,
                                      //               radius: BorderRadius.circular(
                                      //                 8.h,
                                      //               ),
                                      //               alignment: Alignment.center,
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     CustomImageView(
                                      //       svgPath: ImageConstant.imgCall,
                                      //       height: 18.v,
                                      //       width: 12.h,
                                      //       alignment: Alignment.topLeft,
                                      //     ),
                                      //   ],
                                      // ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.v),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          CustomImageView(
                                            svgPath: ImageConstant.imgAirplane,
                                            height: 8.v,
                                            width: 7.h,
                                            margin: EdgeInsets.only(right: 8.h),
                                          ),
                                          // SizedBox(height: 9.v),
                                          SizedBox(
                                            height: 84.v,
                                            width: 165.h,
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${logic.rewardsData[index]['reward_type']}',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: theme.textTheme.titleMedium,
                                                      ),
                                                      SizedBox(height: 5.v,),
                                                      Text(
                                                        '${logic.rewardsData[index]['reward_category']}',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: theme.textTheme.bodyMedium,
                                                      ),
                                                      SizedBox(height: 5.v,),
                                                      Text(
                                                        '${logic.rewardsData[index]['created_on']}',
                                                        overflow: TextOverflow.visible,
                                                        style: theme.textTheme.bodySmall!.copyWith(
                                                          height: 1.40,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                CustomImageView(
                                                  svgPath: ImageConstant.imgVolume,
                                                  height: 43.v,
                                                  width: 64.h,
                                                  alignment: Alignment.bottomRight,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
