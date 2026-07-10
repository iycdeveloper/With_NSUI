import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/image_constant.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/nusi/widgets/date_picker_widget_nsui.dart';
import 'package:iyc/nusi/widgets/dropdown_picker_nsui.dart';
import 'package:iyc/nusi/widgets/education_dropdown_nsui.dart';
import 'package:iyc/nusi/widgets/field_label_nsui.dart';
import 'package:iyc/nusi/widgets/state_picker_dropdown_nsui.dart';
import 'package:iyc/nusi/widgets/textfeild_with_label_nsui.dart';
import 'package:iyc/nusi/widgets/upload_button_nsui.dart';
import 'package:iyc/provider/nomination/nominations_provider.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/screens/ui/membership_ui/contact_info_page.dart';
import 'package:iyc/screens/ui/nominations/view_nominations.dart';
import 'package:iyc/screens/widgets/button/upload_button.dart' as upload;
import 'package:iyc/screens/widgets/dropdown/assembly_picker_dropdown_nsui.dart';
import 'package:iyc/screens/widgets/dropdown/district_picker_dropdown_nsui.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/dob_rules.dart';
import 'package:provider/provider.dart';

import 'nomination_help_page.dart';

class NominationsMain extends StatefulWidget {
  const NominationsMain({
    Key? key,
  }) : super(key: key);

  @override
  _NominationsMainState createState() => _NominationsMainState();
}

class _NominationsMainState extends State<NominationsMain> {
  @override
  void initState() {
    context.read<NominationsProvider>().initNominations(context);
    context.read<NominationsProvider>().dobRange(context: context);
    super.initState();
  }

  // ===================== Redesign helpers =====================

