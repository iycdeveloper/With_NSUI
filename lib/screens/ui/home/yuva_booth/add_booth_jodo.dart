import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/model/api_model/yuva_user/yuva_user.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/screens/ui/home/campaign/view_points.dart';
import 'package:iyc/screens/ui/home/yuva_booth/search_voters_list.dart';
import 'package:iyc/screens/widgets/date_picker_widget.dart';
import 'package:iyc/screens/widgets/dropdown/assembly_picker_dropdown.dart';
import 'package:iyc/screens/widgets/dropdown/category_picker.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/overlay/overlay_entry.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/yuva_booth/add_booth_jodo_vm.dart';
import 'package:iyc/view_model/yuva_booth/search_voters_list_vm.dart';
import 'package:iyc/view_model/yuva_booth/view_points_vm.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../../model/api_model/yuva_user/voter.dart';
import '../../../../utils/constants.dart';
import '../../../widgets/button/upload_button.dart';
import '../../../widgets/textfeild_with_label.dart';
import '../../../widgets/u_round_button.dart';

class AddBoothJodo extends StatefulWidget {
  const AddBoothJodo(
      {required this.yuvaUser, Key? key, required this.yuvaUserList})
      : super(key: key);
  final YuvaUser yuvaUser;
  final List<YuvaUser> yuvaUserList;

  @override
  State<AddBoothJodo> createState() => _AddBoothJodoState();
}

