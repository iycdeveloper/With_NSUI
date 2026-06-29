import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/yuva_user/yuva_user.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/overlay/overlay_entry.dart';
import 'package:iyc/view_model/yuva_booth/add_yuva_user_vm.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constants.dart';
import '../../../widgets/textfeild_with_label.dart';
import '../../../widgets/u_round_button.dart';

class AddYuvaUser extends StatefulWidget {
  const AddYuvaUser(
      {required this.yuvaUser,
      Key? key,
      required this.yuvaUserList,
      required this.roleId,
      required this.title})
      : super(key: key);
  final YuvaUser yuvaUser;
  final List<YuvaUser> yuvaUserList;
  final String roleId;
  final String title;

  @override
  State<AddYuvaUser> createState() => _AddYuvaUserState();
}

class _AddYuvaUserState extends State<AddYuvaUser> {
  @override
  void initState() {
    context.read<AddYuvaUserVM>().mobileFocus.addListener(() {
      bool hasFocus = context.read<AddYuvaUserVM>().mobileFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });

    context.read<AddYuvaUserVM>().initAddYuvaUser(
        widget.yuvaUser, widget.yuvaUserList,
        roleId: widget.roleId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      //TODO
      // body: Consumer<AddYuvaUserVM>(
      //   builder: (_, model, __) => model.loadingPage
      //       ? NetworkLoading()
      //       : GestureDetector(
      //           onTap: () => FocusScope.of(context).unfocus(),
      //           child: SingleChildScrollView(
      //             child: Column(
      //               children: [
      //                 // UploadButtonImage(
      //                 //   buttonTextLabel: model.showProfileImage
      //                 //       ? "Change AM Photo"
      //                 //       : "Upload AM Photo",
      //                 //   onTap: (str) => context
      //                 //       .read<AddYuvaUserVM>()
      //                 //       .pickDocument(str, model.pickedProfileFilePath,
      //                 //           DocumentType.amImage),
      //                 //   pickedFile: model.pickedProfileFile,
      //                 //   showImage: model.showProfileImage,
      //                 // ),
      //                 Column(
      //                   children: [
      //                     // TextFieldWithLabel(
      //                     //   label: "First Name",
      //                     //   hintText: "First Name",
      //                     //   // focusNode: model.usernameFocus,
      //                     //   // nextFocus: model.lastNameFocus,
      //                     //
      //                     //   // readOnly: model.disableFields,
      //                     //   keyBoardType: TextInputType.name,
      //                     //   controller: model.usernameController,
      //                     //   validation: (value) {
      //                     //     if (value.isEmpty) {
      //                     //       return 'Enter A Valid Name';
      //                     //     }
      //                     //     return null;
      //                     //   },
      //                     // ),
      //                     // TextFieldWithLabel(
      //                     //   label: "Last Name",
      //                     //   hintText: "Last Name",
      //                     //   keyBoardType: TextInputType.name,
      //                     //   controller: model.lastNameController,
      //                     //   validation: (value) {
      //                     //     if (value.isEmpty) {
      //                     //       return 'Enter A Valid Name';
      //                     //     }
      //                     //     return null;
      //                     //   },
      //                     // ),
      //                     TextFieldWithLabel(
      //                       label: "Phone Number",
      //                       hintText: "Phone Number",
      //                       keyBoardType: TextInputType.phone,
      //                       controller: model.mobileController,
      //                       maxLength: 10,
      //                       focusNode:
      //                           context.read<AddYuvaUserVM>().mobileFocus,
      //                       validation: (value) {
      //                         if (value.isEmpty) {
      //                           return 'Enter A Valid Mobile';
      //                         }
      //                         return null;
      //                       },
      //                     ),
      //                     // TextFieldWithLabel(
      //                     //   label: "Email Id",
      //                     //   hintText: "Email Id",
      //                     //
      //                     //   // focusNode: model.emailFocus,
      //                     //   inputAction: TextInputAction.done,
      //                     //   keyBoardType: TextInputType.emailAddress,
      //                     //   controller: model.emailController,
      //                     //   validation: (value) {
      //                     //     if (value.isEmpty) {
      //                     //       return 'Enter A Valid Email Id';
      //                     //     }
      //                     //     return null;
      //                     //   },
      //                     // ),
      //                     // TextFieldWithLabel(
      //                     //   label: "Voter ID Card Number",
      //                     //   hintText: "Voter ID Card Number",
      //                     //   keyBoardType: TextInputType.name,
      //                     //   controller: model.idCardNumberController,
      //                     //   validation: (value) {
      //                     //     if (value.isEmpty) {
      //                     //       return 'Enter A Valid ID Card Number';
      //                     //     }
      //                     //     return null;
      //                     //   },
      //                     // ),
      //
      //                     Container(
      //                       margin: EdgeInsets.symmetric(
      //                           horizontal: 20, vertical: 5),
      //                       child: Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: [
      //                           Text(
      //                             "State",
      //                             style: TextStyle(
      //                                 color: Colors.grey.shade600,
      //                                 fontSize: 14),
      //                           ),
      //                           Container(
      //                             alignment: Alignment.center,
      //                             decoration: Constants.formItemDecoration,
      //                             child: DropdownSearch<States>(
      //                               popupProps: PopupProps.menu(
      //                                   showSearchBox: true,
      //                                   searchFieldProps: TextFieldProps(
      //                                       decoration: InputDecoration(
      //                                           hintText: "Search State"))),
      //                               // asyncItems: (String filter) =>
      //                               //     model.getDistrictList(),
      //                               items: model.stateList ?? [],
      //                               selectedItem: model.selectedState,
      //                               itemAsString: (States u) => u.name,
      //                               onChanged: (States? data) => context
      //                                   .read<AddYuvaUserVM>()
      //                                   .changeSelectedState(data),
      //                               dropdownButtonProps: DropdownButtonProps(
      //                                 disabledColor: Colors.grey,
      //                               ),
      //                               dropdownDecoratorProps:
      //                                   DropDownDecoratorProps(
      //                                 textAlign: TextAlign.start,
      //                                 dropdownSearchDecoration: InputDecoration(
      //                                     hintText: "Select State",
      //                                     labelText: "",
      //                                     contentPadding:
      //                                         EdgeInsets.only(left: 5)),
      //                               ),
      //                               enabled: int.parse(
      //                                       model.currentYuvaUser.roleId) <
      //                                   2,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                     if (int.parse(model.selectedRoleId!) < 6 &&
      //                         int.parse(model.selectedRoleId!) > 2)
      //                       Container(
      //                         margin: EdgeInsets.symmetric(
      //                             horizontal: 20, vertical: 5),
      //                         child: Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             Text(
      //                               "District",
      //                               style: TextStyle(
      //                                   color: Colors.grey.shade600,
      //                                   fontSize: 14),
      //                             ),
      //                             Container(
      //                               alignment: Alignment.center,
      //                               decoration: Constants.formItemDecoration,
      //                               child: model.selectedRoleId == "5"
      //                                   ? DropdownSearch<Districts>(
      //                                       enabled: model
      //                                               .districtList?.isNotEmpty ??
      //                                           false,
      //                                       items: model.districtList ?? [],
      //                                       popupProps: PopupPropsMultiSelection.menu(
      //                                           showSearchBox: true,
      //                                           searchFieldProps: TextFieldProps(
      //                                               decoration: InputDecoration(
      //                                                   hintText:
      //                                                       "Search Districts by Name"))
      //                                           // disabledItemFn: (Assembly assembly) => assembly.name.startsWith('I'),
      //                                           ),
      //                                       onChanged: (district) => context
      //                                           .read<AddYuvaUserVM>()
      //                                           .changeSelectedDistrict(
      //                                               district),
      //                                       selectedItem:
      //                                           model.selectedDistrict,
      //                                       itemAsString: (Districts u) =>
      //                                           u.name,
      //                                       dropdownDecoratorProps:
      //                                           DropDownDecoratorProps(
      //                                         textAlign: TextAlign.start,
      //                                         dropdownSearchDecoration:
      //                                             InputDecoration(
      //                                                 hintText:
      //                                                     "Select Districts",
      //                                                 labelText: "",
      //                                                 contentPadding:
      //                                                     EdgeInsets.only(
      //                                                         left: 5)),
      //                                       ),
      //                                     )
      //                                   : DropdownSearch<
      //                                       Districts>.multiSelection(
      //                                       enabled: model
      //                                               .districtList?.isNotEmpty ??
      //                                           false,
      //                                       items: model.districtList ?? [],
      //                                       popupProps: PopupPropsMultiSelection.menu(
      //                                           showSearchBox: true,
      //                                           searchFieldProps: TextFieldProps(
      //                                               decoration: InputDecoration(
      //                                                   hintText:
      //                                                       "Search Districts by Name"))
      //                                           // disabledItemFn: (Assembly assembly) => assembly.name.startsWith('I'),
      //                                           ),
      //                                       onChanged: (district) => context
      //                                           .read<AddYuvaUserVM>()
      //                                           .changeSelectedDistrictList(
      //                                               district),
      //                                       selectedItems:
      //                                           model.selectedDistrictList,
      //                                       itemAsString: (Districts u) =>
      //                                           u.name,
      //                                       dropdownDecoratorProps:
      //                                           DropDownDecoratorProps(
      //                                         textAlign: TextAlign.start,
      //                                         dropdownSearchDecoration:
      //                                             InputDecoration(
      //                                                 hintText:
      //                                                     "Select Districts",
      //                                                 labelText: "",
      //                                                 contentPadding:
      //                                                     EdgeInsets.only(
      //                                                         left: 5)),
      //                                       ),
      //                                     ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     //  if(model.selectedRoleId=="5")
      //
      //                     // Container(
      //                     //   margin: EdgeInsets.symmetric(
      //                     //       horizontal: 20, vertical: 5),
      //                     //   padding: EdgeInsets.only(top: 5),
      //                     //   constraints: BoxConstraints(
      //                     //       minHeight:
      //                     //           MediaQuery.of(context).size.height * 0.08),
      //                     //   decoration: Constants.formItemDecoration,
      //                     //   child: Consumer<AddYuvaUserVM>(
      //                     //     builder: (_, model, __) => MultiSelectDialogField(
      //                     //       items: model.multiSelectAssemblyList,
      //                     //       onConfirm: (values) => context
      //                     //           .read<AddYuvaUserVM>()
      //                     //           .changeMultiSelectedAssembly(values),
      //                     //       decoration: BoxDecoration(),
      //                     //       buttonText: Text(
      //                     //           model.selectedMultipleAssemblies.isEmpty
      //                     //               ? "Select Assemblies"
      //                     //               : "Selected Assemblies",
      //                     //           style: Constants.formFieldItemTextStyle
      //                     //               .copyWith(color: Colors.grey)),
      //                     //     ),
      //                     //   ),
      //                     // ),
      //                     if (model.selectedRoleId == "5")
      //                       Container(
      //                         margin: EdgeInsets.symmetric(
      //                             horizontal: 20, vertical: 5),
      //                         child: Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             Text(
      //                               "Assembly",
      //                               style: TextStyle(
      //                                   color: Colors.grey.shade600,
      //                                   fontSize: 14),
      //                             ),
      //                             Container(
      //                               padding: EdgeInsets.only(top: 5),
      //                               constraints: BoxConstraints(
      //                                   minHeight:
      //                                       MediaQuery.of(context).size.height *
      //                                           0.08),
      //                               decoration: Constants.formItemDecoration,
      //                               child:
      //                                   DropdownSearch<Assembly>.multiSelection(
      //                                 enabled: model.assemblyList?.isNotEmpty ??
      //                                     false,
      //                                 items: model.assemblyList ?? [],
      //                                 popupProps: PopupPropsMultiSelection.menu(
      //                                     showSearchBox: true,
      //                                     searchFieldProps: TextFieldProps(
      //                                         decoration: InputDecoration(
      //                                             hintText:
      //                                                 "Search Assemblies Name"))
      //                                     // disabledItemFn: (Assembly assembly) => assembly.name.startsWith('I'),
      //                                     ),
      //                                 onChanged: (assembly) => context
      //                                     .read<AddYuvaUserVM>()
      //                                     .changeSelectedAssemblyList(assembly),
      //                                 selectedItems: model.selectedAssemblyList,
      //                                 itemAsString: (Assembly u) => u.name,
      //                                 dropdownDecoratorProps:
      //                                     DropDownDecoratorProps(
      //                                   textAlign: TextAlign.start,
      //                                   dropdownSearchDecoration:
      //                                       InputDecoration(
      //                                           hintText: "Select Assemblies",
      //                                           labelText: "",
      //                                           contentPadding:
      //                                               EdgeInsets.only(left: 5)),
      //                                 ),
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //
      //                     // AssemblyPickerDropDown(
      //                     //     currentAssembly: model.selectedAssembly,
      //                     //     assemblyList: model.assemblyList,
      //                     //     // viewOnly: !model.enableDistrictEdit&&model.disableFields,
      //                     //     selectedAssembly: model.selectedAssemblyName ??
      //                     //         "Select Assembly Constituency",
      //                     //     onChanged: (value) {
      //                     //       FocusScope.of(context).unfocus();
      //                     //       context
      //                     //           .read<AddYuvaUserVM>()
      //                     //           .changeSelectedAssembly(context
      //                     //               .read<AddYuvaUserVM>()
      //                     //               .assemblyList!
      //                     //               .singleWhere((element) =>
      //                     //                   element.assemblyCode == value));
      //                     //     }),
      //                     if (model.selectedRoleId == "6")
      //                       Container(
      //                         margin: EdgeInsets.symmetric(
      //                             horizontal: 20, vertical: 5),
      //                         padding: EdgeInsets.only(top: 5),
      //                         constraints: BoxConstraints(
      //                             minHeight:
      //                                 MediaQuery.of(context).size.height *
      //                                     0.08),
      //                         decoration: Constants.formItemDecoration,
      //                         child: Consumer<AddYuvaUserVM>(
      //                           builder: (_, model, __) =>
      //                               MultiSelectDialogField(
      //                             items: model.boothList,
      //                             onConfirm: (values) => context
      //                                 .read<AddYuvaUserVM>()
      //                                 .changeSelectedValues(values),
      //                             decoration: BoxDecoration(),
      //                             buttonText: Text(
      //                                 model.selectedBooths.isEmpty
      //                                     ? "Select booths"
      //                                     : "Selected booths",
      //                                 style: Constants.formFieldItemTextStyle
      //                                     .copyWith(color: Colors.grey)),
      //                           ),
      //                         ),
      //                       ),
      //                   ],
      //                 ),
      //                 // SocialHandleInputWidget(
      //                 //   twitterController:
      //                 //       context.read<AddYuvaUserVM>().twitterController,
      //                 //   fbController:
      //                 //       context.read<AddYuvaUserVM>().fbController,
      //                 //   instagramController:
      //                 //       context.read<AddYuvaUserVM>().instagramController,
      //                 // ),
      //                 // if (int.parse(model.currentYuvaUser.roleId) == 6)
      //                 //   Row(
      //                 //     children: [
      //                 //       Checkbox(
      //                 //         value: model.digitalYouthStatus,
      //                 //         onChanged: (value) {
      //                 //           context
      //                 //               .read<AddYuvaUserVM>()
      //                 //               .changeDigitalYouth(value!);
      //                 //         },
      //                 //       ), //Checkb
      //                 //       Container(
      //                 //         width: MediaQuery.of(context).size.width * 0.7,
      //                 //         child: Text(
      //                 //           'Digital Youth User',
      //                 //           style: TextStyle(
      //                 //               color: Colors.grey.shade600, fontSize: 14),
      //                 //         ),
      //                 //       ),
      //                 //     ],
      //                 //   ),
      //                 // if (int.parse(model.currentYuvaUser.roleId) == 5)
      //                 //   Row(
      //                 //     children: [
      //                 //       Checkbox(
      //                 //         value: model.blaStatus,
      //                 //         onChanged: (value) {
      //                 //           context.read<AddYuvaUserVM>().changeBla(value!);
      //                 //         },
      //                 //       ), //Checkb
      //                 //       Container(
      //                 //         width: MediaQuery.of(context).size.width * 0.7,
      //                 //         child: Text(
      //                 //           'BLA',
      //                 //           style: TextStyle(
      //                 //               color: Colors.grey.shade600, fontSize: 14),
      //                 //         ),
      //                 //       ),
      //                 //     ],
      //                 //   ),
      //                 URoundButton(
      //                   title: "Submit",
      //                   onTap: () async {
      //                     context.read<AddYuvaUserVM>().submit(context);
      //                   },
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      // ),
    );
  }
}
