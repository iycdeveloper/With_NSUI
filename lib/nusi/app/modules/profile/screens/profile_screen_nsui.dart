import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/nusi/app/modules/profile/widgets/delete_profile_webview.dart';
import 'package:iyc/app/modules/profile/widgets/profile_photo_change_view_buttom_sheet..dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/custom_floating_text_field_nsui.dart';
import 'package:iyc/app/widgets/custom_rating_bar.dart';
import 'package:iyc/app/widgets/loading_widget.dart';
import 'package:iyc/nusi/app/modules/profile/screens/profile_controller_nsui.dart';
import 'package:iyc/nusi/widgets/custom_elevated_button_nsui.dart';
import 'package:iyc/nusi/widgets/textfeild_with_label_nsui.dart';
import 'package:iyc/utils/utils.dart';

class ProfilescreenNSUI extends StatefulWidget {
  const ProfilescreenNSUI({super.key});

  @override
  State<ProfilescreenNSUI> createState() => _ProfilescreenNSUIState();
}

class _ProfilescreenNSUIState extends State<ProfilescreenNSUI> {
  // final controller = Get.put(ProfileNSUIController());

  static const Color _ink = Color(0xFF1F2A44);
  static const Color _indigo = Color(0xFF1356BF);

  Widget _buildHero(ProfileNSUIController controller, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1356BF), Color(0xFF5B2EC4), Color(0xFF2CC7E2)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _indigo.withOpacity(0.30),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: profilePhotoChangeViewBottomSheet,
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                controller.userDetail?.profilePic ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/nsui/images/Vector2.png',
                      scale: 0.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.userDetail != null
                      ? controller.userDetail!.name
                      : '',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.noBDetails != null
                      ? "${controller.noBDetails!.postalloted}"
                      : controller.obDetails != null
                          ? "${controller.obDetails!.postalloted}"
                          : "${controller.userDetail!.roleName}",
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 6),
                CustomRatingBar(
                    itemSize: 14,
                    alignment: Alignment.centerLeft,
                    itemCount: 5,
                    color: const Color(0xffFFB800),
                    initialRating: int.parse(controller.authPoint) * 1.0),
              ],
            ),
          ),
          InkWell(
            onTap: () => toPage(context, DeleteAccountScreen()),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return GetBuilder<ProfileNSUIController>(builder: (controller) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: controller.userDetail == null
            ? const LoadingWidget()
            : Container(
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
                      _buildHero(controller, context),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                        children: [
                          TextFieldWithLabelNSUI(
                            labelcolor: _ink,
                            controller: controller.fullNameController,
                            readOnly: true,
                            label: "Full Name",
                            hintText: "Full Name",
                            // focusNode: model.usernameFocus,
                            // nextFocus: model.lastNameFocus,

                            // readOnly: model.disableFields,
                            keyBoardType: TextInputType.name,
                            // controller: model.usernameController,
                            validation: (value) {
                              if (value.isEmpty) {
                                return 'Enter a Full Name';
                              }
                              return null;
                            },
                          ),
                          TextFieldWithLabelNSUI(
                            controller: controller.mobileNumberController,
                            labelcolor: _ink,
                            readOnly: true,
                            label: "Phone Number",
                            hintText: "Phone Number",
                            // focusNode: model.usernameFocus,
                            // nextFocus: model.lastNameFocus,

                            // readOnly: model.disableFields,
                            keyBoardType: TextInputType.name,
                            // controller: model.usernameController,
                            validation: (value) {
                              if (value.isEmpty) {
                                return 'Enter a Phone Number';
                              }
                              return null;
                            },
                          ),
                          CustomFloatingTextFieldNSUI(
                              labelcolor: _ink,
                              autofocus: false,
                              margin: EdgeInsets.only(
                                  left: 0.h, top: 0.v, right: 0.h),
                              controller: controller.stateController,
                              labelText: "Home State",
                              readOnly: true,
                              labelStyle: theme.textTheme.bodyLarge!,
                              hintText: "lbl_state".tr,
                              hintStyle: theme.textTheme.bodyLarge!),
                          CustomFloatingTextFieldNSUI(
                              labelcolor: _ink,
                              autofocus: false,
                              margin: EdgeInsets.only(
                                  left: 0.h, top: 0.v, right: 0.h),
                              controller: controller.districtController,
                              labelText: "lbl_district".tr,
                              readOnly: controller.isEditing,
                              labelStyle: theme.textTheme.bodyLarge!,
                              hintText: "lbl_district".tr,
                              hintStyle: theme.textTheme.bodyLarge!),
                          // DistrictPickerDropDownNSUI(

                          //   labelcolor: theme.textTheme.bodyLarge!.color,
                          //   selectedDistrict: controller.userDistrict,
                          //   districtList: controller.districtList,
                          //   // viewOnly: model.enableDistrictEdit,
                          //   onTap: () {
                          //     //  context.read<RegAssemblyProvider>().refresh();
                          //   },
                          //   onChanged: (value) {
                          //     controller.onChangeDistrict(value);
                          //   },
                          //   hinttext: 'Select District',
                          // ),
                          // CommonPickerDropDownNSUI(
                          //     labelcolor: theme.textTheme.bodyLarge!.color,
                          //     hinttext: 'University',
                          //     listValues: controller.universityList,
                          //     onTap: () {},
                          //     selectedValue: controller.selecteduniversity,
                          //     lable: 'University'),
                          // CommonPickerDropDownNSUI(
                          //     labelcolor: theme.textTheme.bodyLarge!.color,
                          //     hinttext: 'Select College',
                          //     listValues: controller.universityList,
                          //     onTap: () {},
                          //     selectedValue: controller.selecteduniversity,
                          //     lable: 'College'),

                          // DatePickerWidgetNSUI(
                          //     labelText: 'Date of Birth',
                          //     labelcolor: theme.textTheme.bodyLarge!.color,
                          //     selectedDate: controller.selectedDate ?? "DD/MM/YYYY",
                          //     onTap: () async {
                          //       FocusScope.of(context).unfocus();
                          //       print("-------");
                          //       print(
                          //           await LocalStorageServices().getDobEndRange());
                          //       final datePick = await showDatePicker(
                          //         context: context,
                          //         initialDate: DateTime.now(),
                          //         firstDate: DateTime.now(),
                          //         lastDate: DateTime(2080, 12, 31),
                          //         builder: (BuildContext? context, Widget? child) {
                          //           return Theme(
                          //             data: ThemeData.dark().copyWith(
                          //               colorScheme: ColorScheme.dark(
                          //                 primary: Constants.themeGradients[1],
                          //                 onPrimary: Colors.black87,
                          //                 surface: Constants.themeGradients[0],
                          //                 onSurface: Constants.themeGradients[1],
                          //               ),
                          //               dialogBackgroundColor:
                          //                   Constants.themeGradients[0],
                          //             ),
                          //             child: child!,
                          //           );
                          //         },
                          //       );
                          //       //await datePicker(context);

                          //       if (datePick != null &&
                          //           datePick != controller.eventDate) {
                          //         controller.changeDate(datePick);
                          //       }
                          //     }),
                          TextFieldWithLabelNSUI(
                            //
                            labelcolor: _ink,
                            controller: controller.dobController,

                            label: "Date of Birth",
                            hintText: "Date of Birth",
                            // focusNode: model.usernameFocus,
                            // nextFocus: model.lastNameFocus,

                            // readOnly: model.disableFields,
                            keyBoardType: TextInputType.name,
                            // controller: model.usernameController,
                            validation: (value) {
                              if (value.isEmpty) {
                                return 'Enter a Date of Birth';
                              }
                              return null;
                            },
                          ),
                          TextFieldWithLabelNSUI(
                            //
                            labelcolor: _ink,

                            label: "Email",
                            hintText: "Email",
                            // focusNode: model.usernameFocus,
                            // nextFocus: model.lastNameFocus,

                            // readOnly: model.disableFields,
                            keyBoardType: TextInputType.name,
                            // controller: model.usernameController,
                            validation: (value) {
                              if (value.isEmpty) {
                                return 'Enter a Email';
                              }
                              return null;
                            },
                          ),
                          TextFieldWithLabelNSUI(
                            labelcolor: _ink,
                            readOnly: controller.isEditing,
                            controller: controller.addressController,
                            label: "Addresss",
                            hintText: "Addresss",
                            // focusNode: model.usernameFocus,
                            // nextFocus: model.lastNameFocus,

                            // readOnly: model.disableFields,
                            keyBoardType: TextInputType.name,
                            // controller: model.usernameController,
                            validation: (value) {
                              if (value.isEmpty) {
                                return 'Enter a Email';
                              }
                              return null;
                            },
                          ),
                          TextFieldWithLabelNSUI(
                            labelcolor: _ink,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(7)
                            ],
                            label: "Pincode",
                            hintText: "Pincode",
                            readOnly: controller.isEditing,
                            controller: controller.pincodeController,

                            // focusNode: model.usernameFocus,
                            // nextFocus: model.lastNameFocus,

                            // readOnly: model.disableFields,
                            keyBoardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            // controller: model.usernameController,
                            validation: (value) {
                              if (value.isEmpty) {
                                return 'Enter a Pincode';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // CustomElevatedButtonNSUI(
                          //     buttonStyle: ButtonStyle(
                          //         backgroundColor:
                          //             WidgetStateProperty.all(Colors.blue)),
                          //     text: 'Download ID',
                          //     onTap: RoutesManagement.goToIdCardScreen),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      ),
                    ],
                  ),
                ),
              ),
        // bottomNavigationBar: Container(
        //     padding: EdgeInsets.only(
        //         left: 20.h, right: 20.h, bottom: 10.v, top: 10.v),
        //     decoration: AppDecoration.outlineBlue100011,
        //     child: CustomElevatedButtonNSUI(
        //       buttonStyle: ButtonStyle(
        //         backgroundColor: WidgetStateProperty.all(Colors.blue)
        //       ),
        //       text: 'Download ID', onTap: null)),
        // bottomNavigationBar: MotionTabBar(
        //   controller: Get.find<HomeNSUIController>()
        //       .motionTabBarController, // ADD THIS if you need to change your tab programmatically
        //   initialSelectedTab: "Social",
        //   useSafeArea: true, // default: true, apply safe area wrapper
        //   labelAlwaysVisible:
        //       true, // default: false, set to "true" if you need to always show labels
        //   labels: const ["Home", "Social", "Profile"],
        //   // use custom widget as display Icon
        //   iconWidgets: [
        //     SvgPicture.asset('assets/nsui/svg/bottomhome.svg'),
        //     SvgPicture.asset(
        //       'assets/nsui/svg/bottomsocial.svg',
        //       fit: BoxFit.fill,
        //     ),
        //     SvgPicture.asset('assets/nsui/svg/bottomprofile.svg'),
        //   ],

        //   tabSize: 50,
        //   // tabBarHeight: mediaQueryData.size.height*0.08,
        //   textStyle: const TextStyle(
        //     fontSize: 12,
        //     color: Colors.black,
        //     fontWeight: FontWeight.w500,
        //   ),
        //   // tabIconColor: Colors.blue[600],
        //   tabIconSize: 28.0,
        //   tabIconSelectedSize: 32.0,
        //   tabSelectedColor: Colors.white,
        //   tabIconSelectedColor: Colors.black,
        //   tabBarColor: Colors.white,
        //   onTabItemSelected: (int value) {
        //     Get.find<HomeNSUIController>().onchangeMenu(value);
        //   },
        // ),
      );
    });
    //   );
    // });
  }
}
