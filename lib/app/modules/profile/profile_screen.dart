import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/app/core/service/auth_service.dart';
import 'package:iyc/app/core/utils/validation_functions.dart';
import 'package:iyc/app/modules/profile/profile_controller.dart';
import 'package:iyc/app/modules/profile/widgets/profile_photo_change_view_buttom_sheet..dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_text_field.dart';
import 'package:iyc/app/widgets/custom_rating_bar.dart';
import 'package:iyc/app/widgets/drop_down/assembly_picker_drop_down.dart';
import 'package:iyc/app/widgets/drop_down/district_picker_drop_down.dart';
import 'package:iyc/screens/widgets/dropdown/category_picker_new_dropdown.dart';
import 'package:iyc/utils/constants.dart';
import '../../core/app_export.dart';

// ignore_for_file: must_be_immutable
class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final int tapindex = Get.arguments ?? 1;
    print("object" + tapindex.toString());
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(child: GetBuilder<ProfileController>(builder: (logic) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Constants.themeGradients[0],
            title: Text(
              tapindex == 0 ? 'Profile' : "Election Contested",
              // "MB-005-00-16",
              style: Constants.appbarTitleTextStyle,
            ),
            // bottom: TabBar(
            //   controller: logic.tabController,
            //   labelStyle: const TextStyle(
            //     fontSize: 16.0,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //     letterSpacing: 1.2,
            //     fontFamily: 'Roboto',
            //   ),
            //   unselectedLabelStyle: const TextStyle(
            //     fontSize: 14.0,
            //     color: Colors.white70,
            //     fontWeight: FontWeight.normal,
            //   ),
            //   labelColor: appTheme.indigo800, // Selected tab text color
            //   unselectedLabelColor: appTheme.indigo800,
            //   tabs: const [
            //     Tab(
            //       text: 'Personal Detail',
            //     ),
            //     Tab(text: 'Election Detail'),
            //   ],
            // ),
          ),
          body:
              // TabBarView(
              //   controller: logic.tabController,
              //   children: [
              tapindex == 0
                  ? profileDetails(logic, context)
                  : electionContest(logic)
          //   ],
          // ),
          );
    }));
  }

  Column electionContest(ProfileController logic) {
    return Column(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: List.generate(
                logic.electionData.length,
                (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: appTheme.indigo800),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: DataTable(
                              columnSpacing: 20,
                              columns: const [
                                DataColumn(
                                    label: Text('Detail',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Information',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: [
                                DataRow(cells: [
                                  const DataCell(Text('Year')),
                                  DataCell(Text(
                                      '${logic.electionData[index]['year']}')),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                      Text('Level of Election Contest')),
                                  DataCell(Text(
                                      '${logic.electionData[index]['election_level']}')),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                      Text('Number of Votes Obtained')),
                                  DataCell(Text(
                                      '${logic.electionData[index]['votes_obtained']}')),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Result')),
                                  DataCell(Text(
                                      '${logic.electionData[index]['result']}')),
                                ]),
                              ],
                            )),
                      ),
                    )),
          ),
        )),
        CustomElevatedButton(
            onTap: RoutesManagement.goToAddElectionDetail,
            text: 'Add',
            margin: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 19.v))
      ],
    );
  }

  Form profileDetails(ProfileController logic, BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(bottom: 5.v),
                child: Column(children: [
                  Padding(
                      padding:
                          EdgeInsets.only(left: 20.h, top: 10.v, right: 20.h),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomImageView(
                                onTap: () {
                                  profilePhotoChangeViewBottomSheet();
                                },
                                url: logic.userDetail!.profilePic,
                                height: 80.adaptSize,
                                width: 80.adaptSize,
                                radius: BorderRadius.circular(12.h)),
                            Padding(
                                padding: EdgeInsets.only(left: 20.h, top: 4.v),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(logic.userDetail!.name,
                                          style: theme.textTheme.titleLarge),
                                      SizedBox(height: 1.v),
                                      logic.noBDetails != null
                                          ? Text(
                                              "${logic.noBDetails!.postalloted}",
                                              style: theme.textTheme.bodyLarge)
                                          : logic.obDetails != null
                                              ? Text(
                                                  "${logic.obDetails!.postalloted}",
                                                  style:
                                                      theme.textTheme.bodyLarge)
                                              : Text(
                                                  "${logic.userDetail!.roleName}",
                                                  style: theme
                                                      .textTheme.bodyLarge),
                                      SizedBox(height: 9.v),
                                      CustomRatingBar(
                                          itemCount: 5,
                                          color: const Color(0xffFFB800),
                                          initialRating:
                                              int.parse(logic.authPoint) * 1.0)
                                    ])),
                            // InkWell(
                            //   onTap: () {
                            //     // showCupertinoDialog(
                            //     //   context: context,
                            //     //   builder: (context) => CupertinoAlertDialog(
                            //     //     title: new Text("Delete Account"),
                            //     //     content: new Text(
                            //     //         "Are you sure you want to delete your account?"),
                            //     //     actions: <Widget>[
                            //     //       CupertinoDialogAction(
                            //     //         isDefaultAction: true,
                            //     //         child: const Text(
                            //     //           "Delete",
                            //     //           style: TextStyle(color: Colors.red),
                            //     //         ),
                            //     //         onPressed: () {
                            //     //           Get.find<AuthService>()
                            //     //               .deleteAccount();
                            //     //         },
                            //     //       ),
                            //     //       CupertinoDialogAction(
                            //     //         child: const Text(
                            //     //           "Cancel",
                            //     //           style: TextStyle(color: Colors.green),
                            //     //         ),
                            //     //         onPressed: Get.back,
                            //     //       )
                            //     //     ],
                            //     //   ),
                            //     // );

                            //     // RoutesManagement.goToSocialScreen();
                            //   },
                            //   child: Container(
                            //     width: 45.v,
                            //     height: 45.v,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(12),
                            //         // border: BoxB,
                            //         color: Colors.white),
                            //     child: const Icon(Icons.delete,
                            //         size: 24, color: Color(0xff2CC7E2)),
                            //   ),
                            // ),
                            // ignore: prefer_const_constructors
                            const Spacer(),

                            Platform.isIOS
                                ? CustomImageView(
                                    svgPath: ImageConstant.imgDelete,
                                    height: 32.adaptSize,
                                    width: 32.adaptSize,
                                    color: Colors.black,
                                    margin: EdgeInsets.only(bottom: 56.v),
                                    onTap: () {
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                          title: new Text("Delete Account"),
                                          content: new Text(
                                              "Are you sure you want to delete your account?"),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                              isDefaultAction: true,
                                              child: const Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () {
                                                Get.find<AuthService>()
                                                    .deleteAccount();
                                              },
                                            ),
                                            CupertinoDialogAction(
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                              onPressed: Get.back,
                                            )
                                          ],
                                        ),
                                      );
                                    })
                                : SizedBox(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.008,
                            ),
                            CustomImageView(
                                svgPath: !logic.isEditing
                                    ? ImageConstant.imgEpcircleclose
                                    : ImageConstant.imgEditing1,
                                height: 24.adaptSize,
                                width: 24.adaptSize,
                                color: Colors.black,
                                margin: EdgeInsets.only(bottom: 56.v),
                                onTap: () {
                                  logic.onClickEdit();
                                })
                          ])),
                  Container(
                      margin:
                          EdgeInsets.only(left: 20.h, top: 23.v, right: 20.h),
                      decoration: AppDecoration.fillBlue.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 68.v,
                                width: 130.h,
                                margin: EdgeInsets.only(
                                    left: 10.h, top: 18.v, bottom: 10.v),
                                child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Opacity(
                                          opacity: 0.2,
                                          child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Container(
                                                  height: 32.adaptSize,
                                                  width: 32.adaptSize,
                                                  decoration: BoxDecoration(
                                                      color: theme
                                                          .colorScheme.primary
                                                          .withOpacity(0.42),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.h))))),
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("lbl_your_score".tr,
                                                    style: CustomTextStyles
                                                        .titleMediumPrimary18),
                                                SizedBox(height: 5.v),
                                                SizedBox(
                                                    width: 116.h,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(logic.userPoint,
                                                              style: theme
                                                                  .textTheme
                                                                  .headlineSmall),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          6.v),
                                                              child: Text(
                                                                  "lbl_points"
                                                                      .tr,
                                                                  style: CustomTextStyles
                                                                      .bodyMediumOnPrimaryContainer))
                                                        ]))
                                              ]))
                                    ])),
                            Padding(
                                padding: EdgeInsets.only(bottom: 22.v),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Opacity(
                                                    opacity: 0.2,
                                                    child: CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgStar616,
                                                        height: 24.adaptSize,
                                                        width: 24.adaptSize,
                                                        radius: BorderRadius
                                                            .circular(2.h),
                                                        margin: EdgeInsets.only(
                                                            bottom: 25.v))),
                                                CustomImageView(
                                                    svgPath:
                                                        ImageConstant.imgUser,
                                                    height: 49.v,
                                                    width: 56.h,
                                                    margin: EdgeInsets.only(
                                                        left: 45.h))
                                              ])),
                                      SizedBox(height: 2.v),
                                      GestureDetector(
                                          onTap: () {
                                            RoutesManagement
                                                .goToLeaderBoardScreen();
                                          },
                                          child: Row(children: [
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4.h,
                                                    vertical: 1.v),
                                                decoration: AppDecoration
                                                    .outlineOnPrimaryContainer,
                                                child: Text(
                                                    "lbl_leaderboard2".tr,
                                                    style: CustomTextStyles
                                                        .bodyLargeOnPrimaryContainer)),
                                            CustomImageView(
                                                svgPath:
                                                    ImageConstant.imgGroup17,
                                                height: 1.v,
                                                width: 12.h,
                                                margin: EdgeInsets.only(
                                                    left: 4.h,
                                                    top: 12.v,
                                                    bottom: 10.v))
                                          ]))
                                    ]))
                          ])),

                  CustomFloatingTextField(
                      autofocus: !logic.isEditing,
                      margin:
                          EdgeInsets.only(left: 20.h, top: 24.v, right: 20.h),
                      controller: logic.fullNameController,
                      labelText: "lbl_full_name".tr,
                      labelStyle: theme.textTheme.bodyLarge!,
                      hintText: "lbl_full_name".tr,
                      readOnly: logic.isEditing, //logic.isEditing,
                      hintStyle: theme.textTheme.bodyLarge!,
                      validator: (value) {
                        if (!isText(value)) {
                          return "Please enter valid text";
                        }
                        return null;
                      }),
                  CustomFloatingTextField(
                      autofocus: false,
                      margin:
                          EdgeInsets.only(left: 20.h, top: 20.v, right: 20.h),
                      controller: logic.mobileNumberController,
                      labelText: "lbl_mobile_number".tr,
                      labelStyle: theme.textTheme.bodyLarge!,
                      hintText: "lbl_mobile_number".tr,
                      hintStyle: theme.textTheme.bodyLarge!,
                      textInputType: TextInputType.phone,
                      readOnly: true,
                      validator: (value) {
                        if (!isValidPhone(value)) {
                          return "Please enter valid phone number";
                        }
                        return null;
                      }),
                  CustomFloatingTextField(
                      autofocus: false,
                      margin:
                          EdgeInsets.only(left: 20.h, top: 20.v, right: 20.h),
                      controller: logic.addressController,
                      labelText: "Address",
                      readOnly: logic.isEditing,
                      labelStyle: theme.textTheme.bodyLarge!,
                      hintText: "Address",
                      hintStyle: theme.textTheme.bodyLarge!),
                  CustomFloatingTextField(
                      autofocus: false,
                      margin:
                          EdgeInsets.only(left: 20.h, top: 20.v, right: 20.h),
                      controller: logic.pincodeController,
                      labelText: "Pincode",
                      readOnly: logic.isEditing,
                      labelStyle: theme.textTheme.bodyLarge!,
                      hintText: "Pincode",
                      // inputFormatters: [LengthLimitingTextInputFormatter(6)],
                      textInputType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6)
                      ],
                      hintStyle: theme.textTheme.bodyLarge!),
                  CustomFloatingTextField(
                      autofocus: false,
                      margin:
                          EdgeInsets.only(left: 20.h, top: 20.v, right: 20.h),
                      controller: logic.workStateController,
                      labelText: "Work State",
                      readOnly: true,
                      labelStyle: theme.textTheme.bodyLarge!,
                      hintText: "Work State".tr,
                      hintStyle: theme.textTheme.bodyLarge!),
                  CustomFloatingTextField(
                      autofocus: false,
                      margin:
                          EdgeInsets.only(left: 20.h, top: 20.v, right: 20.h),
                      controller: logic.stateController,
                      labelText: "Home State",
                      readOnly: true,
                      labelStyle: theme.textTheme.bodyLarge!,
                      hintText: "lbl_state".tr,
                      hintStyle: theme.textTheme.bodyLarge!),
                  // CustomFloatingTextField(
                  //   autofocus: false,
                  //     margin: EdgeInsets.only(
                  //         left: 20.h, top: 20.v, right: 20.h),
                  //     controller: controller.districtController,
                  //     labelText: "lbl_district".tr,
                  //     readOnly: controller.isEditing,
                  //     labelStyle: theme.textTheme.bodyLarge!,
                  //     hintText: "lbl_district".tr,
                  //     hintStyle: theme.textTheme.bodyLarge!),
                  // CustomFloatingTextField(
                  //     autofocus: false,
                  //     margin: EdgeInsets.only(
                  //         left: 20.h, top: 20.v, right: 20.h),
                  //     controller: controller.assemblyController,
                  //     labelText: "lbl_assembly2".tr,
                  //     readOnly: controller.isEditing,
                  //     labelStyle: theme.textTheme.bodyLarge!,
                  //     hintText: "lbl_assembly2".tr,
                  //     hintStyle: theme.textTheme.bodyLarge!,
                  //     textInputAction: TextInputAction.done),
                  DistrictDropDrown(
                      readOnly: logic.isEditing,
                      title: 'Choose District',
                      value: logic.userDistrict,
                      listValues: logic.districtList,
                      onChanged: (value) {
                        logic.onChangeDistrict(value);
                      }),
                  AssemblyDropDrown(
                      readOnly: logic.isEditing,
                      title: 'Select Assembly Constituency',
                      value: logic.userAssembly,
                      listValues: logic.assemblyList,
                      onChanged: (value) {
                        logic.onChangeAssembly(value);
                      }),
                  CategoryPickerNew(
                      currentValue: logic.selectedCategory,
                      listValues: logic.categoryList,
                      viewOnly: logic.isEditing,
                      onChanged: (val) {
                        logic.changeCategory(val);
                      },
                      labelText: "Category",
                      hintText: "Select Category"),
                  CustomFloatingTextField(
                    margin: EdgeInsets.only(left: 20.h, top: 20.v, right: 20.h),
                    controller: logic.subcasteController,
                    labelText: "Sub Category",
                    readOnly: logic.isEditing,
                    labelStyle: theme.textTheme.bodyLarge!,
                    hintText: "Sub Category",
                    hintStyle: theme.textTheme.bodyLarge!,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomElevatedButton(
                      onTap: () {
                        if (!logic.isEditing) {
                          logic.updateProfile();
                        } else {
                          RoutesManagement.goToIdCardScreen();
                        }
                      },
                      text: !logic.isEditing
                          ? 'Update'
                          : "lbl_download_id".tr.toUpperCase(),
                      margin: EdgeInsets.only(
                          left: 20.h, right: 20.h, bottom: 19.v))
                ]))));
  }
}