class _AddBoothJodoState extends State<AddBoothJodo> {
  @override
  void initState() {
    context.read<AddBoothJodoVM>().mobileFocus.addListener(() {
      bool hasFocus = context.read<AddBoothJodoVM>().mobileFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    context.read<AddBoothJodoVM>().refererFocus.addListener(() {
      bool hasFocus = context.read<AddBoothJodoVM>().refererFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });

    context
        .read<AddBoothJodoVM>()
        .initAddYuvaUser(widget.yuvaUser, widget.yuvaUserList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color.fromRGBO(126, 203, 224, 1),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Booth Jodo"),
        centerTitle: true,
        actions: [
          // TextButton(
          //   child: Text(
          //     "LeaderBoard",
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   onPressed: () async {
          //     await toPage(
          //         context,
          //         ChangeNotifierProvider(
          //             create: (context) => ViewPointsVM(),
          //             child: ViewPoints()));
          //   },
          // ),
          TextButton(
            child: Text(
              "Search",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              Voter? voter = await toPage(
                  context,
                  ChangeNotifierProvider(
                      create: (context) => SearchVotersListVM(),
                      child: SearchVotersList()));

              if (voter != null)
                context.read<AddBoothJodoVM>().updateUserData(voter);
            },
          ),
        ],
      ),
      body: Consumer<AddBoothJodoVM>(
        builder: (_, model, __) => model.loadingPage
            ? NetworkLoading()
            : GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      UploadButtonImage(
                        buttonTextLabel: model.showProfileImage
                            ? "Change User Photo"
                            : "Upload User Photo",
                        onTap: (str) => context
                            .read<AddBoothJodoVM>()
                            .pickDocument(str, model.pickedProfileFilePath,
                                DocumentType.amImage),
                        pickedFile: model.pickedProfileFile,
                        showImage: model.showProfileImage,
                      ),
                      Column(
                        children: [
                          TextFieldWithLabel(
                            label: "First Name",
                            hintText: "First Name",
                            // focusNode: model.usernameFocus,
                            // nextFocus: model.lastNameFocus,

                            // readOnly: model.disableFields,
                            keyBoardType: TextInputType.name,
                            controller: model.firstNameController,
                            validation: (value) {
                              if (value.isEmpty) {
                                return 'Enter A Valid Name';
                              }
                              return null;
                            },
                          ),
                          TextFieldWithLabel(
                            label: "Last Name",
                            hintText: "Last Name",
                            keyBoardType: TextInputType.name,
                            controller: model.lastNameController,
                            validation: (value) {
                              if (value.isEmpty) {
                                return 'Enter A Valid Name';
                              }
                              return null;
                            },
                          ),
                          DropDownPicker(
                            onChanged: (val) {
                              model.changeGender(val);
                            },
                            viewOnly: model.disableFields,
                            listValues: model.genders,
                            labelText: "Gender",
                            hintText: "Select a gender",
                            currentValue: model.selectedGender,
                          ),
                          CategoryPickerWidget(
                            onChanged: (val) {
                              model.changeCategory(val);
                            },
                            viewOnly: model.disableFields,
                            listValues: model.categoryList!,
                            labelText: "Category",
                            hintText: "Select a category",
                            currentValue: model.selectedCategory,
                          ),
                          AssemblyPickerDropDown(
                              title: "Select Assembly",
                              currentAssembly: model.selectedAssembly,
                              assemblyList: model.assemblyList,
                              selectedAssembly:
                              "Select Assembly",
                              onChanged: (value) {
                                model
                                    .changeSelectedAssembly(model
                                    .assemblyList!
                                    .singleWhere((element) =>
                                element.assemblyCode == value));
                              }),
                          DatePickerWidget(
                            selectedDate: model.selectedDate ?? "Select a date",
                            onTap: () async {
                              final datePick = await showDatePicker(
                                context: context,
                                initialDate: new DateTime.utc(
                                  int.parse(await LocalStorageServices()
                                      .getDobEndRange()),
                                ),
                                firstDate: DateTime(1950),
                                lastDate: new DateTime(
                                  int.parse(await LocalStorageServices()
                                      .getDobEndRange()),
                                ),
                                builder:
                                    (BuildContext? context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Constants.themeGradients[1],
                                        onPrimary: Colors.black87,
                                        surface: Constants.themeGradients[0],
                                        onSurface: Constants.themeGradients[1],
                                      ),
                                      dialogBackgroundColor:
                                          Constants.themeGradients[0],
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              //await datePicker(context);
                              print(datePick);
                              if (datePick != null &&
                                  datePick != model.eventDate) {
                                model.changeDate(datePick);
                              }
                            },
                          ),
                          TextFieldWithLabel(
                            label: "Phone Number",
                            hintText: "Phone Number",
                            keyBoardType: TextInputType.phone,
                            controller: model.mobileController,
                            maxLength: 10,
                            focusNode:
                                context.read<AddBoothJodoVM>().mobileFocus,
                            validation: (value) {
                              if (value.isEmpty) {
                                return 'Enter A Valid Mobile';
                              }
                              return null;
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: 80,
                              width: 200,
                              child: URoundButton(
                                  title: "Get Verification Code",
                                  onTap: () async {
                                    final isValid =
                                        model.mobileController.text.length ==
                                            10;
                                    if (!isValid) {
                                      return;
                                    }
                                    model.getOtp(context);
                                  }),
                            ),
                          ),
                          if (model.otpSend && !model.otpVerified)
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text("IYC-")),
                                  Pinput(
                                    length: 6,
                                    focusNode: model.otpCodeFocus,
                                    controller:
                                        model.verificationCodeController,
                                    defaultPinTheme: defaultPinTheme,
                                    followingPinTheme: defaultPinTheme,
                                    submittedPinTheme: defaultPinTheme,
                                    pinAnimationType: PinAnimationType.fade,
                                  ),
                                ],
                              ),
                            ),
                          TextFieldWithLabel(
                            label: "Voter Id Card Number",
                            hintText: "Voter Id Card Number",
                            keyBoardType: TextInputType.name,
                            controller: model.idCardNumberController,
                            validation: (value) {
                              if (value.isEmpty) {
                                return 'Enter A Valid Voter ID Card Number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      TextFieldWithLabel(
                        label: "Referrer Mobile Number (Optional)",
                        hintText: "mobile number",
                        keyBoardType: TextInputType.phone,
                        focusNode: model.refererFocus,
                        // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        maxLength: 10,
                        controller: model.refererController,
                      ),
                      URoundButton(
                        title: "Submit",
                        onTap: () async {
                          context.read<AddBoothJodoVM>().submit(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
