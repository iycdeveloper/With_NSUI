// import 'dart:io';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// import 'package:iyc/app/core/service/auth_service.dart';
// import 'package:iyc/app/core/utils/snackbar.dart';
// import 'package:iyc/app/modules/Home/home_controller.dart';
// import 'package:iyc/app/modules/Home/widgets/gridleaderboard1_item_widget_new.dart';
// import 'package:iyc/app/modules/Home/widgets/show_club_bottom_sheet.dart';
// import 'package:iyc/app/modules/Home/widgets/show_youthjodo_bottom_sheet.dart';
// import 'package:iyc/app/modules/profile/profile_controller.dart';
// import 'package:iyc/app/routes/routes_management.dart';
// import 'package:iyc/app/widgets/custom_rating_bar.dart';
// import 'package:iyc/screens/ui/home/yuva_booth/search_voters_list.dart';
// import 'package:iyc/utils/utils.dart';
// import 'package:iyc/view_model/yuva_booth/search_voters_list_vm.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../core/app_export.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     //  var size = MediaQuery.of(context).size;

//     // /*24 is for notification bar on Android*/
//     // final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
//     // final double itemWidth = size.width / 2;
//     mediaQueryData = MediaQuery.of(context);
//     double? height = MediaQuery.of(context).size.height;
//     double? width = MediaQuery.of(context).size.width;
//     return SafeArea(child: GetBuilder<HomeController>(builder: (logic) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             CustomImageView(
//                 imagePath: ImageConstant.img1538651805055r,
//                 height: 32.adaptSize,
//                 width: 32.adaptSize),
//             CustomImageView(
//                 imagePath: ImageConstant.imgIyclogotype1,
//                 height: 28.v,
//                 width: 68.h),
//             const Spacer(),
//             InkWell(
//               onTap: () {
//                 RoutesManagement.goToNotificationScreen();
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFF1356BF)),
//                     shape: BoxShape.circle),
//                 child: IconButton(
//                     padding: const EdgeInsets.all(8),
//                     constraints: const BoxConstraints(),
//                     style: const ButtonStyle(
//                       tapTargetSize:
//                           MaterialTapTargetSize.shrinkWrap, // the '2023' part
//                     ),
//                     onPressed: () {
//                       RoutesManagement.goToNotificationScreen();
//                     },
//                     icon: Icon(
//                       Icons.notifications,
//                       color: Color(0xFF1356BF),
//                     )),
//               ),
//             ),
//             SizedBox(
//               width: mediaQueryData.size.width * 0.01,
//             ),
//             InkWell(
//               onTap: () {
//                 Get.find<AuthService>().logout(context: context);
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFF1356BF)),
//                     shape: BoxShape.circle),
//                 child: IconButton(
//                     padding: const EdgeInsets.all(8),
//                     constraints: const BoxConstraints(),
//                     style: const ButtonStyle(
//                       tapTargetSize:
//                           MaterialTapTargetSize.shrinkWrap, // the '2023' part
//                     ),
//                     onPressed: () {
//                       Get.find<AuthService>().logout(context: context);
//                     },
//                     icon: Icon(
//                       Icons.logout,
//                       color: Color(0xFF1356BF),
//                     )),
//               ),
//             )
//             // logic.isLoading
//             //     ? const SizedBox()
//             //     : InkWell(
//             //         onTap: RoutesManagement.goToRewardsScreen,
//             //         child: CustomImageView(
//             //           height: 30,
//             //           width: 30,
//             //           imagePath: 'assets/images/home_rewards.png',
//             //         ),
//             //       ),
//             // const SizedBox(
//             //   width: 10,
//             // ),
//             // logic.isLoading
//             //     ? const SizedBox()
//             //     : InkWell(
//             //         onTap: RoutesManagement.goToProfileScreen,
//             //         child: logic.profileController.userDetail == null
//             //             ? CustomImageView(
//             //                 fit: BoxFit.fitHeight,
//             //                 imagePath: ImageConstant.imgGroup481994,
//             //                 height: 28.v,
//             //                 width: 28.h)
//             //             : CustomImageView(
//             //                 radius: BorderRadius.circular(40),
//             //                 fit: BoxFit.fitWidth,
//             //                 url:
//             //                     logic.profileController.userDetail!.profilePic!,
//             //                 height: 28.v,
//             //                 width: 28.h),
//             //       ),
//           ]),
//           elevation: 1,
//         ),
//         body: SizedBox(
//           width: mediaQueryData.size.width,
//           child: logic.isLoading
//               ? Shimmer.fromColors(
//                   baseColor: Colors.grey.shade300,
//                   highlightColor: Colors.grey.shade100,
//                   enabled: true,
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         const BannerPlaceholder(),
//                         // const SizedBox(height: 16.0),
//                         // const BannerPlaceholder(),
//                         Container(
//                             // margin: EdgeInsets.only(
//                             //     left: 0.h, top: 24.v, right: 0.h),
//                             child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                                 margin: EdgeInsets.only(
//                                     left: 20.h, top: 24.v, right: 20.h),
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     border: Border.all(
//                                       color: logic.selectedHomeTabColor,
//                                     )),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Container(
//                                       height: height * 0.08,
//                                       width: width * 0.16,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         border: Border.all(
//                                             width: 1, color: Colors.grey[200]!),
//                                       ),
//                                       clipBehavior: Clip
//                                           .hardEdge, // Ensures image respects borderRadius
//                                       // child: Image.network(
//                                       //   '${profileLogic.userDetail?.profilePic ?? ''}',
//                                       //   fit: BoxFit.cover,
//                                       //   errorBuilder:
//                                       //       (context, error, stackTrace) {
//                                       //     // If image fails to load, show a fallback image
//                                       //     return Padding(
//                                       //       padding: const EdgeInsets.all(8.0),
//                                       //       child: Image.asset(
//                                       //         'assets/images/newlogo/Vector2.png',
//                                       //         // fit: BoxFit.fill,
//                                       //         scale: 0.5,
//                                       //         // height: height * 0.02,
//                                       //         // width: width * 0.10,
//                                       //       ),
//                                       //     );
//                                       //   },
//                                       // ),
//                                     ),
//                                     SizedBox(
//                                       // color: Colors.amber,
//                                       width: width / 2.4,

//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           InkWell(
//                                               onTap: () {
//                                                 // RoutesManagement.goToViewBothScreen();
//                                               },
//                                               child: Text('******',
//                                                   style: theme
//                                                       .textTheme.bodyLarge!
//                                                       .copyWith(
//                                                           fontWeight: FontWeight
//                                                               .bold))),
//                                           Row(
//                                             children: [
//                                               Text("****** ",
//                                                   style: theme
//                                                       .textTheme.bodyLarge!
//                                                       .copyWith(
//                                                           fontWeight:
//                                                               FontWeight.bold)),
//                                               Text("Points",
//                                                   style: theme
//                                                       .textTheme.bodyLarge!
//                                                       .copyWith()),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       height: height * 0.075,
//                                       width: width * 0.26,
//                                       padding: const EdgeInsets.all(5),
//                                       alignment: Alignment.center,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(8),
//                                         color: Colors.amber.withOpacity(0.2),
//                                         border: Border.all(
//                                             width: 1,
//                                             color: Colors.amber[200]!),
//                                         // shape: BoxShape.circle
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           Text("  Rated",
//                                               style: theme.textTheme.bodyLarge!
//                                                   .copyWith()),
//                                           CustomRatingBar(
//                                               itemSize: 10,
//                                               alignment: Alignment.center,
//                                               itemCount: 5,
//                                               color: const Color(0xffFFB800),
//                                               initialRating:
//                                                   int.parse('0') * 1.0),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 )),
//                             //
//                           ],
//                         )),
//                         Column(
//                           children: [
//                             SizedBox(
//                               height: height * 0.008,
//                             ),
//                             Divider(
//                               indent: 20.h,
//                               endIndent: 20.h,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: height * 0.01,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(
//                               left: 18.h, top: 0.v, right: 18.h),
//                           child: Container(
//                             height: height * 0.07,
//                             decoration: BoxDecoration(
//                                 color: Colors.grey,
//                                 borderRadius: BorderRadius.circular(15),
//                                 border: Border.all(color: Colors.grey[200]!)),
//                           ),
//                         ),
//                         Padding(
//                             padding: EdgeInsets.only(
//                                 left: 20.h, top: 24.v, right: 20.h),
//                             child: GridView.builder(
//                                 shrinkWrap: true,
//                                 gridDelegate:
//                                     SliverGridDelegateWithFixedCrossAxisCount(
//                                         mainAxisExtent: 120.v,
//                                         crossAxisCount: 3,
//                                         mainAxisSpacing: 15.h,
//                                         crossAxisSpacing: 15.h),
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: 6,
//                                 itemBuilder: (context, index) {
//                                   return [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           color: Colors.grey,
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           border: Border.all(
//                                               color: Colors.grey[200]!)),
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           color: Colors.grey,
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           border: Border.all(
//                                               color: Colors.grey[200]!)),
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           color: Colors.grey,
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           border: Border.all(
//                                               color: Colors.grey[200]!)),
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           color: Colors.grey,
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           border: Border.all(
//                                               color: Colors.grey[200]!)),
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           color: Colors.grey,
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           border: Border.all(
//                                               color: Colors.grey[200]!)),
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           color: Colors.grey,
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           border: Border.all(
//                                               color: Colors.grey[200]!)),
//                                     ),
//                                   ][index];
//                                 })),
//                       ],
//                     ),
//                   ))
//               : Padding(
//                   padding: EdgeInsets.only(bottom: 10.v),
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: double.infinity,
//                     child: SingleChildScrollView(
//                       child: Column(children: [
//                         Padding(
//                           padding: EdgeInsets.only(
//                               left: 20.h, top: 20.v, right: 20.h),
//                           child: Stack(
//                             children: [
//                               SizedBox(
//                                 height: 180.v,
//                                 width: 690.h,
//                                 child: CarouselSlider(
//                                   options: CarouselOptions(
//                                       autoPlay: true,
//                                       height: 180.v,
//                                       viewportFraction: 1,
//                                       scrollDirection: Axis.horizontal,
//                                       onPageChanged: (index, _) {
//                                         logic.updateBannerIndex(index);
//                                       }),
//                                   items: logic.bannerUrlList.map((item) {
//                                     return Builder(
//                                       builder: (BuildContext context) {
//                                         return InkWell(
//                                           onTap: () async {
//                                             if (logic
//                                                 .bannerHyperlink[
//                                                     logic.bannerIndex]
//                                                 .isEmpty) {
//                                               return;
//                                             }
//                                             Log.printELog(logic.bannerHyperlink[
//                                                 logic.bannerIndex]);
//                                             final Uri urlParsed = Uri.parse(
//                                                 logic.bannerHyperlink[
//                                                     logic.bannerIndex]);
//                                             if (!await launchUrl(
//                                               urlParsed,
//                                               mode: LaunchMode
//                                                   .externalApplication, // Opens in Chrome
//                                             )) {
//                                               throw Exception(
//                                                   'Could not launch ${logic.bannerHyperlink[logic.bannerIndex]}');
//                                             }
//                                           },
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                             child: Container(
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             20)),
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 // margin:
//                                                 //     EdgeInsets.symmetric(horizontal: 5.0),
//                                                 child: Image.network(
//                                                   item,
//                                                   alignment: Alignment.center,
//                                                   fit: BoxFit.cover,
//                                                 )),
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 12.v,
//                                 left: 130.h,
//                                 child: Row(
//                                     children: List.generate(
//                                         logic.bannerUrlList.length,
//                                         (index) => Container(
//                                               height: 10,
//                                               width: 10,
//                                               margin: const EdgeInsets.only(
//                                                   right: 10),
//                                               decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   color: logic.bannerIndex ==
//                                                           index
//                                                       ? const Color(0xff2CC7E2)
//                                                       : Colors.white),
//                                             ))),
//                               )
//                             ],
//                           ),
//                         ),
//                         // GetBuilder<ProfileController>(builder: (profileLogic) {
//                         //   return Container(
//                         //       margin: EdgeInsets.only(
//                         //           left: 20.h, top: 24.v, right: 20.h),
//                         //       child: Row(
//                         //         mainAxisAlignment:
//                         //             MainAxisAlignment.spaceBetween,
//                         //         children: [
//                         //           SizedBox(
//                         //             width: width / 2,
//                         //             child: Column(
//                         //               crossAxisAlignment:
//                         //                   CrossAxisAlignment.start,
//                         //               children: [
//                         //                 InkWell(
//                         //                   onTap: () {
//                         //                     // RoutesManagement.goToViewBothScreen();
//                         //                   },
//                         //                   child: Text("Welcome Back",
//                         //                       style: theme.textTheme.titleLarge!
//                         //                           .copyWith(
//                         //                               fontWeight:
//                         //                                   FontWeight.bold)),
//                         //                 ),
//                         //                 Text(
//                         //                     profileLogic.userDetail == null
//                         //                         ? ""
//                         //                         : "${profileLogic.userDetail!.name}!",
//                         //                     style: theme.textTheme.titleLarge!
//                         //                         .copyWith(
//                         //                             fontWeight:
//                         //                                 FontWeight.bold)),
//                         //                 SizedBox(
//                         //                   height: height * 0.004,
//                         //                 ),
//                         //                 Text("----",
//                         //                     style: theme.textTheme.bodyLarge!
//                         //                         .copyWith(
//                         //                             fontWeight:
//                         //                                 FontWeight.bold)),
//                         //                 Row(
//                         //                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         //                   children: [
//                         //                     Text("Total Points",
//                         //                         style: theme
//                         //                             .textTheme.bodyLarge!
//                         //                             .copyWith()),
//                         //                     SizedBox(
//                         //                       width: width * 0.05,
//                         //                     ),
//                         //                     Text("${profileLogic.userPoint}",
//                         //                         style: theme
//                         //                             .textTheme.bodyLarge!
//                         //                             .copyWith(
//                         //                                 fontWeight:
//                         //                                     FontWeight.bold)),
//                         //                   ],
//                         //                 ),
//                         //               ],
//                         //             ),
//                         //           ),
//                         //           SizedBox(
//                         //             // color: Colors.amber,
//                         //             width: width - (width / 1.6),
//                         //             child: Column(
//                         //               crossAxisAlignment:
//                         //                   CrossAxisAlignment.end,
//                         //               // mainAxisAlignment: MainAxisAlignment.start,
//                         //               children: [
//                         //                 Container(
//                         //                   height: height * 0.1,
//                         //                   width: width * 0.18,
//                         //                   decoration: BoxDecoration(
//                         //                       image: DecorationImage(
//                         //                           fit: BoxFit.cover,
//                         //                           image: NetworkImage(
//                         //                               '${profileLogic.userDetail!.profilePic}')),
//                         //                       border: Border.all(
//                         //                           width: 1,
//                         //                           color: Colors.grey[200]!),
//                         //                       shape: BoxShape.circle),
//                         //                 ),
//                         //                 // Text("data")
//                         //                 CustomRatingBar(
//                         //                     alignment: Alignment.topRight,
//                         //                     itemCount: 5,
//                         //                     color: const Color(0xffFFB800),
//                         //                     initialRating: int.parse(
//                         //                             profileLogic.authPoint) *
//                         //                         1.0),
//                         //               ],
//                         //             ),
//                         //           )
//                         //         ],
//                         //       ));
//                         // }),
//                         GetBuilder<ProfileController>(builder: (profileLogic) {
//                           return Container(
//                               margin: EdgeInsets.only(
//                                   left: 20.h, top: 24.v, right: 20.h),
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   border: Border.all(
//                                     color: logic.selectedHomeTabColor,
//                                   )),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     height: height * 0.08,
//                                     width: width * 0.16,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       border: Border.all(
//                                           width: 1, color: Colors.grey[200]!),
//                                     ),
//                                     clipBehavior: Clip
//                                         .hardEdge, // Ensures image respects borderRadius
//                                     child: Image.network(
//                                       '${profileLogic.userDetail?.profilePic ?? ''}',
//                                       fit: BoxFit.cover,
//                                       errorBuilder:
//                                           (context, error, stackTrace) {
//                                         // If image fails to load, show a fallback image
//                                         return Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Image.asset(
//                                             'assets/images/newlogo/Vector2.png',
//                                             // fit: BoxFit.fill,
//                                             scale: 0.5,
//                                             // height: height * 0.02,
//                                             // width: width * 0.10,
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     // color: Colors.amber,
//                                     width: width / 2.6,

//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         InkWell(
//                                             onTap: () {
//                                               // RoutesManagement.goToViewBothScreen();
//                                             },
//                                             child: Text(
//                                                 profileLogic.userDetail == null
//                                                     ? ""
//                                                     : profileLogic
//                                                         .userDetail!.name,
//                                                 style: theme
//                                                     .textTheme.bodyLarge!
//                                                     .copyWith(
//                                                         fontWeight:
//                                                             FontWeight.bold))),
//                                         Row(
//                                           children: [
//                                             Text("${profileLogic.userPoint} ",
//                                                 style: theme
//                                                     .textTheme.bodyLarge!
//                                                     .copyWith(
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                             Text("Points",
//                                                 style: theme
//                                                     .textTheme.bodyLarge!
//                                                     .copyWith()),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     height: height * 0.075,
//                                     width: width * 0.26,
//                                     padding: const EdgeInsets.all(5),
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       color: Colors.amber.withOpacity(0.2),
//                                       border: Border.all(
//                                           width: 1, color: Colors.amber[200]!),
//                                       // shape: BoxShape.circle
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: [
//                                         Text("  Rated",
//                                             style: theme.textTheme.bodyLarge!
//                                                 .copyWith()),
//                                         CustomRatingBar(
//                                             itemSize: 10,
//                                             alignment: Alignment.center,
//                                             itemCount: 5,
//                                             color: const Color(0xffFFB800),
//                                             initialRating: int.parse(
//                                                     profileLogic.authPoint) *
//                                                 1.0),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ));
//                         }),
//                         // Column(
//                         //   children: [
//                         //     SizedBox(
//                         //       height: height * 0.004,
//                         //     ),
//                         //     Divider(
//                         //       indent: 20.h,
//                         //       endIndent: 20.h,
//                         //     ),
//                         //   ],
//                         // ),
//                         // InkWell(
//                         //   onTap: () {
//                         //     // RoutesManagement.goToYIKBScreen();
//                         //     RoutesManagement.goToMaiBahinMaanCamaignScreen(
//                         //         'माई बहिन मान योजना');
//                         //   },
//                         //   child: Container(
//                         //     margin: EdgeInsets.only(
//                         //         left: 20.h, top: 16.v, right: 20.h),
//                         //     height: 120.adaptSize,
//                         //     width: double.maxFinite,
//                         //     decoration: BoxDecoration(
//                         //         border: Border.all(
//                         //           color: appTheme.blue10001,
//                         //           width: 1.h,
//                         //         ),
//                         //         borderRadius: BorderRadius.circular(10),
//                         //         color: Colors.white,
//                         //         image: const DecorationImage(
//                         //             fit: BoxFit.fill,
//                         //             image: AssetImage(
//                         //                 'assets/images/campaign_banner.jpeg'))),
//                         //   ),
//                         // ),
//                         Container(
//                           margin: EdgeInsets.only(
//                               left: 20.h, top: 24.v, right: 20.h),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(10),
//                                 topRight: Radius.circular(10),
//                               ),
//                               border: Border.all(
//                                 color: logic.selectedHomeTabColor,
//                               )),
//                           child: TabBar(
//                             // labelPadding:EdgeInsets.only(left: 10,right: 10),
//                             controller: logic.homeTabController,
//                             onTap: (val) {
//                               logic.onchangeTab(val);
//                             },
//                             indicatorPadding: EdgeInsets.all(6),
//                             indicator: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: logic.selectedHomeTabColor),
//                             labelColor: Colors.white,
//                             unselectedLabelColor:
//                                 theme.textTheme.bodyLarge!.color,
//                             labelPadding:
//                                 const EdgeInsets.symmetric(horizontal: 0),
//                             // isScrollable: true,
//                             indicatorSize: TabBarIndicatorSize.tab,
//                             tabs: Platform.isIOS
//                                 ? logic.homesTabs2
//                                 : logic.homesTabs,
//                             padding: const EdgeInsets.all(8),
//                             labelStyle: theme.textTheme.bodyMedium!.copyWith(
//                                 // fontWeight: FontWeight.bold
//                                 // color: theme.textTheme.bodyLarge!.color
//                                 ),
//                           ),
//                         ),
//                         // Divider(
//                         //   color: logic.selectedHomeTabColor,
//                         // ),

//                         Builder(builder: (_) {
//                           if (logic.selectedTabbar == 0) {
//                             return organisationTap(
//                                 logic, context); //1st custom tabBarView
//                           } else if (logic.selectedTabbar == 1) {
//                             return emTap(logic); //2nd tabView
//                           } else {
//                             if (!Platform.isIOS) {
//                               return trainingTab(logic); //3rd tabView
//                             }
//                             return const SizedBox();
//                           }
//                         }),

//                         // TabBarView(
//                         //     controller: logic.homeTabController,
//                         //     children: [
//                         // organisationTap(
//                         //         logic),
//                         //       emTap(logic),
//                         //       if (!Platform.isIOS) trainingTab(logic)
//                         //     ]),

//                         // Container(
//                         //   //
//                         //   margin: EdgeInsets.only(
//                         //       left: 20.h, top: 24.v, right: 20.h),
//                         //   decoration: BoxDecoration(
//                         //       color: Colors.white,
//                         //       borderRadius: BorderRadius.circular(10),
//                         //       border: Border.all(
//                         //         color: logic.selectedHomeTabColor,
//                         //       )),
//                         //   child: Column(
//                         //     children: [
//                         //       Padding(
//                         //         padding: EdgeInsets.all(12.h),
//                         //         child: Row(
//                         //           mainAxisAlignment:
//                         //               MainAxisAlignment.spaceBetween,
//                         //           children: [
//                         //             Column(
//                         //               crossAxisAlignment:
//                         //                   CrossAxisAlignment.start,
//                         //               children: [
//                         //                 Text(
//                         //                   'Leaderboard',
//                         //                   style: theme.textTheme.bodyLarge!
//                         //                       .copyWith(
//                         //                           fontWeight: FontWeight.bold),
//                         //                 ),
//                         //                 Text(
//                         //                   'Complete, earn, and rise to the top',
//                         //                   style: theme.textTheme.bodySmall!
//                         //                       .copyWith(),
//                         //                 ),
//                         //               ],
//                         //             ),
//                         //             Container(
//                         //               decoration: BoxDecoration(
//                         //                 color: logic.selectedHomeTabColor,
//                         //                 borderRadius: BorderRadius.circular(10),
//                         //               ),
//                         //               child: IconButton(
//                         //                   onPressed: () {
//                         //                     RoutesManagement
//                         //                         .goToLeaderBoardScreen();
//                         //                   },
//                         //                   icon:
//                         //                       const Icon(Icons.arrow_forward)),
//                         //             )
//                         //           ],
//                         //         ),
//                         //       ),
//                         //       // const SizedBox(
//                         //       //   height: 10,
//                         //       // ),
//                         //       const Divider(),
//                         //       const SizedBox(
//                         //         height: 10,
//                         //       ),
//                         //       topLeaderboarduser(logic),
//                         //       // const SizedBox(
//                         //       //   height: 10,
//                         //       // ),
//                         //       // const Divider(),
//                         //       Padding(
//                         //         padding: EdgeInsets.only(
//                         //             left: 12.h, right: 12.h, bottom: 12.h),
//                         //         child: Row(
//                         //           mainAxisAlignment:
//                         //               MainAxisAlignment.spaceBetween,
//                         //           children: [
//                         //             Text(
//                         //               'Your Score',
//                         //               style: theme.textTheme.bodyLarge,
//                         //             ),
//                         //             Text(
//                         //               Get.find<ProfileController>().userPoint +
//                         //                   ' Points',
//                         //               style: theme.textTheme.bodyLarge!
//                         //                   .copyWith(
//                         //                       fontWeight: FontWeight.bold),
//                         //             )
//                         //           ],
//                         //         ),
//                         //       )
//                         //     ],
//                         //   ),
//                         // )
//                       ]),
//                     ),
//                   ),
//                 ),
//         ),
//         bottomNavigationBar: BottomAppBar(
//           color: Colors.white,
//           // shadowColor: Colors.grey,
//           shape: const CircularNotchedRectangle(),
//           notchMargin: 5.0,
//           clipBehavior: Clip.antiAlias,
//           child: SizedBox(
//             height: mediaQueryData.size.height * 0.01,
//             child: Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                 InkWell(
//                   highlightColor: Colors.white,
//                   onTap: () {
//                     logic.onItemTapped(0, context);
//                   },
//                   child: Column(
//                     children: [
//                       Image.asset(
//                         'assets/images/newbottomicon/home.png',
//                         color: logic.selectedIndex == 0
//                             ? Color(0xFF1356BF)
//                             : Colors.grey,
//                         // fit: BoxFit.cover,
//                       ),
//                       Text('Home',
//                           style: theme.textTheme.bodySmall!.copyWith(
//                             color: logic.selectedIndex == 0
//                                 ? Color(0xFF1356BF)
//                                 : Colors.grey,
//                           ))
//                     ],
//                   ),
//                 ),
//                 InkWell(
//                   highlightColor: Colors.white,
//                   onTap: () {
//                     logic.onItemTapped(1, context);
//                   },
//                   child: Column(
//                     children: [
//                       Image.asset(
//                         'assets/images/newbottomicon/membership.png',
//                         color: logic.selectedIndex == 1
//                             ? Color(0xFF1356BF)
//                             : Colors.grey,
//                         // fit: BoxFit.cover,
//                       ),
//                       Text('Membership',
//                           style: theme.textTheme.bodySmall!.copyWith(
//                             color: logic.selectedIndex == 1
//                                 ? Color(0xFF1356BF)
//                                 : Colors.grey,
//                           ))
//                     ],
//                   ),
//                 ),
//                 InkWell(
//                   highlightColor: Colors.white,
//                   onTap: () {
//                     logic.onItemTapped(2, context);
//                   },
//                   child: Column(
//                     children: [
//                       Image.asset(
//                         'assets/images/newbottomicon/leaderboard.png',
//                         color: logic.selectedIndex == 2
//                             ? Color(0xFF1356BF)
//                             : Colors.grey,
//                         // fit: BoxFit.cover,
//                       ),
//                       Text('Leaderboard',
//                           style: theme.textTheme.bodySmall!.copyWith(
//                             color: logic.selectedIndex == 2
//                                 ? Color(0xFF1356BF)
//                                 : Colors.grey,
//                           ))
//                     ],
//                   ),
//                 ),
//                 InkWell(
//                   highlightColor: Colors.white,
//                   onTap: () {
//                     logic.onItemTapped(3, context);
//                   },
//                   child: Column(
//                     children: [
//                       Image.asset(
//                         'assets/images/newbottomicon/profile.png',
//                         color: logic.selectedIndex == 3
//                             ? Color(0xFF1356BF)
//                             : Colors.grey,
//                         // fit: BoxFit.cover,
//                       ),
//                       Text('Profile',
//                           style: theme.textTheme.bodySmall!.copyWith(
//                             color: logic.selectedIndex == 3
//                                 ? Color(0xFF1356BF)
//                                 : Colors.grey,
//                           ))
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // bottomNavigationBar: BottomNavigationBar(
//         //   backgroundColor: Colors.white,
//         //   showSelectedLabels: true,
//         //   showUnselectedLabels: true,
//         //   selectedItemColor: Colors.lightBlueAccent,
//         //   selectedLabelStyle:
//         //       theme.textTheme.bodySmall!.copyWith(color: Colors.grey[400]),
//         //   unselectedLabelStyle:
//         //       theme.textTheme.bodySmall!.copyWith(color: Colors.grey[400]),
//         //   items: <BottomNavigationBarItem>[
//         //     BottomNavigationBarItem(
//         //         backgroundColor: Colors.white,
//         //         icon: Image.asset(
//         //           'assets/images/newbottomicon/home.png',
//         //           color: logic.selectedIndex == 0
//         //               ? Colors.lightBlueAccent
//         //               : Colors.grey,
//         //           // fit: BoxFit.cover,
//         //         ),
//         //         label: 'Home'),
//         //     BottomNavigationBarItem(
//         //         backgroundColor: Colors.white,
//         //         icon: Image.asset(
//         //           'assets/images/newbottomicon/membership.png',
//         //           color: logic.selectedIndex == 1
//         //               ? Colors.lightBlueAccent
//         //               : Colors.grey,
//         //         ),
//         //         label: 'Membership'),
//         //     BottomNavigationBarItem(
//         //         backgroundColor: Colors.white,
//         //         icon: Image.asset(
//         //           'assets/images/newbottomicon/leaderboard.png',
//         //           color: logic.selectedIndex == 2
//         //               ? Colors.lightBlueAccent
//         //               : Colors.grey,
//         //         ),
//         //         label: 'Leaderboard'),
//         //     BottomNavigationBarItem(
//         //         backgroundColor: Colors.white,
//         //         icon: Image.asset(
//         //           'assets/images/newbottomicon/profile.png',
//         //           color: logic.selectedIndex == 3
//         //               ? Colors.lightBlueAccent
//         //               : Colors.grey,
//         //         ),
//         //         label: 'Profile'),
//         //     // BottomNavigationBarItem(
//         //     //     backgroundColor: Colors.white,
//         //     //     icon: Container(
//         //     //       padding: const EdgeInsets.all(8.0),
//         //     //       decoration: BoxDecoration(
//         //     //         shape: BoxShape.circle,
//         //     //         border: Border.all(color: Colors.grey[300]!),
//         //     //         color: logic.selectedIndex == 2
//         //     //             ? Colors.lightBlueAccent
//         //     //             : Colors.white,
//         //     //       ),
//         //     //       child: Stack(
//         //     //         children: <Widget>[
//         //     //           const Icon(Icons.notifications),
//         //     //           Positioned(
//         //     //             right: 0,
//         //     //             child: Container(
//         //     //               padding: const EdgeInsets.all(1),
//         //     //               decoration: BoxDecoration(
//         //     //                 // color: Colors.red,
//         //     //                 borderRadius: BorderRadius.circular(6),
//         //     //               ),
//         //     //               constraints: const BoxConstraints(
//         //     //                 minWidth: 12,
//         //     //                 minHeight: 12,
//         //     //               ),
//         //     //               child: const Text(
//         //     //                 '1',
//         //     //                 style: TextStyle(
//         //     //                   color: Colors.white,
//         //     //                   fontSize: 8,
//         //     //                 ),
//         //     //                 textAlign: TextAlign.center,
//         //     //               ),
//         //     //             ),
//         //     //           )
//         //     //         ],
//         //     //       ),
//         //     //     ),
//         //     //     label: ''),
//         //     // BottomNavigationBarItem(
//         //     //     backgroundColor: Colors.white,
//         //     //     icon: Container(
//         //     //       padding: const EdgeInsets.all(8),
//         //     //       decoration: BoxDecoration(
//         //     //         shape: BoxShape.circle,
//         //     //         border: Border.all(color: Colors.grey[300]!),
//         //     //         color: logic.selectedIndex == 3
//         //     //             ? Colors.lightBlueAccent
//         //     //             : Colors.white,
//         //     //       ),
//         //     //       child: Container(
//         //     //         padding: const EdgeInsets.all(12),
//         //     //         decoration: BoxDecoration(
//         //     //             shape: BoxShape.circle,
//         //     //             color: logic.selectedIndex == 3
//         //     //                 ? Colors.blue
//         //     //                 : Colors.white,
//         //     //             image: logic.profileController.userDetail != null
//         //     //                 ? DecorationImage(
//         //     //                     scale: 2.0,
//         //     //                     image: NetworkImage(
//         //     //                         "${logic.profileController.userDetail!.profilePic}"))
//         //     //                 : null),
//         //     //       ),
//         //     //     ),
//         //     //     label: ''),
//         //   ],
//         //   currentIndex: logic.selectedIndex,
//         //   // fixedColor: Colors.deepPurple,
//         //   onTap: (value) {
//         //     logic.onItemTapped(value, context);
//         //   },
//         // ),
//       );
//     }));
//   }

//   // Padding topLeaderboarduser(HomeController logic) {
//   //   return Padding(
//   //     padding: EdgeInsets.only(left: 12.h, right: 12.h),
//   //     child: Column(
//   //       children: [
//   //         logic.pointsList.isEmpty
//   //             ? const SizedBox()
//   //             : Column(
//   //                 children: [
//   //                   Row(
//   //                     // mainAxisAlignment:
//   //                     //     MainAxisAlignment
//   //                     //         .spaceBetween,
//   //                     children: [
//   //                       Image.asset(
//   //                         height: mediaQueryData.size.height * 0.048,
//   //                         'assets/images/newuisvg/first.png',
//   //                         fit: BoxFit.cover,
//   //                       ),
//   //                       const SizedBox(
//   //                         width: 20,
//   //                       ),
//   //                       // CircleAvatar(
//   //                       //   radius: mediaQueryData
//   //                       //           .size.height *
//   //                       //       0.035,
//   //                       //   backgroundColor:
//   //                       //       Colors.amber,
//   //                       // ),
//   //                       SizedBox(
//   //                         width: mediaQueryData.size.width * 0.4,
//   //                         child: Column(
//   //                           crossAxisAlignment: CrossAxisAlignment.start,
//   //                           children: [
//   //                             InkWell(
//   //                                 onTap: () {
//   //                                   // RoutesManagement.goToViewBothScreen();
//   //                                 },
//   //                                 child: Text(logic.pointsList[0]['name'],
//   //                                     style: theme.textTheme.bodyMedium!
//   //                                         .copyWith(
//   //                                             color: theme
//   //                                                 .textTheme.bodyLarge!.color,
//   //                                             fontWeight: FontWeight.w500))),
//   //                             Row(
//   //                               children: [
//   //                                 Text(logic.pointsList[0]['points'],
//   //                                     style: theme.textTheme.bodyLarge!
//   //                                         .copyWith(
//   //                                             fontWeight: FontWeight.bold)),
//   //                                 Text(" Points",
//   //                                     style: theme.textTheme.bodyLarge!
//   //                                         .copyWith()),
//   //                               ],
//   //                             ),
//   //                           ],
//   //                         ),
//   //                       ),

//   //                       // Spacer()
//   //                     ],
//   //                   ),
//   //                   const SizedBox(
//   //                     height: 10,
//   //                   ),
//   //                   logic.pointsList.length > 3
//   //                       ? Row(
//   //                           // mainAxisAlignment:
//   //                           //     MainAxisAlignment
//   //                           //         .spaceBetween,
//   //                           children: [
//   //                             Image.asset(
//   //                               height: mediaQueryData.size.height * 0.048,
//   //                               'assets/images/newuisvg/second.png',
//   //                               fit: BoxFit.cover,
//   //                             ),
//   //                             const SizedBox(
//   //                               width: 20,
//   //                             ),

//   //                             // CircleAvatar(
//   //                             //   radius: mediaQueryData
//   //                             //           .size.height *
//   //                             //       0.035,
//   //                             //   backgroundColor:
//   //                             //       Colors.amber,
//   //                             // ),
//   //                             SizedBox(
//   //                               width: mediaQueryData.size.width * 0.4,
//   //                               child: Column(
//   //                                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                                 children: [
//   //                                   InkWell(
//   //                                       onTap: () {
//   //                                         // RoutesManagement.goToViewBothScreen();
//   //                                       },
//   //                                       child: Text(logic.pointsList[1]['name'],
//   //                                           style: theme.textTheme.bodyMedium!
//   //                                               .copyWith(
//   //                                                   color: theme.textTheme
//   //                                                       .bodyLarge!.color,
//   //                                                   fontWeight:
//   //                                                       FontWeight.w500))),
//   //                                   Row(
//   //                                     children: [
//   //                                       Text(logic.pointsList[1]['points'],
//   //                                           style: theme.textTheme.bodyLarge!
//   //                                               .copyWith(
//   //                                                   fontWeight:
//   //                                                       FontWeight.bold)),
//   //                                       Text(" Points",
//   //                                           style: theme.textTheme.bodyLarge!
//   //                                               .copyWith()),
//   //                                     ],
//   //                                   ),
//   //                                 ],
//   //                               ),
//   //                             ),

//   //                             // Spacer()
//   //                           ],
//   //                         )
//   //                       : const SizedBox(),
//   //                   const SizedBox(
//   //                     height: 10,
//   //                   ),
//   //                   logic.pointsList.length > 4
//   //                       ? Row(
//   //                           // mainAxisAlignment:
//   //                           //     MainAxisAlignment
//   //                           //         .spaceBetween,
//   //                           children: [
//   //                             Image.asset(
//   //                               height: mediaQueryData.size.height * 0.048,
//   //                               'assets/images/newuisvg/third.png',
//   //                               fit: BoxFit.cover,
//   //                             ),
//   //                             const SizedBox(
//   //                               width: 20,
//   //                             ),

//   //                             // CircleAvatar(
//   //                             //   radius: mediaQueryData
//   //                             //           .size.height *
//   //                             //       0.035,
//   //                             //   backgroundColor:
//   //                             //       Colors.amber,
//   //                             // ),
//   //                             SizedBox(
//   //                               width: mediaQueryData.size.width * 0.4,
//   //                               child: Column(
//   //                                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                                 children: [
//   //                                   InkWell(
//   //                                       onTap: () {
//   //                                         // RoutesManagement.goToViewBothScreen();
//   //                                       },
//   //                                       child: Text(logic.pointsList[2]['name'],
//   //                                           style: theme.textTheme.bodyMedium!
//   //                                               .copyWith(
//   //                                                   color: theme.textTheme
//   //                                                       .bodyLarge!.color,
//   //                                                   fontWeight:
//   //                                                       FontWeight.w500))),
//   //                                   Row(
//   //                                     children: [
//   //                                       Text(logic.pointsList[2]['points'],
//   //                                           style: theme.textTheme.bodyLarge!
//   //                                               .copyWith(
//   //                                                   fontWeight:
//   //                                                       FontWeight.bold)),
//   //                                       Text(" Points",
//   //                                           style: theme.textTheme.bodyLarge!
//   //                                               .copyWith()),
//   //                                     ],
//   //                                   ),
//   //                                 ],
//   //                               ),
//   //                             ),
//   //                           ],
//   //                         )
//   //                       : const SizedBox()

//   //                   // Spacer()
//   //                 ],
//   //               )
//   //       ],
//   //     ),
//   //   );
//   // }

//   Container organisationTap(HomeController logic, BuildContext context) {
//     // final appMenuCnt = Get.put(AppMenuController());

//     return Container(
//       margin: EdgeInsets.only(left: 20.h, right: 20.h),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.only(
//             bottomLeft: Radius.circular(10),
//             bottomRight: Radius.circular(10),
//           ),
//           border: Border.all(
//             color: logic.selectedHomeTabColor,
//           )),
//       child: GridView.count(
//           shrinkWrap: true,
//           childAspectRatio: ((mediaQueryData.size.width / 2) /
//               ((mediaQueryData.size.height - kToolbarHeight - 24) / 3.2)),
//           // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           mainAxisSpacing: 15.h,
//           crossAxisSpacing: 15.h,
//           // ),
//           physics: const NeverScrollableScrollPhysics(),
//           // itemCount: appMenuCnt.showObAccess ? 9 : 9,
//           children: List.generate(  10, (index) {
//             return [
//               GridLeaderBoardItemWidgetNew(
//                 "Youth Jodo",
//                 "assets/images/img_boothjodo.svg",
//                 onTap: () {
//                   showYouthJodoBottomSheet();
//                 },
//                 boxcolor: const Color(0xFFEBF7FF),
//                 textboxcolor: const Color(0xFFCEEBFF),
//               ),
//               GridLeaderBoardItemWidgetNew(
//                 "Meeting",
//                 'assets/images/newuisvg/meeting.svg',
//                 onTap: () {
//                   // RoutesManagement.goToProgramScreen();
//                   RoutesManagement.goToOrganisationMeetingHistory();
//                 },
//                 boxcolor: const Color(0xFFEEFFF2),
//                 textboxcolor: const Color(0xFFCDFFD8),
//               ),
//               GridLeaderBoardItemWidgetNew(
//                 "Campaign",
//                 'assets/images/img_campaign.svg',
//                 onTap: () {
//                   // openCampaignBottomSheet();
//                 },
//                 boxcolor: const Color(0xFFF2F0FF),
//                 textboxcolor: const Color(0xFFE8E4FF),
//               ),
//               GridLeaderBoardItemWidgetNew(
//                 "Club",
//                 'assets/images/newuisvg/clubnew.svg',
//                 onTap: () {
//                   showClubBottomSheet();
//                 },
//                 boxcolor: const Color(0xFFEBF7FF),
//                 textboxcolor: const Color(0xFFCEEBFF),
//               ),

//               GridLeaderBoardItemWidgetNew(
//                 "Panchayat Committee",
//                 'assets/images/newuisvg/streamlinemeeting.svg',
//                 onTap: () {
//                   RoutesManagement.goToBPYcScreen();
//                 },
//                 boxcolor: const Color(0xFFFFF0E5),
//                 textboxcolor: const Color(0xFFFFE0C9),
//               ),

//               // GridLeaderBoardItemWidgetNew(
//               //   "Media/SM",
//               //   'assets/images/newsvg/mediasm.svg',
//               //   onTap: () {
//               //     RoutesManagement.goToMediaSmForm();
//               //   },
//               // ),
//               // GridLeaderBoardItemWidgetNew(
//               //   "Shakti",
//               //   'assets/images/newsvg/shaktinew.svg',
//               //   onTap: () {
//               //     showShaktiBottomSheet();
//               //   },
//               // ),
//               // GridLeaderBoardItemWidgetNew(
//               //   "BPYC",
//               //   'assets/images/newsvg/bpyc2.svg',
//               //   onTap: () {
//               //     RoutesManagement.goToBPYcScreen();
//               //   },
//               // ),
//               // GridLeaderBoardItemWidgetNew(
//               //   "Programs",
//               //   'assets/images/newsvg/newprogram 2.svg',
//               //   onTap: () {
//               //     RoutesManagement.goToOrgNewProgramScreen();
//               //   },
//               // ),
//               // appMenuCnt.showObAccess
//               //     ? GridLeaderBoardItemWidgetNew(
//               //         "External\nTraining",
//               //         'assets/images/newsvg/Etraining.svg',
//               //         onTap: RoutesManagement.goToExternalTrainingScreen,
//               //       )
//               //     : const SizedBox(),
//               if (appMenuCnt.showObAccess) ...[
//                 GridLeaderBoardItemWidgetNew(
//                   "Check - in",
//                   'assets/images/newuisvg/checkin.svg',
//                   onTap: () {
//                     if (appMenuCnt.showObAccess) {
//                       RoutesManagement.goToCheckInScreen();
//                     } else {
//                       CustomSnackBar.showErrorSnackBar(
//                           'Kindly connect to support team');
//                     }
//                   },
//                   boxcolor: const Color(0xFFEBF7FF),
//                   textboxcolor: const Color(0xFFCEEBFF),
//                 )
//               ],
//               GridLeaderBoardItemWidgetNew(
//                 "My Report",
//                 'assets/images/newuisvg/myreport.svg',
//                 onTap: () {
//                   // openCampaignBottomSheet();
//                   if (['State Admin', 'Super Admin'].contains(
//                       Get.find<HomeController>()
//                           .profileController
//                           .userDetail!
//                           .roleName!)) {
//                     RoutesManagement.goToElectionReportScreen();
//                   } else {
//                     CustomSnackBar.showErrorSnackBar(
//                         "You don't have permission");
//                   }
//                 },
//                 boxcolor: const Color(0xFFEBF7FF),
//                 textboxcolor: const Color(0xFFCEEBFF),
//               ),
//               if (appMenuCnt.showObAccess) ...[
//                 GridLeaderBoardItemWidgetNew(
//                   "Assignment",
//                   'assets/images/newuisvg/newassignment.svg',
//                   onTap: () {
//                     RoutesManagement.goToAssignment();
//                   },
//                   boxcolor: const Color(0xFFEEFFF2),
//                   textboxcolor: const Color(0xFFCDFFD8),
//                 )
//               ],

//               GridLeaderBoardItemWidgetNew(
//                 "Add Role",
//                 'assets/images/img_role.svg',
//                 onTap: () {
//                   if (logic.yuvaUser == null) {
//                     CustomSnackBar.showErrorSnackBar(
//                         'User data not found or is not Active');
//                   } else {
//                     appMenuCnt.addRoleBottomSheet();
//                   }
//                   // Get.find<AppMenuController>().getYuvaUser();

//                   // Get.find<AppMenuController>().addRoleBottomSheet();
//                   // }
//                 },
//                 boxcolor: const Color(0xFFFFF0E5),
//                 textboxcolor: const Color(0xFFFFE0C9),
//               ),
//               GridLeaderBoardItemWidgetNew(
//                 "Program",
//                 'assets/images/newuisvg/newprogram.svg',
//                 onTap: () {
//                   RoutesManagement.goToOrgNewProgramScreen();
//                 },
//                 boxcolor: const Color(0xFFFFF0E5),
//                 textboxcolor: const Color(0xFFFFE0C9),
//               ),
//               GridLeaderBoardItemWidgetNew(
//                 "Voter List",
//                 'assets/images/newuisvg/survey (1) 1.svg',
//                 onTap: () async {
//                   await toPage(
//                       context,
//                       ChangeNotifierProvider(
//                           create: (context) => SearchVotersListVM(),
//                           child: const SearchVotersList()));
//                 },
//                 boxcolor: const Color(0xFFEBF7FF),
//                 textboxcolor: const Color(0xFFCEEBFF),
//               ),
//               GridLeaderBoardItemWidgetNew(
//                 "Media/SM",
//                 'assets/images/newsvg/mediasm.svg',
//                 onTap: () {
//                   RoutesManagement.goToMediaSmForm();
//                 },
//                 boxcolor: const Color(0xFFEEFFF2),
//                 textboxcolor: const Color(0xFFCDFFD8),
//               ),
//             ][index];
//           })),
//     );
//   }

//   emTap(HomeController logic) {
//     final appMenuCnt = Get.put(AppMenuController());
//     return Container(
//       margin: EdgeInsets.only(left: 20.h, right: 20.h),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.only(
//             bottomLeft: Radius.circular(10),
//             bottomRight: Radius.circular(10),
//           ),
//           border: Border.all(
//             color: logic.selectedHomeTabColor,
//           )),
//       child: GridView.count(
//           shrinkWrap: true,
//           // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           mainAxisSpacing: 15.h,
//           crossAxisSpacing: 15.h,
//           childAspectRatio: ((mediaQueryData.size.width / 2) /
//               ((mediaQueryData.size.height - kToolbarHeight - 24) / 3.2)),
//           // ),
//           physics: const NeverScrollableScrollPhysics(),
//           // itemCount: appMenuCnt.showObAccess ? 6 : 5,
//           // logic.menuController.showObAccess? 6:4,
//           children: List.generate(1, (index) {
//             return [
//               GridLeaderBoardItemWidgetNew(
//                 "Election Contested",
//                 "assets/images/newuisvg/election.svg",
//                 onTap: () {
//                   RoutesManagement.goToProfileScreen(tabIndex: 1);
//                 },
//                 boxcolor: const Color(0xFFEBF7FF),
//                 textboxcolor: const Color(0xFFCEEBFF),
//               ),
//               // GridLeaderBoardItemWidgetNew(
//               //   "Add Role",
//               //   ImageConstant.imgAddRole,
//               //   onTap: () {
//               //     if (logic.yuvaUser == null) {
//               //       CustomSnackBar.showErrorSnackBar(
//               //           'User data not found or is not Active');
//               //     } else {
//               //       appMenuCnt.addRoleBottomSheet();
//               //     }
//               //     // Get.find<AppMenuController>().getYuvaUser();

//               //     // Get.find<AppMenuController>().addRoleBottomSheet();
//               //     // }
//               //   },
//               // ),

//               // GridLeaderBoardItemWidgetNew(
//               //   "Reports",
//               //   'assets/images/newsvg/reports.svg',
//               //   onTap: () {
//               //     // openCampaignBottomSheet();
//               //     if (['State Admin', 'Super Admin'].contains(
//               //         Get.find<HomeController>()
//               //             .profileController
//               //             .userDetail!
//               //             .roleName!)) {
//               //       RoutesManagement.goToElectionReportScreen();
//               //     } else {
//               //       CustomSnackBar.showErrorSnackBar(
//               //           "You don't have permission");
//               //     }
//               //   },
//               // ),

//               // GridLeaderBoardItemWidgetNew(
//               //   "Election\nContested",
//               //   'assets/images/newsvg/electioncontest.svg',
//               //   onTap: () {
//               //     RoutesManagement.goToProfileScreen(tabIndex: 1);
//               //   },
//               // ),

//               // GridLeaderBoardItemWidgetNew(
//               //   "Voter List",
//               //   'assets/images/newsvg/votelist.svg',
//               //   onTap: () async {

//               //     await toPage(
//               //         context,
//               //         ChangeNotifierProvider(
//               //             create: (context) => SearchVotersListVM(),
//               //             child: const SearchVotersList()));
//               //   },
//               // ),
//               // appMenuCnt.showObAccess
//               //     ? GridLeaderBoardItemWidgetNew(
//               //         "Assignments",
//               //         'assets/images/newsvg/assignmentnew.svg',
//               //         onTap: () {
//               //           RoutesManagement.goToAssignment();
//               //         },
//               //       )
//               //     : const SizedBox(),
//               // appMenuCnt.showObAccess
//               //     ? GridLeaderBoardItemWidgetNew(
//               //         "Check - in",
//               //         ImageConstant.imgCheckIn,
//               //         onTap: () {
//               //           if (appMenuCnt.showObAccess) {
//               //             RoutesManagement.goToCheckInScreen();
//               //           } else {
//               //             CustomSnackBar.showErrorSnackBar(
//               //                 'Kindly connect to support team');
//               //           }
//               //         },
//               //       )
//               //     : const SizedBox(),
//             ][index];
//           })),
//     );
//   }

//   Container trainingTab(HomeController logic) {
//     // final appMenuCnt = Get.put(AppMenuController());

//     return Container(
//       margin: EdgeInsets.only(left: 20.h, right: 20.h),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.only(
//             bottomLeft: Radius.circular(10),
//             bottomRight: Radius.circular(10),
//           ),
//           border: Border.all(
//             color: logic.selectedHomeTabColor,
//           )),
//       child: GridView.count(
//           shrinkWrap: true,
//           childAspectRatio: ((mediaQueryData.size.width / 2) /
//               ((mediaQueryData.size.height - kToolbarHeight - 24) / 3.2)),
//           // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           mainAxisSpacing: 15.h,
//           crossAxisSpacing: 15.h,
//           // ),
//           physics: const NeverScrollableScrollPhysics(),
//           // itemCount: 1,
//           children: List.generate(appMenuCnt.showObAccess ? 1 : 0, (index) {
//             return [
//               if (appMenuCnt.showObAccess) ...[
//                 GridLeaderBoardItemWidgetNew(
//                   "External Training",
//                   "assets/images/newuisvg/training.svg",
//                   onTap: () {
//                     RoutesManagement.goToExternalTrainingScreen();
//                   },
//                   boxcolor: const Color(0xFFEBF7FF),
//                   textboxcolor: const Color(0xFFCEEBFF),
//                 ),
//               ]

//               // GridLeaderBoardItemWidgetNew(
//               //   "Nomination",
//               //   ImageConstant.imgNomination,
//               //   onTap: () {
//               //     toPage(
//               //       context,
//               //       MultiProvider(providers: [
//               //         ChangeNotifierProvider(
//               //           create: (context) =>
//               //               NominationsProvider(apiConfig: sl<ApiConfig>()),
//               //         ),
//               //         ChangeNotifierProvider(
//               //             create: (context) => ViewNominationVm())
//               //       ], child: const NominationsMain()),
//               //     );
//               //   },
//               // ),
//               // GridLeaderBoardItemWidgetNew(
//               //   "Membership",
//               //   ImageConstant.imgLegalCall,
//               //   onTap: () {
//               //     HomeController homeController = Get.find<HomeController>();
//               //     if ([
//               //       "LA",
//               //       "LK",
//               //       "ML",
//               //       "MN",
//               //     ].contains(homeController
//               //         .profileController.userDetail!.stateCode)) {
//               //       RoutesManagement.goToMembershipBatchScreen();
//               //     } else {
//               //       toPage(
//               //         context,
//               //         MultiProvider(providers: [
//               //           ChangeNotifierProvider(
//               //             create: (context) => sl<MembershipListProvider>(),
//               //           ),
//               //           ChangeNotifierProvider(
//               //             create: (context) =>
//               //                 BatchListProvider(apiConfig: sl()),
//               //           ),
//               //         ], child: const BatchMain()),
//               //       );
//               //     }
//               //   },
//               // ),
//               // GridLeaderBoardItemWidgetNew(
//               //   "Membership Report",
//               //   ImageConstant.imgMembershipRepSvg,
//               //   onTap: () {
//               //     toPage(
//               //         context,
//               //         ChangeNotifierProvider(
//               //           create: (context) => ReportsVM(),
//               //           child: const ReportsMain(),
//               //         ));
//               //   },
//               // ),
//               // GridLeaderBoardItemWidgetNew(
//               //   "Scrutiny",
//               //   ImageConstant.imgScrunity,
//               //   onTap: () {
//               //     toPage(
//               //         context,
//               //         MultiProvider(providers: [
//               //           ChangeNotifierProvider(
//               //             create: (context) => ScrutinyBatchVM(
//               //                 scrutinyRepo: sl(), apiConfig: sl()),
//               //           )
//               //         ], child: const ScrutinyBatchList()));
//               //   },
//               //   // onTap: RoutesManagement
//               //   //     .goToMyTeamScreen,
//               // ),
//               // GridLeaderBoardItemWidgetNew(
//               //   "Complaints",
//               //   ImageConstant.imgComplaints,
//               //   onTap: () {
//               //     toPage(
//               //         context,
//               //         MultiProvider(providers: [
//               //           ChangeNotifierProvider(
//               //             create: (context) => ComplaintsHomeVM(),
//               //           )
//               //         ], child: const ComplaintsHome()));
//               //     // openCampaignBottomSheet();
//               //     // toPage(
//               //     //     context,
//               //     //     ChangeNotifierProvider(
//               //     //       create: (context) =>
//               //     //           SelectCampaignVM(),
//               //     //       child: SelectCampaign(),
//               //     //     ));
//               //   },
//               // ),
//               // GridLeaderBoardItemWidgetNew(
//               //     "RO Access", ImageConstant.imgROAccess,
//               //     onTap: showRoAccessBottomSheet),
//             ][index];
//           })),
//     );
//   }

//   GetBuilder<ProfileController> profilePointsAndStar() {
//     return GetBuilder<ProfileController>(builder: (profileLogic) {
//       return Container(
//           margin: EdgeInsets.only(left: 20.h, top: 24.v, right: 20.h),
//           decoration: AppDecoration.gradientPrimaryToIndigo
//               .copyWith(borderRadius: BorderRadiusStyle.roundedBorder12),
//           child: profileLogic.userDetail == null
//               ? const SizedBox()
//               : Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                       Container(
//                           height: 94.v,
//                           width: 332.h,
//                           margin: EdgeInsets.only(left: 3.h),
//                           child:
//                               Stack(alignment: Alignment.topRight, children: [
//                             Opacity(
//                                 opacity: 0.1,
//                                 child: Align(
//                                     alignment: Alignment.bottomLeft,
//                                     child: Container(
//                                         height: 48.adaptSize,
//                                         width: 48.adaptSize,
//                                         decoration: BoxDecoration(
//                                             color: theme.colorScheme.primary
//                                                 .withOpacity(0.39),
//                                             borderRadius:
//                                                 BorderRadius.circular(24.h))))),
//                             CustomImageView(
//                                 imagePath: ImageConstant.imgSave,
//                                 height: 76.v,
//                                 width: 80.h,
//                                 alignment: Alignment.topRight),
//                             Align(
//                                 alignment: Alignment.bottomCenter,
//                                 child: Padding(
//                                     padding: EdgeInsets.fromLTRB(
//                                         17.h, 19.v, 20.h, 12.v),
//                                     child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Container(
//                                             decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                     width: 2,
//                                                     color: Colors.white),
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         12.h)),
//                                             child: CustomImageView(
//                                                 // border: Border.all(width: 2, color: Colors.white),
//                                                 fit: BoxFit.fitWidth,
//                                                 url: profileLogic
//                                                     .userDetail!.profilePic,
//                                                 // imagePath:
//                                                 //     ImageConstant
//                                                 //         .imgImage4360x60,
//                                                 height: 60.adaptSize,
//                                                 width: 60.adaptSize,
//                                                 radius: BorderRadius.circular(
//                                                     12.h)),
//                                           ),
//                                           Padding(
//                                               padding:
//                                                   EdgeInsets.only(left: 16.h),
//                                               child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     SizedBox(
//                                                       child: Text(
//                                                           profileLogic
//                                                               .userDetail!.name,
//                                                           style: CustomTextStyles
//                                                               .titleMediumOnPrimaryContainerMedium,
//                                                           overflow: TextOverflow
//                                                               .fade),
//                                                       width: 200,
//                                                       height: 21,
//                                                     ),
//                                                     SizedBox(height: 1.v),
//                                                     Text(
//                                                         '${profileLogic.userDetail!.mobile.substring(0, 5)}****${profileLogic.userDetail!.mobile.substring(8)}'
//                                                             .tr,
//                                                         style: CustomTextStyles
//                                                             .labelLargeOnPrimaryContainer_1),
//                                                     SizedBox(height: 4.v),
//                                                     CustomRatingBar(
//                                                         itemCount: 5,
//                                                         color: const Color(
//                                                             0xffFFB800),
//                                                         initialRating: int.parse(
//                                                                 profileLogic
//                                                                     .authPoint) *
//                                                             1.0)
//                                                   ])),
//                                           const Spacer(),
//                                           CustomImageView(
//                                               onTap: () {
//                                                 RoutesManagement
//                                                     .goToProfileScreen(
//                                                         tabIndex: 0);
//                                               },
//                                               svgPath:
//                                                   ImageConstant.imgArrowright,
//                                               height: 32.adaptSize,
//                                               width: 32.adaptSize,
//                                               margin:
//                                                   EdgeInsets.only(bottom: 28.v))
//                                         ])))
//                           ])),
//                       Padding(
//                           padding: EdgeInsets.only(top: 13.v, right: 20.h),
//                           child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                     height: 38.v,
//                                     width: 152.h,
//                                     child: Stack(
//                                         alignment: Alignment.topRight,
//                                         children: [
//                                           Opacity(
//                                               opacity: 0.2,
//                                               child: CustomImageView(
//                                                   imagePath:
//                                                       ImageConstant.imgGlobe,
//                                                   height: 20.v,
//                                                   width: 27.h,
//                                                   alignment:
//                                                       Alignment.bottomLeft)),
//                                           Align(
//                                               alignment: Alignment.topRight,
//                                               child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceEvenly,
//                                                   // mainAxisSize:
//                                                   //     MainAxisSize.min,
//                                                   children: [
//                                                     Padding(
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                                 vertical: 2.v),
//                                                         child: Text(
//                                                             "lbl_total_points"
//                                                                 .tr,
//                                                             style: CustomTextStyles
//                                                                 .labelLargeOnPrimaryContainer)),
//                                                     Padding(
//                                                         padding:
//                                                             EdgeInsets.only(
//                                                                 left: 12.h),
//                                                         child: Text(
//                                                             profileLogic
//                                                                 .userPoint,
//                                                             style: CustomTextStyles
//                                                                 .titleMediumOnPrimaryContainerBold))
//                                                   ]))
//                                         ])),
//                                 Padding(
//                                     padding: EdgeInsets.only(bottom: 17.v),
//                                     child: Text("lbl_score".tr.toUpperCase(),
//                                         style: CustomTextStyles
//                                             .titleMediumOnPrimaryContainer))
//                               ]))
//                     ]));
//     });
//   }
// }

// class Style extends StyleHook {
//   @override
//   double get activeIconSize => 40;

//   @override
//   double get activeIconMargin => 10;

//   @override
//   double get iconSize => 24;

//   @override
//   TextStyle textStyle(Color color, String? fontFamily) {
//     return TextStyle(
//         fontSize: 12, color: const Color(0xff869DB6), fontFamily: fontFamily);
//   }
// }

// class BannerPlaceholder extends StatelessWidget {
//   const BannerPlaceholder({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 150.0,
//       margin: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.0),
//         color: Colors.white,
//       ),
//     );
//   }
// }

// class TitlePlaceholder extends StatelessWidget {
//   final double width;

//   const TitlePlaceholder({
//     Key? key,
//     required this.width,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: width,
//             height: 12.0,
//             color: Colors.white,
//           ),
//           const SizedBox(height: 8.0),
//           Container(
//             width: width,
//             height: 12.0,
//             color: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }
// }

// enum ContentLineType {
//   twoLines,
//   threeLines,
// }

// class ContentPlaceholder extends StatelessWidget {
//   final ContentLineType lineType;

//   const ContentPlaceholder({
//     Key? key,
//     required this.lineType,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: 96.0,
//             height: 72.0,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12.0),
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(width: 12.0),
//           Expanded(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: 10.0,
//                   color: Colors.white,
//                   margin: const EdgeInsets.only(bottom: 8.0),
//                 ),
//                 if (lineType == ContentLineType.threeLines)
//                   Container(
//                     width: double.infinity,
//                     height: 10.0,
//                     color: Colors.white,
//                     margin: const EdgeInsets.only(bottom: 8.0),
//                   ),
//                 Container(
//                   width: 100.0,
//                   height: 10.0,
//                   color: Colors.white,
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
