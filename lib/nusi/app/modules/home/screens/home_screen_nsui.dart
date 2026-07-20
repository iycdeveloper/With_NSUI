import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/service/auth_service.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/app/widgets/custom_rating_bar.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/nusi/app/modules/home/screens/home_controller_nsui.dart';
import 'package:iyc/nusi/app/modules/profile/screens/profile_screen_nsui.dart';
import 'package:iyc/nusi/app/modules/social/screens/social_controller_nsui.dart';
import 'package:iyc/nusi/widgets/custom_elevated_button_nsui.dart';
import 'package:iyc/nusi/widgets/dropdown_picker_nsui.dart';
import 'package:iyc/provider/nomination/nominations_provider.dart';
import 'package:iyc/screens/ui/nominations/nominations_main.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/nomination/view_nomination_vm.dart';
import 'dart:math' as math;
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomescreenNSUI extends GetWidget<HomeNSUIController> {
  const HomescreenNSUI({super.key});

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return GetBuilder<HomeNSUIController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            flexibleSpace: Container(
              height: 54.v,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
                border: Border(
                  bottom: BorderSide(
                    color: appTheme.blue10001,
                    width: 1.h,
                  ),
                ),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CustomImageView(
                  imagePath: 'assets/nsui/applogo/playstore.png',
                  height: 32.adaptSize,
                  width: 32.adaptSize),
            ),
            title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              // CustomImageView(
              //     imagePath: 'assets/nsui/applogo/playstore.png',
              //     height: 32.adaptSize,
              //     width: 32.adaptSize),

              //     Spacer(),
              InkWell(
                onTap: () {
                  // RoutesManagement.goToNotificationScreen();
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF1356BF)),
                      shape: BoxShape.circle),
                  child: IconButton(
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      style: const ButtonStyle(
                        tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap, // the '2023' part
                      ),
                      onPressed: () {
                        Get.bottomSheet(Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24))),
                            width: double.maxFinite,
                            height: mediaQueryData.size.height * 0.45,
                            child: Column(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      // color: Colors.white,
                                      color: appTheme.indigo800,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(24),
                                          topRight: Radius.circular(24))),
                                  width: double.maxFinite,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.h, vertical: 17.v),
                                  // decoration: AppDecoration.heading,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Member Submission",
                                          style: CustomTextStyles
                                              .titleMediumOnPrimaryContainer18),
                                      AppbarImage1(
                                        onTap: () {
                                          Get.back();
                                        },
                                        svgPath: ImageConstant.imgEpcircleclose,
                                      ),
                                    ],
                                  )),
                              SizedBox(height: 33.v),
                              CustomImageView(
                                  svgPath: 'assets/nsui/svg/backtoprofile.svg',
                                  height: 69.adaptSize,
                                  width: 69.adaptSize),
                              SizedBox(height: 15.v),
                              Text("Thanks for the Submission",
                                  style: theme.textTheme.titleLarge),
                              Text(
                                  "Member data wil be added to batch after verification",
                                  style: theme.textTheme.bodyLarge!
                                      .copyWith(color: Colors.blueAccent)),
                              // Spacer(),
                              SizedBox(height: 25.v),

                              CustomElevatedButtonNSUI(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 0.6,
                                            blurRadius: 0.6)
                                      ]),
                                  width: mediaQueryData.size.width * 0.7,
                                  buttonStyle: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all(Colors.blue)),
                                  text: 'Back to Home',
                                  onTap: Get.back),
                              SizedBox(height: 25.v),
                            ])));
                        // RoutesManagement.goToNotificationScreen();
                      },
                      icon: const Icon(
                        Icons.notifications,
                        color: Color(0xFF1356BF),
                      )),
                ),
              ),
              SizedBox(
                width: mediaQueryData.size.width * 0.01,
              ),
              InkWell(
                onTap: () async {
                  Get.find<AuthService>().logout(context: context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF1356BF)),
                      shape: BoxShape.circle),
                  child: IconButton(
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      style: const ButtonStyle(
                        tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap, // the '2023' part
                      ),
                      onPressed: () async {
                        Get.find<AuthService>().logout(context: context);
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Color(0xFF1356BF),
                      )),
                ),
              )
            ]),
          ),
          body: Obx(() {
            return IndexedStack(
              index: controller.selectedTabIndex.value,
              children: [
                controller.isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const BannerPlaceholder(),
                              // const SizedBox(height: 16.0),
                              // const BannerPlaceholder(),
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: Colors.grey[200]!)),
                                  padding: const EdgeInsets.all(5),
                                  margin: EdgeInsets.only(
                                      left: 20.h, top: 0.v, right: 20.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Welcome Back!',
                                          style: theme.textTheme.bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(
                                                  left: 10.h,
                                                  top: 5.v,
                                                  right: 10.h),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: height * 0.08,
                                                    width: width * 0.16,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      // borderRadius:
                                                      //     BorderRadius.circular(10),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors
                                                              .grey[200]!),
                                                    ),
                                                    clipBehavior: Clip
                                                        .hardEdge, // Ensures image respects borderRadius
                                                  ),
                                                  SizedBox(
                                                    // color: Colors.amber,
                                                    width: width / 2.4,

                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        // Text('  ******',
                                                        //     style: theme
                                                        //         .textTheme
                                                        //         .bodyLarge!
                                                        //         .copyWith(
                                                        //             fontWeight:
                                                        //                 FontWeight
                                                        //                     .bold)),
                                                        Text("  ****** ",
                                                            style: theme
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                        Text(" ****** ",
                                                            style: theme
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                    fontSize:
                                                                        25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          //
                                        ],
                                      ),
                                    ],
                                  )),
                              // Column(
                              //   children: [
                              //     SizedBox(
                              //       height: height * 0.008,
                              //     ),
                              //     Divider(
                              //       indent: 20.h,
                              //       endIndent: 20.h,
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(
                              //   height: height * 0.01,
                              // ),

                              Container(
                                width: mediaQueryData.size.width,
                                // height: mediaQueryData.size.height * 0.2,
                                margin: EdgeInsets.all(
                                    mediaQueryData.size.height * 0.02),
                                padding: EdgeInsets.all(
                                    mediaQueryData.size.height * 0.02),
                                decoration: BoxDecoration(
                                    // color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(
                                        mediaQueryData.size.width * 0.03)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Election',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height:
                                              mediaQueryData.size.height * 0.10,
                                          width:
                                              mediaQueryData.size.width * 0.28,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.grey[200]!)),
                                        ),
                                        Container(
                                          height:
                                              mediaQueryData.size.height * 0.10,
                                          width:
                                              mediaQueryData.size.width * 0.28,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.grey[200]!)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height:
                                              mediaQueryData.size.height * 0.10,
                                          width:
                                              mediaQueryData.size.width * 0.28,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.grey[200]!)),
                                        ),
                                        Container(
                                          height:
                                              mediaQueryData.size.height * 0.10,
                                          width:
                                              mediaQueryData.size.width * 0.28,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.grey[200]!)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height:
                                              mediaQueryData.size.height * 0.10,
                                          width:
                                              mediaQueryData.size.width * 0.28,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.grey[200]!)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: Colors.grey[200]!)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                    : _buildGenZHome(context, controller),
                // const SocialscreenNSUI(),
                socialMediaPage(),
                const ProfilescreenNSUI(),
              ],
            );
          }),
          bottomNavigationBar: MotionTabBar(
            controller: controller
                .motionTabBarController, // ADD THIS if you need to change your tab programmatically
            initialSelectedTab: "Home",
            useSafeArea: true, // default: true, apply safe area wrapper
            labelAlwaysVisible:
                true, // default: false, set to "true" if you need to always show labels
            labels: const ["Home", "Social", "Profile"],
            // use custom widget as display Icon
            iconWidgets: [
              SvgPicture.asset(
                'assets/nsui/svg/bottomhome.svg',
                fit: BoxFit.fill,
                height: mediaQueryData.size.height * 0.04,
                width: mediaQueryData.size.width * 0.04,
              ),
              SvgPicture.asset(
                'assets/nsui/svg/bottomsocial.svg',
                fit: BoxFit.fill,
                height: mediaQueryData.size.height * 0.04,
                width: mediaQueryData.size.width * 0.04,
              ),
              SvgPicture.asset(
                'assets/nsui/svg/bottomprofile.svg',
                fit: BoxFit.fill,
                height: mediaQueryData.size.height * 0.04,
                width: mediaQueryData.size.width * 0.04,
              ),
            ],

            tabSize: 30,
            // tabBarHeight: mediaQueryData.size.height*0.08,
            textStyle: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            // tabIconColor: Colors.blue[600],
            tabIconSize: 28.0,
            tabIconSelectedSize: 32.0,
            tabSelectedColor: Colors.white,
            tabIconSelectedColor: Colors.black,
            tabBarColor: Colors.white,
            onTabItemSelected: (int value) {
              controller.onchangeMenu(value);
            },
          ),
        ),
      );
    });
  }

  GetBuilder socialMediaPage() {
    // final controller = Get.put(SocialNSUIController());

    return GetBuilder<SocialNSUIController>(builder: (controller) {
      return Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(
              left: mediaQueryData.size.width * 0.05,
              right: mediaQueryData.size.width * 0.05),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xFF2CC7E2), Color(0xFFF8FAFF)])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                "Social Media Post",
                style: theme.textTheme.titleLarge!.copyWith(shadows: [
                  Shadow(
                    offset: const Offset(
                        1, 1), // horizontal & vertical shadow offset
                    blurRadius: 4, // softness of shadow
                    color: Colors.black.withOpacity(0.2), // shadow color
                  ),
                ], fontWeight: FontWeight.bold),
              ),
              DropDownPickerNSUI(
                labelcolor: theme.textTheme.bodyLarge!.color,

                onChanged: (val) {
                  controller.onchangeSocialMedia(val);
                },
                // viewOnly: model.disableFields,
                listValues: controller.listValues,
                labelText: "Social Media",
                hintText: "Select a social media",
                currentValue: controller.selectSocialMedia,
              ),
              Expanded(
                  child: controller.webviewcontroller != null
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: WebViewWidget(
                              controller: controller.webviewcontroller!))
                      : const SizedBox()
                  //  ListView.builder(
                  //     itemCount: 2,
                  //     itemBuilder: (context, int i) {
                  //       return Container(
                  //         margin: const EdgeInsets.only(top: 10),
                  //         decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             borderRadius: BorderRadius.circular(
                  //                 mediaQueryData.size.width * 0.03)),
                  //         child: Column(
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.all(10),
                  //               child: Row(
                  //                 children: [
                  //                   CircleAvatar(
                  //                     radius:
                  //                         mediaQueryData.size.height * 0.025,
                  //                     child: Image.asset(
                  //                         'assets/nsui/applogo/playstore.png'),
                  //                   ),
                  //                   const SizedBox(
                  //                     width: 10,
                  //                   ),
                  //                   Column(
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     children: [
                  //                       Text(
                  //                         "nusi_india",
                  //                         style: theme.textTheme.bodyLarge!
                  //                             .copyWith(
                  //                                 fontWeight:
                  //                                     FontWeight.bold),
                  //                       ),
                  //                       Text(
                  //                         "Delhi, India",
                  //                         style: theme.textTheme.bodySmall!
                  //                             .copyWith(),
                  //                       ),
                  //                     ],
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.only(
                  //                   left: 10, right: 10),
                  //               child: Container(
                  //                 height: mediaQueryData.size.height * 0.25,
                  //                 width: mediaQueryData.size.width,
                  //                 decoration:
                  //                     const BoxDecoration(color: Colors.blue),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.only(
                  //                   left: 10, right: 10, top: 10),
                  //               child: SizedBox(
                  //                 width: mediaQueryData.size.width,
                  //                 child: Text(
                  //                   "nsui_india The NSUI National President Shri Varun Choudhary will be in Odisha tomorrow (16th July, 2025). Do join us in greeting him!",
                  //                   style:
                  //                       theme.textTheme.bodySmall!.copyWith(),
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.all(10),
                  //               child: Row(
                  //                 children: [
                  //                   Text(
                  //                     "10:45 PM Sep 1, 2022",
                  //                     style: theme.textTheme.bodySmall!
                  //                         .copyWith(),
                  //                   ),
                  //                 ],
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       );
                  //     })

                  ),
              const SizedBox(
                height: 10,
              )
            ],
          ));
    });
  }

  // ===================== Gen-Z home redesign =====================

  Widget _buildGenZHome(BuildContext context, HomeNSUIController controller) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF1F4FF), Color(0xFFF8FAFF)],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(controller),
            const SizedBox(height: 18),
            _buildBanner(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Quick Actions',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2A44))),
                Text('Election',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1356BF))),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _bentoTile(
                  title: 'Membership',
                  subtitle: 'Add & manage',
                  svgname: 'membership',
                  colors: const [Color(0xFF1356BF), Color(0xFF3B82F6)],
                  onTap: () => RoutesManagement.goToMembershipBatchScreen(),
                ),
                const SizedBox(width: 14),
                _bentoTile(
                  title: 'Nomination',
                  subtitle: 'File yours',
                  svgname: 'nomination',
                  colors: const [Color(0xFFF7971E), Color(0xFFFF5F6D)],
                  onTap: () {
                    toPage(
                      context,
                      MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                              create: (context) => NominationsProvider(
                                  apiConfig: sl<ApiConfig>()),
                            ),
                            ChangeNotifierProvider(
                                create: (context) => ViewNominationVm())
                          ],
                          child: const NominationsMain()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _bentoTile(
                  title: 'Scrutiny',
                  subtitle: 'Coming soon',
                  svgname: 'scrutiny',
                  colors: const [Color(0xFF7B2FF7), Color(0xFFB14BF4)],
                  onTap: () =>
                      CustomSnackBar.showAlertSnackBar('Coming Soon..'),
                ),
                const SizedBox(width: 14),
                _bentoTile(
                  title: 'RO Access',
                  subtitle: 'Coming soon',
                  svgname: 'roaccess',
                  colors: const [Color(0xFF11998E), Color(0xFF38EF7D)],
                  onTap: () =>
                      CustomSnackBar.showAlertSnackBar('Coming Soon..'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _wideTile(
              title: 'Result',
              subtitle: 'Live results & winners',
              svgname: 'result',
              colors: const [Color(0xFFFFB300), Color(0xFFFF7043)],
              onTap: () => CustomSnackBar.showAlertSnackBar('Coming Soon..'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(HomeNSUIController controller) {
    final name = controller.profileController.userDetail?.name ?? 'Member';
    final mobile = controller.profileController.userDetail == null
        ? ''
        : controller.maskMobileNumber(
            controller.profileController.userDetail!.mobile);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1356BF), Color(0xFF5B2EC4), Color(0xFF2CC7E2)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1356BF).withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  controller.profileController.userDetail?.profilePic ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/nsui/images/Vector2.png'),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hey there 👋',
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    if (mobile.isNotEmpty)
                      Text(mobile,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded,
                    color: Color(0xffFFD54F), size: 20),
                const SizedBox(width: 8),
                const Text('Your points',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                const Spacer(),
                CustomRatingBar(
                  itemSize: 16,
                  alignment: Alignment.center,
                  itemCount: 5,
                  color: const Color(0xffFFD54F),
                  initialRating:
                      int.parse(controller.profileController.authPoint) * 1.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Image.asset('assets/nsui/banner/newbanner2.jpeg',
              width: double.infinity,
              height: mediaQueryData.size.height * 0.20,
              fit: BoxFit.cover),
          Positioned(
            left: 14,
            top: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text('✦ Featured',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bentoTile({
    required String title,
    required String subtitle,
    required String svgname,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 152,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colors.last.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/nsui/svg/$svgname.svg',
                      height: 26,
                      width: 26,
                    ),
                  ),
                  const Icon(Icons.arrow_outward_rounded,
                      color: Colors.white, size: 20),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.85), fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wideTile({
    required String title,
    required String subtitle,
    required String svgname,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colors.last.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: SvgPicture.asset('assets/nsui/svg/$svgname.svg',
                  height: 28, width: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9), fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

class MyShape extends CircularNotchedRectangle {
  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) {
      return Path()..addRect(host);
    }

    final double notchRadius = guest.width / 2.0;

    const double s1 = 8.0;
    const double s2 = 1.0;

    final double r = notchRadius;
    final double a = -1.0 * r - s2;
    final double b = host.top - guest.center.dy;

    final double n2 = math.sqrt(
      b * b * r * r * (a * a + b * b - r * r),
    );
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = math.sqrt(r * r - p2xA * p2xA);
    final double p2yB = math.sqrt(r * r - p2xB * p2xB);

    final List<Offset> p = List.filled(6, Offset.zero);

    // p0, p1, and p2 are the control points for segment A.
    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    final double cmp = b < 0 ? -1.0 : 1.0;
    p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, -p2yA) : Offset(p2xB, -p2yB);

    // p3, p4, and p5 are the control points for segment B, mirror of A.
    p[3] = Offset(-p[2].dx, p[2].dy);
    p[4] = Offset(-p[1].dx, p[1].dy);
    p[5] = Offset(-p[0].dx, p[0].dy);

    for (int i = 0; i < p.length; i++) {
      p[i] += guest.center;
    }

    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(p[0].dx, p[0].dy)
      ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
      ..arcToPoint(
        p[3],
        radius: Radius.circular(notchRadius),
        clockwise: true,
      )
      ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}

class BannerPlaceholder extends StatelessWidget {
  const BannerPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150.0,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
    );
  }
}