  Widget _heroHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1356BF), Color(0xFF5B2EC4), Color(0xFF2CC7E2)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1356BF).withOpacity(0.30),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.how_to_vote_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('File Your Nomination',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 3),
                Text('Complete all sections to submit 🗳️',
                    style: TextStyle(color: Colors.white70, fontSize: 12.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 2, left: 2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFF1356BF).withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF1356BF)),
          ),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2A44))),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xFF1356BF).withOpacity(0.12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // context.read<ScrutinyConstituencyInfoVM>().getStatesList();
    return Consumer<NominationsProvider>(
        builder: (_, model, __) => model.loadingInitData
            ? const Scaffold(body: NetworkLoading())
            : model.showError
                ? Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      title: Text('Nomination',
                          style: theme.textTheme.titleLarge!.copyWith(
                              color: appTheme.indigo800,
                              fontWeight: FontWeight.bold)),
                      elevation: 0,
                      leading: AppbarImage(
                          onTap: () {
                            Get.back();
                          },
                          svgPath: ImageConstant.imgBiarrowleftIndigo800,
                          margin: EdgeInsets.only(
                              left: 20.h, top: 15.v, bottom: 15.v)),
                    ),
                    body: const Center(
                      child: Text("Nomination Not Available"),
                    ))
                : model.nominationStatus == NominationStatus.UNPAID ||
                        model.nominationStatus == NominationStatus.PAID
                    ? ViewNomination()
                    : model.isFirstTimeNomination
                        ? NominationHelpPage()
                        : Scaffold(
                            // backgroundColor: Colors.grey[200],
                            // drawer: HomePageDrawer(),

                            appBar: AppBar(
                              backgroundColor: Colors.white,
                              title: Text('Nomination',
                                  style: theme.textTheme.titleLarge!.copyWith(
                                      color: appTheme.indigo800,
                                      fontWeight: FontWeight.bold)),
                              elevation: 0,
                              leading: AppbarImage(
                                  onTap: () {
                                    Get.back();
                                  },
                                  svgPath:
                                      ImageConstant.imgBiarrowleftIndigo800,
                                  margin: EdgeInsets.only(
                                      left: 20.h, top: 15.v, bottom: 15.v)),
                            ),
                            body: Container(
                              width: double.infinity,
                              height: double.infinity,
                              padding: EdgeInsets.only(
                                  left: mediaQueryData.size.width * 0.05,
                                  right: mediaQueryData.size.width * 0.05),
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                    Color(0xFFF1F4FF),
                                    Color(0xFFF8FAFF)
                                  ])),
                              child: GestureDetector(
                                onTap: () => FocusScope.of(context).unfocus(),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      _heroHeader(),
                                      _sectionHeader(Icons.badge_rounded,
                                          'Personal Details'),
                                      DropDownPickerNSUI(
                                          labelcolor:
                                              theme.textTheme.bodyLarge!.color,
                                          currentValue:
                                              model.selectedCandidateLevel,
                                          listValues: model.candidateLevelList,
                                          onChanged: (val) {
                                            model.changeCandidateLevel(val);
                                          },
                                          labelText: "Level Of Candidate",
                                          icon:
                                              Icons.workspace_premium_outlined,
                                          hintText: "Select Candidate level"),
                                      TextFieldWithLabelNSUI(
                                        labelcolor:
                                            theme.textTheme.bodyLarge!.color,

                                        label: "Full Name",
                                        icon: Icons.person_outline,
                                        hintText: "Full Name",

                                        // focusNode: model.usernameFocus,
                                        // nextFocus: model.lastNameFocus,

                                        // readOnly: model.disableFields,
                                        keyBoardType: TextInputType.name,
                                        controller: model.usernameController,
                                        validation: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter A Valid Name';
                                          }
                                          return null;
                                        },
                                      ),
                                      UploadButtonImageNSUI(
                                        lablecolor:
                                            theme.textTheme.bodyLarge!.color,
                                        buttonTextLabel: model.showProfileImage
                                            ? "Change Photo"
                                            : "Upload Photo",
                                        onTap: (str) {
                                          context
                                              .read<NominationsProvider>()
                                              .pickDocument(
                                                  str,
                                                  model.pickedProfileFilePath,
                                                  upload.DocumentType.amImage);
                                        },
                                        pickedFile: model.pickedProfileFile,
                                        showImage: model.showProfileImage,
                                        labelText: 'Upload Photo',
                                        icon: Icons.add_a_photo_outlined,
                                        onlyCamera: true,
                                      ),

                                      TextFieldWithLabelNSUI(
                                        labelcolor:
                                            theme.textTheme.bodyLarge!.color,
                                        label: "Phone Number",
                                        icon: Icons.phone_outlined,
                                        hintText: "Phone Number",
                                        keyBoardType: TextInputType.phone,
                                        controller: model.mobileController,
                                        readOnly: true,
                                        validation: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter A Valid Mobile';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFieldWithLabelNSUI(
                                        labelcolor:
                                            theme.textTheme.bodyLarge!.color,

                                        label:
                                            "Share Your Social Media Handles",
                                        icon: Icons.link,
                                        hintText:
                                            "Share Your Social Media Handles",

                                        // focusNode: model.emailFocus,
                                        inputAction: TextInputAction.done,
                                        keyBoardType: TextInputType.url,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z0-9:/?&=._\-#%+~]'),
                                          ),
                                        ],
                                        controller: model.socialMediaController,
                                        // validation: (input) =>
                                        //     input.isValidEmail()
                                        //         ? null
                                        //         : "Enter a Valid Email Address",
                                      ),
                                      _sectionHeader(Icons.fingerprint_rounded,
                                          'Identity & Documents'),
                                      TextFieldWithLabelNSUI(
                                        labelcolor:
                                            theme.textTheme.bodyLarge!.color,

                                        label: "Student ID",
                                        icon: Icons.badge_outlined,
                                        hintText: "Student ID",
                                        // focusNode: model.usernameFocus,
                                        // nextFocus: model.lastNameFocus,

                                        // readOnly: model.disableFields,
                                        keyBoardType: TextInputType.name,
                                        controller:
                                            model.studentidNumberController,
                                        validation: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter A Valid Student ID';
                                          }
                                          return null;
                                        },
                                      ),
                                      UploadButtonImageNSUI(
                                        lablecolor:
                                            theme.textTheme.bodyLarge!.color,
                                        buttonTextLabel:
                                            model.showStudentIdImage
                                                ? "Change Student ID Front"
                                                : "Upload Student ID Front",
                                        onTap: (str) {
                                          context
                                              .read<NominationsProvider>()
                                              .pickDocument(
                                                  str,
                                                  model.pickedStudentIDFilePath,
                                                  upload
                                                      .DocumentType.studentid);
                                        },
                                        pickedFile: model.pickedStudentIdFile,
                                        showImage: model.showStudentIdImage,
                                        labelText:
                                            'Upload Student ID Card Front',
                                        icon: Icons.assignment_ind_outlined,
                                      ),
                                      UploadButtonImageNSUI(
                                        lablecolor:
                                            theme.textTheme.bodyLarge!.color,
                                        buttonTextLabel:
                                            model.showStudentIdBackImage
                                                ? "Change Student ID Back"
                                                : "Upload Student ID Back",
                                        onTap: (str) {
                                          context
                                              .read<NominationsProvider>()
                                              .pickDocument(
                                                  str,
                                                  model
                                                      .pickedStudentIDBackFilePath,
                                                  upload.DocumentType
                                                      .evoderidBack);
                                        },
                                        pickedFile:
                                            model.pickedStudentIdBackFile,
                                        showImage: model.showStudentIdBackImage,
                                        labelText:
                                            'Upload Student ID Card Back',
                                        icon: Icons.assignment_ind_outlined,
                                      ),
                                      DropDownPickerNSUI(
                                          labelcolor:
                                              theme.textTheme.bodyLarge!.color,
                                          currentValue: model.selectedIdProof,
                                          listValues: model.idProofList,
                                          onChanged: (val) {
                                            model.changeIdProof(val);
                                          },
                                          labelText: "Select ID Proof",
                                          icon: Icons.verified_user_outlined,
                                          hintText: "Select ID Proof"),
                                      TextFieldWithLabelNSUI(
                                        labelcolor:
                                            theme.textTheme.bodyLarge!.color,
                                        label: "Aadhaar ID Card",
                                        icon: Icons.credit_card_outlined,
                                        hintText: "Aadhaar ID Card",
                                        keyBoardType: TextInputType.name,
                                        controller:
                                            model.idCardNumberController,
                                        validation: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter A Valid Aadhaar Number';
                                          }
                                          return null;
                                        },
                                      ),
                                      UploadButtonImageNSUI(
                                        lablecolor:
                                            theme.textTheme.bodyLarge!.color,
                                        buttonTextLabel: model.showIdImage
                                            ? "Change Aadhaar Card (F)"
                                            : "Upload Aadhaar Card (Front)",
                                        onTap: (str) => context
                                            .read<NominationsProvider>()
                                            .pickDocument(
                                                str,
                                                model.pickedIdProofPath,
                                                upload.DocumentType.idFront),
                                        pickedFile: model.pickedIdFile,
                                        showImage: model.showIdImage,
                                        labelText:
                                            'Upload Aadhaar Card (Front)',
                                        icon: Icons.image_outlined,
                                      ),
                                      UploadButtonImageNSUI(
                                        lablecolor:
                                            theme.textTheme.bodyLarge!.color,
                                        buttonTextLabel:
                                            model.showIdDocumentBack
                                                ? "Change Aadhaar Card (B)"
                                                : "Upload Aadhaar Card (Back)",
                                        onTap: (str) => context
                                            .read<NominationsProvider>()
                                            .pickDocument(
                                                str,
                                                model.pickedIDBackFilePath,
                                                upload.DocumentType.idBack),
                                        pickedFile: model.pickedIdBackFile,
                                        showImage: model.showIdDocumentBack,
                                        labelText: 'Upload Aadhaar Card (Back)',
                                        icon: Icons.collections_outlined,
                                      ),
                                      DatePickerWidgetNSUI(
                                          icon: Icons.cake_outlined,
                                          labelcolor:
                                              theme.textTheme.bodyLarge!.color,
                                          selectedDate: model.selectedDate,
                                          errorText: model.dobError,
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();
                                            // DOB restricted to the membership
                                            // age band (see DobRules): only the
                                            // 16-27 window as on the cut-off
                                            // date is selectable.
                                            final datePick =
                                                await showDatePicker(
                                              context: context,
                                              initialDate:
                                                  DobRules.latestAllowedDob(),
                                              firstDate:
                                                  DobRules.earliestAllowedDob(),
                                              lastDate:
                                                  DobRules.latestAllowedDob(),
                                              builder: (BuildContext? context,
                                                  Widget? child) {
                                                return Theme(
                                                  data:
                                                      ThemeData.dark().copyWith(
                                                    colorScheme:
                                                        ColorScheme.dark(
                                                      primary: Constants
                                                          .themeGradients[1],
                                                      onPrimary: Colors.black87,
                                                      surface: Constants
                                                          .themeGradients[0],
                                                      onSurface: Constants
                                                          .themeGradients[1],
                                                    ),
                                                    dialogBackgroundColor:
                                                        Constants
                                                            .themeGradients[0],
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            );
                                            //await datePicker(context);

                                            if (datePick != null &&
                                                datePick != model.eventDate) {
                                              model.changeDate(datePick);
                                            }
                                          }),

                                      UploadButtonImageNSUI(
                                        lablecolor:
                                            theme.textTheme.bodyLarge!.color,
                                        buttonTextLabel: model.showDobProof
                                            ? "Change DOB Proof "
                                            : "Upload DOB proof ",
                                        onTap: (str) => context
                                            .read<NominationsProvider>()
                                            .pickDocument(
                                                str,
                                                model.pickedDobFilePath,
                                                upload.DocumentType.dob),
                                        pickedFile: model.pickedDobFile,
                                        showImage: model.showDobProof,
                                        labelText: 'Upload DOB Proof',
                                        icon: Icons.event_available_outlined,
                                      ),
                                      _sectionHeader(Icons.school_rounded,
                                          'Academic & Constituency'),
                                      // EducationDropdownNSUI(
                                      //   labelcolor:
                                      //       theme.textTheme.bodyLarge!.color,

                                      //   labelText: "Education",
                                      //   icon: Icons.school_outlined,
                                      //   hintText: "Select highest Education",
                                      //   // viewOnly: model.disableFields,
                                      //   currentValue: model.selectedEducation,
                                      //   onChanged: (val) {
                                      //     model.changeEducation(
                                      //       val,
                                      //     );
                                      //   },
                                      //   listValues:
                                      //       model.educationalDetailsList,
                                      // ),
                                      TextFieldWithLabelNSUI(
                                        labelcolor:
                                            theme.textTheme.bodyLarge!.color,
                                        label: "Course",
                                        icon: Icons.menu_book_outlined,
                                        hintText: "Course",
                                        keyBoardType: TextInputType.text,
                                        controller: model.courseController,
                                        validation: (value) => value.isEmpty
                                            ? "Enter a Course"
                                            : null,
                                      ),
                                      StatePickerDropDownNSUI(
                                        icon: Icons.public,
                                        labelcolor:
                                            theme.textTheme.bodyLarge!.color,

                                        currentState: model.selectedState,
                                        selectedState: model.selectedStateName,
                                        stateList: model.stateList,
                                        // viewOnly: model.enableDistrictEdit,
                                        onTap: () {
                                          //  context.read<RegAssemblyProvider>().refresh();
                                        },
                                        // onChanged: (value) {
                                        // context.read<RegAssemblyProvider>().changeSelectedState(
                                        //     context
                                        //         .read<RegAssemblyProvider>()
                                        //         .stateList!
                                        //         .singleWhere(
                                        //             (element) => element.stateCode == value));
                                        // },
                                      ),
                                      DistrictPickerDropDownNSUI(
                                          icon: Icons.location_city_outlined,
                                          labelcolor:
                                              theme.textTheme.bodyLarge!.color,
                                          currentDistrict:
                                              model.selectedDistrict,
                                          districtList: model.districtList,
                                          selectedConstituency: model
                                                  .selectedDisName ??
                                              "Select District Constituency",
                                          // viewOnly: !val.enableDistrictEdit&&val.disableFields,
                                          onChanged: (value) {
                                            FocusScope.of(context).unfocus();
                                            context
                                                .read<NominationsProvider>()
                                                .changeSelectedDistrict(context
                                                    .read<NominationsProvider>()
                                                    .districtList!
                                                    .singleWhere((element) =>
                                                        element.districtCode ==
                                                        value));
                                          }),
                                      AssemblyPickerDropDownNSUI(
                                          labelcolor:
                                              theme.textTheme.bodyLarge!.color,
                                          title: 'University/College',
                                          icon: Icons.account_balance_outlined,
                                          currentAssembly:
                                              model.selectedAssembly,
                                          assemblyList: model.assemblyList,
                                          // viewOnly: !model.enableDistrictEdit&&model.disableFields,
                                          selectedAssembly:
                                              model.selectedAssemblyName ??
                                                  "Select University/College",
                                          onChanged: (value) {
                                            FocusScope.of(context).unfocus();
                                            context
                                                .read<NominationsProvider>()
                                                .changeSelectedAssembly(context
                                                    .read<NominationsProvider>()
                                                    .assemblyList!
                                                    .singleWhere((element) =>
                                                        element.assemblyCode ==
                                                        value));
                                          }),
                                      // College selection hidden — nomination
                                      // now happens at University/College level
                                      // via the single "University/College"
                                      // dropdown above.
                                      Visibility(
                                          visible: false,
                                          maintainState: true,
                                          child: IndexedStack(
                                            index: model.selectedBooth != null
                                                ? 0
                                                : 1,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    FieldLabelNSUI(
                                                      icon: Icons
                                                          .apartment_outlined,
                                                      label: "College",
                                                      color: theme.textTheme
                                                          .bodyLarge!.color,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.06),
                                                                blurRadius: 12,
                                                                offset:
                                                                    const Offset(
                                                                        0, 4)),
                                                          ]),

                                                      //  Constants
                                                      //     .formItemDecoration,
                                                      constraints: BoxConstraints(
                                                          minHeight:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.065),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 5),
                                                      child: GestureDetector(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              " ${model.selectedBooth?.boothName ?? ""}",
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .keyboard_arrow_down,
                                                              color: theme
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color,
                                                              size: 30,
                                                            )
                                                          ],
                                                        ),
                                                        onTap: context
                                                            .read<
                                                                NominationsProvider>()
                                                            .openDropdown,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              DropDownPickerNSUI(
                                                currentValue: model
                                                    .selectedBooth?.boothCode,
                                                listValues:
                                                    model.boothListDropDown,
                                                // refKey: context
                                                //     .read<NominationsProvider>()
                                                //     .dropdownButtonKey,
                                                onChanged: (value) {
                                                  context
                                                      .read<
                                                          NominationsProvider>()
                                                      .changeBooth(value);
                                                },
                                                labelText: "College",
                                                icon: Icons.apartment_outlined,
                                                labelcolor: theme
                                                    .textTheme.bodyLarge!.color,
                                                hintText: "Select a College",
                                              )
                                            ],
                                          )),
                                      // CommonPickerDropDownNSUI(
                                      //     labelcolor: theme.textTheme.bodyLarge!.color,
                                      //     hinttext: 'Select College',
                                      //     listValues: model.universityList,
                                      //     onTap: () {},
                                      //     selectedValue: model.selecteduniversity,
                                      //     lable: 'College'),
                                      _sectionHeader(Icons.tune_rounded,
                                          'Additional Details'),
                                      UploadButtonVideo(
                                        labelcolor:
                                            theme.textTheme.bodyLarge!.color,
                                        buttonTextLabel: model.showVideoFile
                                            ? "Change video"
                                            : "Upload Video",
                                        onTap: (str) => context
                                            .read<NominationsProvider>()
                                            .saveVideo(str),
                                        pickedFile: model.pickedVideoFile,
                                        showImage: model.showVideoFile,
                                        lable: 'Upload Video',
                                        icon: Icons.videocam_outlined,
                                      ),
                                      TextFieldWithLabelNSUI(
                                        labelcolor:
                                            theme.textTheme.bodyLarge!.color,

                                        label: "Email Id",
                                        icon: Icons.email_outlined,
                                        hintText: "Email Id",

                                        // focusNode: model.emailFocus,
                                        inputAction: TextInputAction.done,
                                        keyBoardType:
                                            TextInputType.emailAddress,
                                        controller: model.emailController,
                                        validation: (input) =>
                                            input.isValidEmail()
                                                ? null
                                                : "Enter a Valid Email Address",
                                      ),
                                      DropDownPickerNSUI(
                                        labelcolor:
                                            theme.textTheme.bodyLarge!.color,

                                        onChanged: (val) {
                                          model.changeGender(val);
                                        },
                                        // viewOnly: model.disableFields,
                                        listValues: model.genders,
                                        labelText: "Gender",
                                        icon: Icons.wc_outlined,
                                        hintText: "Select a gender",
                                        currentValue: model.selectedGender,
                                      ),
                                      DropDownPickerNSUI(
                                          labelcolor:
                                              theme.textTheme.bodyLarge!.color,
                                          currentValue: model.selectedCategory,
                                          listValues: model.categoryList,
                                          // viewOnly: model.disableFields&&!model.enableMediaEdit,
                                          onChanged: (val) {
                                            model.changeCategory(val);
                                          },
                                          labelText: "Category",
                                          icon: Icons.category_outlined,
                                          hintText: "Select Category"),
                                      if (model.isCategoryNeedDocuments ||
                                          model.selectedCategory == 'O')
                                        UploadButtonImageNSUI(
                                          lablecolor:
                                              theme.textTheme.bodyLarge!.color,
                                          buttonTextLabel:
                                              model.showPickedCategoryFile
                                                  ? "Change Category Doc"
                                                  : " Upload Category Document",
                                          onTap: (str) => context
                                              .read<NominationsProvider>()
                                              .pickDocument(
                                                  str,
                                                  model.pickedCategoryFilePath,
                                                  upload.DocumentType.category),
                                          pickedFile: model.pickedCategoryFile,
                                          showImage:
                                              model.showPickedCategoryFile,
                                          labelText: 'Upload Category Document',
                                          icon: Icons.description_outlined,
                                        ),
                                      DropDownPickerNSUI(
                                        labelcolor:
                                            theme.textTheme.bodyLarge!.color,

                                        onChanged: (val) {
                                          model.changeBloodGroup(val);
                                        },
                                        // viewOnly: model.disableFields,
                                        listValues: model.bloodGroups,
                                        labelText: "Blood Group",
                                        icon: Icons.bloodtype_outlined,
                                        hintText: "Select a Blood Group",
                                        currentValue: model.selectedBloodGroup,
                                      ),

                                      DropDownPickerNSUI(
                                        labelcolor:
                                            theme.textTheme.bodyLarge!.color,

                                        onChanged: (val) async {
                                          await model.changeBplSubsidyStatus(
                                              int.parse(
                                                  val == 'Y' ? '1' : '0'));
                                        },
                                        // viewOnly: model.disableFields,
                                        listValues: model.bPLsubsidyYesorNo,
                                        labelText: "BPL Subsidy",
                                        icon: Icons.savings_outlined,
                                        hintText: "BPL Subsidy",
                                        currentValue:
                                            model.bplStatusVal == 1 ? 'Y' : 'N',
                                      ),
                                      if (model.bplStatusVal == 1)
                                        UploadButtonImageNSUI(
                                          lablecolor:
                                              theme.textTheme.bodyLarge!.color,
                                          buttonTextLabel: model.showBplImage
                                              ? "Change BPL Doc"
                                              : "BPL Document",
                                          onTap: (str) => context
                                              .read<NominationsProvider>()
                                              .pickDocument(
                                                  str,
                                                  model.pickedBPLFilePath,
                                                  upload.DocumentType.bpl),
                                          pickedFile: model.pickedBPLFile,
                                          showImage: model.showBplImage,
                                          labelText: 'BPL Document',
                                          icon: Icons.folder_copy_outlined,
                                        ),
                                      DropDownPickerNSUI(
                                        labelcolor:
                                            theme.textTheme.bodyLarge!.color,

                                        onChanged: (val) {
                                          model.changePendingCaseStatus(
                                              val == 'Y' ? true : false);
                                        },
                                        // viewOnly: model.disableFields,
                                        listValues: model.criminalcaseYseorNo,
                                        labelText: "Criminal Case",
                                        icon: Icons.gavel_outlined,
                                        hintText: "Criminal Case",
                                        currentValue:
                                            model.pendingCaseValue ? 'Y' : 'N',
                                      ),
                                      model.pendingCaseValue
                                          ? Row(
                                              children: [
                                                Checkbox(
                                                  activeColor: Colors.orange,
                                                  value: model
                                                      .pendingCaseAttachStatus,
                                                  onChanged: (value) {
                                                    model
                                                        .changePendingCaseAttachStatus(
                                                            value!);
                                                  },
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: const Text(
                                                    'I Have Faced Or Am facing Criminal Cases(S) I Am Attaching '
                                                    'A List Along With Details Of All Criminal Cases(S)'
                                                    'I Have Faced Or Am Am Currently Facing ',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 40, 31, 31),
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      if (model.pendingCaseValue)
                                        UploadButtonImageNSUI(
                                          lablecolor:
                                              theme.textTheme.bodyLarge!.color,
                                          buttonTextLabel:
                                              model.showPickedCaseFile
                                                  ? "Change Case File"
                                                  : "Upload Case File Image",
                                          onTap: (str) => context
                                              .read<NominationsProvider>()
                                              .pickDocument(
                                                  str,
                                                  model.pickedCaseFilePath,
                                                  upload.DocumentType.caseFile),
                                          pickedFile: model.pickedCaseFile,
                                          showImage: model.showPickedCaseFile,
                                          labelText: 'Case File',
                                          icon: Icons.folder_outlined,
                                        ),
                                      //

                                      // RoundedEdgeBox(
                                      //   child: DropDownPicker(
                                      //       currentValue: model.selectedCandidateLevel,
                                      //       listValues: model.candidateLevelList,
                                      //       onChanged: (val) {
                                      //         model.changeCandidateLevel(val);
                                      //       },
                                      //       labelText: "Level Of Candidate",
                                      //       hintText: "Select Candidate level"),
                                      // ),
                                      // RoundedEdgeBox(
                                      //   child: upload.UploadButtonImage(
                                      //     buttonTextLabel: model.showProfileImage
                                      //         ? "Change AM Photo"
                                      //         : "Upload AM Photo",
                                      //     onTap: (str) => context
                                      //         .read<NominationsProvider>()
                                      //         .pickDocument(
                                      //             str,
                                      //             model.pickedProfileFilePath,
                                      //             upload.DocumentType.amImage),
                                      //     pickedFile: model.pickedProfileFile,
                                      //     showImage: model.showProfileImage,
                                      //   ),
                                      // ),
                                      // RoundedEdgeBox(
                                      //     child: Column(
                                      //   children: [
                                      //     TextFieldWithLabel(
                                      //       label: "First Name",
                                      //       hintText: "First Name",
                                      //       // focusNode: model.usernameFocus,
                                      //       // nextFocus: model.lastNameFocus,

                                      //       // readOnly: model.disableFields,
                                      //       keyBoardType: TextInputType.name,
                                      //       controller: model.usernameController,
                                      //       validation: (value) {
                                      //         if (value.isEmpty) {
                                      //           return 'Enter A Valid Name';
                                      //         }
                                      //         return null;
                                      //       },
                                      //     ),
                                      //     TextFieldWithLabel(
                                      //       label: "Last Name",
                                      //       hintText: "Last Name",
                                      //       keyBoardType: TextInputType.name,
                                      //       controller: model.lastNameController,
                                      //       validation: (value) {
                                      //         if (value.isEmpty) {
                                      //           return 'Enter A Valid Name';
                                      //         }
                                      //         return null;
                                      //       },
                                      //     ),
                                      //     TextFieldWithLabel(
                                      //       label: "Guardian Name",
                                      //       hintText: "Guardian Name",
                                      //       keyBoardType: TextInputType.name,
                                      //       controller: model.fatherNameController,
                                      //       validation: (value) {
                                      //         if (value.isEmpty) {
                                      //           return 'Enter A Valid Name';
                                      //         }
                                      //         return null;
                                      //       },
                                      //     ),
                                      //     TextFieldWithLabel(
                                      //       label: "Phone Number",
                                      //       hintText: "Phone Number",
                                      //       keyBoardType: TextInputType.phone,
                                      //       controller: model.mobileController,
                                      //       readOnly: true,
                                      //       validation: (value) {
                                      //         if (value.isEmpty) {
                                      //           return 'Enter A Valid Mobile';
                                      //         }
                                      //         return null;
                                      //       },
                                      //     ),
                                      //     DatePickerWidget(
                                      //         selectedDate:
                                      //             model.selectedDate ?? "DD/MM/YYYY",
                                      //         onTap: () async {
                                      //           FocusScope.of(context).unfocus();
                                      //           print("-------");
                                      //           print(await LocalStorageServices()
                                      //               .getDobEndRange());
                                      //           final datePick = await showDatePicker(
                                      //             context: context,
                                      //             initialDate: new DateTime.utc(
                                      //               int.parse(
                                      //                   await LocalStorageServices()
                                      //                       .getDobEndRange()),
                                      //             ),
                                      //             firstDate: new DateTime(int.parse(
                                      //               await LocalStorageServices()
                                      //                   .getDobStartRange(),
                                      //             )),
                                      //             lastDate: new DateTime(
                                      //                 int.parse(
                                      //                     await LocalStorageServices()
                                      //                         .getDobEndRange()),
                                      //                 12,
                                      //                 31),
                                      //             builder: (BuildContext? context,
                                      //                 Widget? child) {
                                      //               return Theme(
                                      //                 data: ThemeData.dark().copyWith(
                                      //                   colorScheme: ColorScheme.dark(
                                      //                     primary: Constants
                                      //                         .themeGradients[1],
                                      //                     onPrimary: Colors.black87,
                                      //                     surface: Constants
                                      //                         .themeGradients[0],
                                      //                     onSurface: Constants
                                      //                         .themeGradients[1],
                                      //                   ),
                                      //                   dialogBackgroundColor:
                                      //                       Constants.themeGradients[0],
                                      //                 ),
                                      //                 child: child!,
                                      //               );
                                      //             },
                                      //           );
                                      //           //await datePicker(context);

                                      //           if (datePick != null &&
                                      //               datePick != model.eventDate) {
                                      //             model.changeDate(datePick);
                                      //           }
                                      //         }),
                                      //     Container(
                                      //       margin: const EdgeInsets.symmetric(
                                      //           horizontal: 20, vertical: 5),
                                      //       child: Column(
                                      //           crossAxisAlignment:
                                      //               CrossAxisAlignment.start,
                                      //           children: [
                                      //             Text(
                                      //               'Select DOB Proof',
                                      //               style: TextStyle(
                                      //                   color: Colors.grey.shade600,
                                      //                   fontSize: 14),
                                      //             ),
                                      //             Row(
                                      //               children: [
                                      //                 Radio(
                                      //                   value: "10C",
                                      //                   fillColor: MaterialStateColor
                                      //                       .resolveWith((states) =>
                                      //                           Constants
                                      //                               .themeGradientsMain[0]),
                                      //                   groupValue:
                                      //                       model.selectedDobProof,
                                      //                   onChanged: (value) async {
                                      //                     await model
                                      //                         .changeDobProofType(
                                      //                             (value.toString()));
                                      //                   },
                                      //                 ),
                                      //                 Text(
                                      //                   '10th Certificate',
                                      //                   style: TextStyle(
                                      //                       color: Colors.grey.shade600,
                                      //                       fontSize: 14),
                                      //                 ),
                                      //                 Radio(
                                      //                   value: "PP",
                                      //                   fillColor: MaterialStateColor
                                      //                       .resolveWith((states) =>
                                      //                           Constants
                                      //                               .themeGradientsMain[0]),
                                      //                   groupValue:
                                      //                       model.selectedDobProof,
                                      //                   onChanged: (value) async {
                                      //                     await model
                                      //                         .changeDobProofType(
                                      //                             (value.toString()));
                                      //                   },
                                      //                 ),
                                      //                 Text(
                                      //                   'Passport',
                                      //                   style: TextStyle(
                                      //                       color: Colors.grey.shade600,
                                      //                       fontSize: 14),
                                      //                 )
                                      //               ],
                                      //             ),
                                      //             Row(
                                      //               children: [
                                      //                 Radio(
                                      //                   value: "DL",
                                      //                   fillColor: MaterialStateColor
                                      //                       .resolveWith((states) =>
                                      //                           Constants
                                      //                               .themeGradientsMain[0]),
                                      //                   groupValue:
                                      //                       model.selectedDobProof,
                                      //                   onChanged: (value) async {
                                      //                     await model
                                      //                         .changeDobProofType(
                                      //                             (value.toString()));
                                      //                   },
                                      //                 ),
                                      //                 Text(
                                      //                   'Driving licence',
                                      //                   style: TextStyle(
                                      //                       color: Colors.grey.shade600,
                                      //                       fontSize: 14),
                                      //                 ),
                                      //               ],
                                      //             )
                                      //           ]),
                                      //     ),
                                      //     upload.UploadButtonImage(
                                      //       buttonTextLabel: model.showDobProof
                                      //           ? "Change DOB Proof "
                                      //           : "Upload DOB proof ",
                                      //       onTap: (str) => context
                                      //           .read<NominationsProvider>()
                                      //           .pickDocument(
                                      //               str,
                                      //               model.pickedDobFilePath,
                                      //               upload.DocumentType.dob),
                                      //       pickedFile: model.pickedDobFile,
                                      //       showImage: model.showDobProof,
                                      //     ),
                                      //     EducationDropdown(
                                      //       labelText: "Education",
                                      //       hintText: "Select highest Education",
                                      //       // viewOnly: model.disableFields,
                                      //       currentValue: model.selectedEducation,
                                      //       onChanged: (val) {
                                      //         model.changeEducation(
                                      //           val,
                                      //         );
                                      //       },
                                      //       listValues: model.educationalDetailsList,
                                      //     ),
                                      //     StatePickerDropDown(
                                      //       currentState: model.selectedState,
                                      //       selectedState: model.selectedStateName,
                                      //       stateList: model.stateList,
                                      //       // viewOnly: model.enableDistrictEdit,
                                      //       onTap: () {
                                      //         //  context.read<RegAssemblyProvider>().refresh();
                                      //       },
                                      //       // onChanged: (value) {
                                      //       // context.read<RegAssemblyProvider>().changeSelectedState(
                                      //       //     context
                                      //       //         .read<RegAssemblyProvider>()
                                      //       //         .stateList!
                                      //       //         .singleWhere(
                                      //       //             (element) => element.stateCode == value));
                                      //       // },
                                      //     ),
                                      //     DistrictPickerDropDown(
                                      //         currentDistrict: model.selectedDistrict,
                                      //         districtList: model.districtList,
                                      //         selectedConstituency:
                                      //             model.selectedDisName ??
                                      //                 "Select District Constituency",
                                      //         // viewOnly: !val.enableDistrictEdit&&val.disableFields,
                                      //         onChanged: (value) {
                                      //           FocusScope.of(context).unfocus();
                                      //           context
                                      //               .read<NominationsProvider>()
                                      //               .changeSelectedDistrict(context
                                      //                   .read<NominationsProvider>()
                                      //                   .districtList!
                                      //                   .singleWhere((element) =>
                                      //                       element.districtCode ==
                                      //                       value));
                                      //         }),
                                      //     !model.isBlockModel
                                      //         ? AssemblyPickerDropDown(
                                      //             currentAssembly:
                                      //                 model.selectedAssembly,
                                      //             assemblyList: model.assemblyList,
                                      //             // viewOnly: !model.enableDistrictEdit&&model.disableFields,
                                      //             selectedAssembly: model
                                      //                     .selectedAssemblyName ??
                                      //                 "Select Assembly Constituency/Zonal/Block",
                                      //             onChanged: (value) {
                                      //               FocusScope.of(context).unfocus();
                                      //               context
                                      //                   .read<NominationsProvider>()
                                      //                   .changeSelectedAssembly(context
                                      //                       .read<NominationsProvider>()
                                      //                       .assemblyList!
                                      //                       .singleWhere((element) =>
                                      //                           element.assemblyCode ==
                                      //                           value));
                                      //             })
                                      //         : DropDownPicker(
                                      //             currentValue:
                                      //                 model.selectedBlock?.blockCode,
                                      //             listValues: model.blockListDropDown,
                                      //             onChanged: (value) {
                                      //               context
                                      //                   .read<NominationsProvider>()
                                      //                   .changeBlock(value);
                                      //             },
                                      //             labelText: "Block",
                                      //             hintText: "Select a Block",
                                      //             selectedBuilder:
                                      //                 model.blockListDropDown != null
                                      //                     ? (context) => model
                                      //                         .blockListDropDown!
                                      //                         .map<Widget>((e) => Row(
                                      //                               children: [
                                      //                                 Expanded(
                                      //                                   child: Text(
                                      //                                     e.name,
                                      //                                     textAlign:
                                      //                                         TextAlign
                                      //                                             .center,
                                      //                                     overflow:
                                      //                                         TextOverflow
                                      //                                             .visible,
                                      //                                     maxLines: 2,
                                      //                                   ),
                                      //                                 ),
                                      //                               ],
                                      //                             ))
                                      //                         .toList()
                                      //                     : null,
                                      //           ),
                                      //     model.mandalamEnabled
                                      //         ? DropDownPicker(
                                      //             currentValue: model.selectedMandalam,
                                      //             listValues:
                                      //                 model.mandalamListDropDown,
                                      //             onChanged: (value) {
                                      //               context
                                      //                   .read<NominationsProvider>()
                                      //                   .changeMandalam(value);
                                      //             },
                                      //             labelText: "Mandalam/Block",
                                      //             hintText: "Select a Mandalam/Block",
                                      //           )
                                      //         : IndexedStack(
                                      //             index: model.selectedBooth != null
                                      //                 ? 0
                                      //                 : 1,
                                      //             children: [
                                      //               Container(
                                      //                 margin:
                                      //                     const EdgeInsets.symmetric(
                                      //                         horizontal: 20,
                                      //                         vertical: 5),
                                      //                 child: Column(
                                      //                   crossAxisAlignment:
                                      //                       CrossAxisAlignment.start,
                                      //                   children: [
                                      //                     Text(
                                      //                       "Booth",
                                      //                       style: TextStyle(
                                      //                           color: Colors
                                      //                               .grey.shade600,
                                      //                           fontSize: 14),
                                      //                     ),
                                      //                     Container(
                                      //                       decoration: Constants
                                      //                           .formItemDecoration,
                                      //                       constraints: BoxConstraints(
                                      //                           minHeight:
                                      //                               MediaQuery.of(
                                      //                                           context)
                                      //                                       .size
                                      //                                       .height *
                                      //                                   0.08),
                                      //                       padding: const EdgeInsets
                                      //                           .symmetric(
                                      //                           vertical: 10,
                                      //                           horizontal: 5),
                                      //                       child: GestureDetector(
                                      //                         child: Row(
                                      //                           mainAxisAlignment:
                                      //                               MainAxisAlignment
                                      //                                   .spaceBetween,
                                      //                           children: [
                                      //                             Text(
                                      //                                 " ${model.selectedBooth?.boothName ?? ""}"),
                                      //                             const Icon(
                                      //                               Icons
                                      //                                   .keyboard_arrow_down,
                                      //                               color: Colors.grey,
                                      //                             )
                                      //                           ],
                                      //                         ),
                                      //                         onTap: context
                                      //                             .read<
                                      //                                 NominationsProvider>()
                                      //                             .openDropdown,
                                      //                       ),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //               DropDownPicker(
                                      //                 currentValue: model
                                      //                     .selectedBooth?.boothCode,
                                      //                 listValues:
                                      //                     model.boothListDropDown,
                                      //                 refKey: context
                                      //                     .read<NominationsProvider>()
                                      //                     .dropdownButtonKey,
                                      //                 onChanged: (value) {
                                      //                   context
                                      //                       .read<NominationsProvider>()
                                      //                       .changeBooth(value);
                                      //                 },
                                      //                 labelText: "Booth",
                                      //                 hintText: "Select a Booth",
                                      //               )
                                      //             ],
                                      //           ),
                                      //   ],
                                      // )),
                                      // Focus(
                                      //   autofocus: true,
                                      //   child: RoundedEdgeBox(
                                      //     child: Column(children: [
                                      //       Container(
                                      //         margin: const EdgeInsets.symmetric(
                                      //             horizontal: 20, vertical: 5),
                                      //         child: Column(
                                      //             crossAxisAlignment:
                                      //                 CrossAxisAlignment.start,
                                      //             children: [
                                      //               Text(
                                      //                 'Select Id Proof',
                                      //                 style: TextStyle(
                                      //                     color: Colors.grey.shade600,
                                      //                     fontSize: 14),
                                      //               ),
                                      //               Row(
                                      //                 children: [
                                      //                   Radio(
                                      //                     value: "EI",
                                      //                     fillColor: MaterialStateColor
                                      //                         .resolveWith((states) =>
                                      //                             Constants
                                      //                                 .themeGradientsMain[0]),
                                      //                     groupValue:
                                      //                         model.selectedIdType,
                                      //                     onChanged: (value) async {
                                      //                       await model
                                      //                           .changeIdTypeStatus(
                                      //                               (value.toString()));
                                      //                     },
                                      //                   ),
                                      //                   Text(
                                      //                     'Epic Voter ID',
                                      //                     style: TextStyle(
                                      //                         color:
                                      //                             Colors.grey.shade600,
                                      //                         fontSize: 14),
                                      //                   ),

                                      //                 ],
                                      //               ),

                                      //             ]),
                                      //       ),

                                      //       TextFieldWithLabel(
                                      //         label: "ID Card Number",
                                      //         hintText: "ID Card Number",
                                      //         keyBoardType: TextInputType.name,
                                      //         controller: model.idCardNumberController,
                                      //         validation: (value) {
                                      //           if (value.isEmpty) {
                                      //             return 'Enter A Valid ID Card Number';
                                      //           }
                                      //           return null;
                                      //         },
                                      //       ),
                                      //       upload.UploadButtonImage(
                                      //         buttonTextLabel: model.showIdImage
                                      //             ? "Change Id card (F)"
                                      //             : "Upload Id Card (Front)",
                                      //         onTap: (str) => context
                                      //             .read<NominationsProvider>()
                                      //             .pickDocument(
                                      //                 str,
                                      //                 model.pickedIdProofPath,
                                      //                 upload.DocumentType.idFront),
                                      //         pickedFile: model.pickedIdFile,
                                      //         showImage: model.showIdImage,
                                      //       ),
                                      //       upload.UploadButtonImage(
                                      //         buttonTextLabel: model.showIdDocumentBack
                                      //             ? "Change Id card (B)"
                                      //             : "Upload Id Card (Back Side)",
                                      //         onTap: (str) => context
                                      //             .read<NominationsProvider>()
                                      //             .pickDocument(
                                      //                 str,
                                      //                 model.pickedIDBackFilePath,
                                      //                 upload.DocumentType.idBack),
                                      //         pickedFile: model.pickedIdBackFile,
                                      //         showImage: model.showIdDocumentBack,
                                      //       ),

                                      //       upload.UploadButtonVideo(
                                      //         buttonTextLabel: model.showVideoFile
                                      //             ? "Change video"
                                      //             : "Upload Video",
                                      //         onTap: (str) => context
                                      //             .read<NominationsProvider>()
                                      //             .saveVideo(str),
                                      //         pickedFile: model.pickedVideoFile,
                                      //         showImage: model.showVideoFile,
                                      //       ),
                                      //     ]),
                                      //   ),
                                      // ),
                                      // RoundedEdgeBox(
                                      //     child: Column(children: [
                                      //   TextFieldWithLabel(
                                      //     label: "Email Id",
                                      //     hintText: "Email Id",

                                      //     // focusNode: model.emailFocus,
                                      //     inputAction: TextInputAction.done,
                                      //     keyBoardType: TextInputType.emailAddress,
                                      //     controller: model.emailController,
                                      //     validation: (value) {
                                      //       if (value.isEmpty) {
                                      //         return 'Enter A Valid Email Id';
                                      //       }
                                      //       return null;
                                      //     },
                                      //   ),
                                      //   DropDownPicker(
                                      //     onChanged: (val) {
                                      //       model.changeGender(val);
                                      //     },
                                      //     // viewOnly: model.disableFields,
                                      //     listValues: model.genders,
                                      //     labelText: "Gender",
                                      //     hintText: "Select a gender",
                                      //     currentValue: model.selectedGender,
                                      //   ),
                                      //   DropDownPicker(
                                      //     onChanged: (val) {
                                      //       model.changeBloodGroup(val);
                                      //     },
                                      //     // viewOnly: model.disableFields,
                                      //     listValues: model.bloodGroups,
                                      //     labelText: "Blood Group",
                                      //     hintText: "Select a Blood Group",
                                      //     currentValue: model.selectedBloodGroup,
                                      //   ),
                                      //   DropDownPicker(
                                      //       currentValue: model.selectedCategory,
                                      //       listValues: model.categoryList,
                                      //       // viewOnly: model.disableFields&&!model.enableMediaEdit,
                                      //       onChanged: (val) {
                                      //         model.changeCategory(val);
                                      //       },
                                      //       labelText: "Category",
                                      //       hintText: "Select Category"),
                                      //   if (model.isCategoryNeedDocuments ||
                                      //       model.selectedCategory == 'O')
                                      //     upload.UploadButtonImage(
                                      //       buttonTextLabel:
                                      //           model.showPickedCategoryFile
                                      //               ? "Change Category Doc"
                                      //               : " Upload Category Document",
                                      //       onTap: (str) => context
                                      //           .read<NominationsProvider>()
                                      //           .pickDocument(
                                      //               str,
                                      //               model.pickedCategoryFilePath,
                                      //               upload.DocumentType.category),
                                      //       pickedFile: model.pickedCategoryFile,
                                      //       showImage: model.showPickedCategoryFile,
                                      //     ),
                                      //   Container(
                                      //     margin:
                                      //         const EdgeInsets.symmetric(vertical: 5),
                                      //     child: Column(
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.start,
                                      //         children: [
                                      //           Padding(
                                      //             padding: const EdgeInsets.symmetric(
                                      //                 horizontal: 20),
                                      //             child: Column(
                                      //               crossAxisAlignment:
                                      //                   CrossAxisAlignment.start,
                                      //               children: [
                                      //                 Text(
                                      //                   'BPL Subsidy',
                                      //                   style: TextStyle(
                                      //                       color: Colors.grey.shade600,
                                      //                       fontSize: 14),
                                      //                 ),
                                      //                 Row(
                                      //                   children: [
                                      //                     Radio(
                                      //                       value: 1,
                                      //                       fillColor: MaterialStateColor
                                      //                           .resolveWith((states) =>
                                      //                               Constants
                                      //                                   .themeGradientsMain[0]),
                                      //                       groupValue:
                                      //                           model.bplStatusVal,
                                      //                       onChanged: (value) async {
                                      //                         await model
                                      //                             .changeBplSubsidyStatus(
                                      //                                 int.parse(value
                                      //                                     .toString()));
                                      //                       },
                                      //                     ),
                                      //                     Text(
                                      //                       'Yes',
                                      //                       style: TextStyle(
                                      //                           color: Colors
                                      //                               .grey.shade600,
                                      //                           fontSize: 14),
                                      //                     ),
                                      //                     Radio(
                                      //                       value: 0,
                                      //                       fillColor: MaterialStateColor
                                      //                           .resolveWith((states) =>
                                      //                               Constants
                                      //                                   .themeGradientsMain[0]),
                                      //                       groupValue:
                                      //                           model.bplStatusVal,
                                      //                       onChanged: (value) async {
                                      //                         await model
                                      //                             .changeBplSubsidyStatus(
                                      //                                 int.parse(value
                                      //                                     .toString()));
                                      //                       },
                                      //                     ),
                                      //                     Text(
                                      //                       'No',
                                      //                       style: TextStyle(
                                      //                           color: Colors
                                      //                               .grey.shade600,
                                      //                           fontSize: 14),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //           if (model.bplStatusVal == 1)
                                      //             upload.UploadButtonImage(
                                      //               buttonTextLabel: model.showBplImage
                                      //                   ? "Change BPL Doc"
                                      //                   : "BPL Document",
                                      //               onTap: (str) => context
                                      //                   .read<NominationsProvider>()
                                      //                   .pickDocument(
                                      //                       str,
                                      //                       model.pickedBPLFilePath,
                                      //                       upload.DocumentType.bpl),
                                      //               pickedFile: model.pickedBPLFile,
                                      //               showImage: model.showBplImage,
                                      //             ),
                                      //         ]),
                                      //   ),
                                      //   Container(
                                      //     margin: const EdgeInsets.symmetric(
                                      //         horizontal: 20, vertical: 5),
                                      //     child: Column(
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.start,
                                      //         children: [
                                      //           Text(
                                      //             'Criminal case',
                                      //             style: TextStyle(
                                      //                 color: Colors.grey.shade600,
                                      //                 fontSize: 14),
                                      //           ),
                                      //           Row(
                                      //             children: [
                                      //               Checkbox(
                                      //                 value: model.pendingCaseValue,
                                      //                 onChanged: (value) {
                                      //                   model.changePendingCaseStatus(
                                      //                       value!);
                                      //                 },
                                      //               ), //Checkb
                                      //               Text(
                                      //                 'Any Pending Cases',
                                      //                 style: TextStyle(
                                      //                     color: Colors.grey.shade600,
                                      //                     fontSize: 14),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //           model.pendingCaseValue
                                      //               ? Row(
                                      //                   children: [
                                      //                     Checkbox(
                                      //                       value: model
                                      //                           .pendingCaseAttachStatus,
                                      //                       onChanged: (value) {
                                      //                         model
                                      //                             .changePendingCaseAttachStatus(
                                      //                                 value!);
                                      //                       },
                                      //                     ),
                                      //                     Container(
                                      //                       width:
                                      //                           MediaQuery.of(context)
                                      //                                   .size
                                      //                                   .width *
                                      //                               0.7,
                                      //                       child: Text(
                                      //                         'I Have Faced Or Am facing Criminal Cases(S) I Am Attaching '
                                      //                         'A List Along With Details Of All Criminal Cases(S)'
                                      //                         'I Have Faced Or Am Am Currently Facing ',
                                      //                         style: TextStyle(
                                      //                             color: Colors
                                      //                                 .grey.shade600,
                                      //                             fontSize: 14),
                                      //                       ),
                                      //                     ),
                                      //                   ],
                                      //                 )
                                      //               : Container(),
                                      //         ]),
                                      //   ),
                                      //   if (model.pendingCaseValue)
                                      //     upload.UploadButtonImage(
                                      //       buttonTextLabel: model.showPickedCaseFile
                                      //           ? "Change Case File"
                                      //           : "Upload Case File Image",
                                      //       onTap: (str) => context
                                      //           .read<NominationsProvider>()
                                      //           .pickDocument(
                                      //               str,
                                      //               model.pickedCaseFilePath,
                                      //               upload.DocumentType.caseFile),
                                      //       pickedFile: model.pickedCaseFile,
                                      //       showImage: model.showPickedCaseFile,
                                      //     )
                                      // ])),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                      _sectionHeader(
                                          Icons.verified_user_rounded,
                                          'Declaration & Consent'),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text(
                                            //   'Declaration',
                                            //   style: TextStyle(
                                            //       color: Colors.grey.shade600,
                                            //       fontSize: 14),
                                            // ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Checkbox(
                                                  activeColor: Colors.orange,
                                                  value:
                                                      model.declarationStatus,
                                                  onChanged: (value) {
                                                    model
                                                        .changeDeclarationStatus(
                                                            value!);
                                                  },
                                                ), //Checkb
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: const Text(
                                                    'I Am Under 27 years Of Age And Am Eligible To Contest As per the Norms Laid Down By NSUI. If use of private agencies for membership is proved it will result disqualification of my candidature',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 40, 31, 31),
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          model.getNominationAmount(context);
                                        },
                                        child: Container(
                                          height: mediaQueryData.size.height *
                                              0.065,
                                          margin: const EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF1356BF),
                                                Color(0xFF2CC7E2)
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF1356BF)
                                                    .withOpacity(0.35),
                                                blurRadius: 16,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: const Text(
                                            'Apply',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ));
  }
}

class RoundedEdgeBox extends StatelessWidget {
  final Widget child;

  const RoundedEdgeBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 5, top: 5, right: 4, left: 4),
        padding: const EdgeInsets.only(bottom: 5, top: 5, right: 2, left: 2),
        decoration: BoxDecoration(
          color: Constants.themeGradients[1],
          boxShadow: [
            BoxShadow(color: Constants.themeTextGradients[1], spreadRadius: 2),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: child);
  }
}

// AssemblyPickerDropDown(
//     currentAssembly:
//         model.selectedAssembly,
//     assemblyList: model.assemblyList,
//     // viewOnly: !model.enableDistrictEdit&&model.disableFields,
//     selectedAssembly: model
//             .selectedAssemblyName ??
//         "Select Assembly Constituency",
//     onChanged: (value) {
//       FocusScope.of(context).unfocus();
//       context
//           .read<NominationsProvider>()
//           .changeSelectedAssembly(context
//               .read<
//                   NominationsProvider>()
//               .assemblyList!
//               .singleWhere((element) =>
//                   element
//                       .assemblyCode ==
//                   value));
//     }),
