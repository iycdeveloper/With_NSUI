import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/model/api_model/yuva_user/voter.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/screens/ui/home/campaign/view_campaign_data.dart';
import 'package:iyc/screens/ui/home/yuva_booth/search_voters_list.dart';
import 'package:iyc/screens/widgets/button/iyc_icon_button.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/overlay/overlay_entry.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/campaign/add_campaign_mp_vm.dart';
import 'package:iyc/view_model/campaign/view_campaign_data_vm.dart';
import 'package:iyc/view_model/yuva_booth/search_voters_list_vm.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddCampaignMp extends StatefulWidget {
  const AddCampaignMp({
    Key? key,
    required this.campaignId,
    this.langCode,
  }) : super(key: key);
  final String campaignId;
  final String? langCode;

  @override
  State<AddCampaignMp> createState() => _AddCampaignMpState();
}

class _AddCampaignMpState extends State<AddCampaignMp> {
  @override
  void initState() {
    context.read<AddCampaignMpVM>().idController.addListener(() => context
        .read<AddCampaignMpVM>()
        .idControllerListner(context.read<AddCampaignMpVM>().idController));

    context.read<AddCampaignMpVM>().initVotersList(context, widget.langCode);
    context.read<AddCampaignMpVM>().mobileFocus.addListener(() {
      bool hasFocus = context.read<AddCampaignMpVM>().mobileFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    context.read<AddCampaignMpVM>().refererFocus.addListener(() {
      bool hasFocus = context.read<AddCampaignMpVM>().refererFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    context.read<AddCampaignMpVM>().campaignCodeFocus.addListener(() {
      bool hasFocus = context.read<AddCampaignMpVM>().otpCodeFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    context.read<AddCampaignMpVM>().initAddCampaign(
          context,
          widget.campaignId,
        );
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
        title: Text("मध्यप्रदेश समृद्धि कार्ड"),
        centerTitle: true,
        actions: [
          TextButton(
            child: Text(
              "View",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await toPage(
                  context,
                  ChangeNotifierProvider(
                    create: (context) => ViewCampaignDataVM(),
                    child: ViewCampaignData(
                      campaignId: widget.campaignId,
                    ),
                  ));
            },
          ),
          // Consumer<AddCampaignMpVM>(
          //   builder: (context, model, __) {
          //     return model.isShimlaCampaign
          //         ? SizedBox()
          //         : TextButton(
          //             child: Container(
          //               decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   borderRadius: BorderRadius.circular(5)),
          //               padding: EdgeInsets.all(5),
          //               child: Text(
          //                 model.isEnglish ? "KA" : "EN",
          //                 style: TextStyle(
          //                     // fontSize: 18,
          //                     color: Colors.redAccent,
          //                     fontWeight: FontWeight.bold),
          //               ),
          //             ),
          //             onPressed: () async {
          //               context.read<AddCampaignMpVM>().changeLanguage(context);
          //             },
          //           );
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
                context.read<AddCampaignMpVM>().updateUserData(voter);
            },
          ),
        ],
      ),
      body: Consumer<AddCampaignMpVM>(
        builder: (context, model, __) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            child: model.isLoading
                ? NetworkLoading()
                : CustomScrollView(slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ToggleSwitch(
                            minWidth: MediaQuery.of(context).size.width,
                            initialLabelIndex: model.selectedVoterSearchType,
                            cornerRadius: 10.0,
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.grey,
                            inactiveFgColor: Colors.white,
                            totalSwitches: 2,
                            labels: ['NAME', 'EPIC ID'],
                            //  icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
                            activeBgColors: [
                              [Theme.of(context).primaryColor],
                              [Theme.of(context).primaryColor]
                            ],
                            onToggle: (index) {
                              context
                                  .read<AddCampaignMpVM>()
                                  .changeVoterSearchType(index);
                            },
                          ),
                          if (model.selectedVoterSearchType == 0)
                            DropDownPicker(
                                currentValue:
                                    model.selectedParliamentCodeSearch,
                                listValues: model.parliamentDropdownItems,
                                onChanged: (parliament) => context
                                    .read<AddCampaignMpVM>()
                                    .changeParliament(parliament),
                                labelText: "Select by Parliament Constituency",
                                hintText: "Parliament Constituency"),
                          if (model.selectedVoterSearchType == 0)
                            DropDownPicker(
                                currentValue: model.selectedAssemblyCodeSearch,
                                listValues: model.assemblyDropdownItems,
                                onChanged: (assembly) => context
                                    .read<AddCampaignMpVM>()
                                    .changeAssemblySearch(assembly),
                                labelText: "Select by Assembly",
                                hintText: "assembly"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              padding: EdgeInsets.only(right: 5, left: 5),
                              width: MediaQuery.of(context).size.width - 10,
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black54),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextField(
                                    controller: model.idController,
                                    textInputAction: TextInputAction.search,
                                    onSubmitted: (str) {
                                      context
                                          .read<AddCampaignMpVM>()
                                          .searchVoter(
                                            context,
                                            str,
                                          );
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon:
                                          model.filteredVotersList.isNotEmpty
                                              ? IconButton(
                                                  icon: Icon(Icons.clear),
                                                  color: Constants
                                                      .kitThemeGradients[0],
                                                  onPressed: () {
                                                    model.idController.clear();
                                                    context
                                                        .read<AddCampaignMpVM>()
                                                        .clearVoterList();
                                                  },
                                                )
                                              : null,
                                      hintText:
                                          model.selectedVoterSearchType == 0
                                              ? (model.isEnglish
                                                  ? "Search eg: Raj"
                                                  : "खोजें उदाहरण: राज")
                                              : "Search eg: CJ102454",
                                    ),
                                  )),
                                  ElevatedButton(
                                    child: Row(
                                      children: [
                                        Icon(Icons.search, color: Colors.white),
                                        Text("Search")
                                      ],
                                    ),
                                    onPressed: (model.showSearch)
                                        ? () {
                                            context
                                                .read<AddCampaignMpVM>()
                                                .searchVoterByKeyword(
                                                  model.idController.text,
                                                  context,
                                                );
                                          }
                                        : null,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    /// All search related widget are above
                    // model.loadingResult
                    //     ? SliverToBoxAdapter(
                    //         child: Center(child: CircularProgressIndicator()))
                    //     : model.filteredVotersList.length > 0
                    //         ? SliverList(
                    //             delegate: SliverChildBuilderDelegate(
                    //             (context, index) => ListTile(
                    //               title: Text(
                    //                 model.filteredVotersList[index].name,
                    //               ),
                    //               subtitle: Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text(model.filteredVotersList[index].voterId),
                    //                   Text(model.filteredVotersList[index]
                    //                           .fatherOrHusbandName ??
                    //                       ""),
                    //                 ],
                    //               ),
                    //               onTap: () async {
                    //                 await Alert(
                    //                   context: context,
                    //                   onWillPopActive: true,
                    //                   content: Column(
                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                    //                       children: [
                    //                         VoterListInfoLabel(
                    //                           label: "Name",
                    //                           value:
                    //                               model.filteredVotersList[index].name,
                    //                         ),
                    //                         VoterListInfoLabel(
                    //                           label: "Father Name",
                    //                           value: model.filteredVotersList[index]
                    //                               .fatherOrHusbandName,
                    //                         ),
                    //                         VoterListInfoLabel(
                    //                           label: "Voter ID",
                    //                           value: model
                    //                               .filteredVotersList[index].voterId,
                    //                         ),
                    //                         VoterListInfoLabel(
                    //                           label: "Gender",
                    //                           value: model
                    //                               .filteredVotersList[index].gender,
                    //                         ),
                    //                         VoterListInfoLabel(
                    //                           label: "Parliament",
                    //                           value: model.filteredVotersList[index]
                    //                                   .parliament ??
                    //                               "",
                    //                         ),
                    //                         VoterListInfoLabel(
                    //                           label: "Assembly",
                    //                           value: model.filteredVotersList[index]
                    //                                   .assembly ??
                    //                               "",
                    //                         ),
                    //                       ]),
                    //                   buttons: [
                    //                     DialogButton(
                    //                       child: Text(
                    //                         "CANCEL",
                    //                         style: TextStyle(
                    //                             color: Colors.white, fontSize: 20),
                    //                       ),
                    //                       onPressed: () => Navigator.of(context).pop(),
                    //                       width: 120,
                    //                     ),
                    //                     DialogButton(
                    //                       child: Text(
                    //                         "CONFIRM",
                    //                         style: TextStyle(
                    //                             color: Colors.white, fontSize: 20),
                    //                       ),
                    //                       onPressed: () {
                    //                         Navigator.of(context).pop();
                    //                         Navigator.of(context)
                    //                             .pop(model.filteredVotersList[index]);
                    //                       },
                    //                       width: 120,
                    //                     )
                    //                   ],
                    //                 ).show();
                    //                 //   Navigator.of(context).pop(model.voterList[index]);
                    //               },
                    //               trailing:
                    //                   Text(model.filteredVotersList[index].gender),
                    //             ),
                    //             childCount: model.filteredVotersList.length,
                    //           ))
                    //         : SliverToBoxAdapter(
                    //             child: SizedBox(
                    //             height: 400,
                    //             child: Center(
                    //               child: Text(model.idController.text.isEmpty
                    //                   ? "Search Voter by Name or ID "
                    //                   : "no member found"),
                    //             ),
                    //           )),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          TextFieldWithLabel(
                            label: "नाम",
                            hintText: "नाम",
                            controller: model.nameController,
                            validation: (value) {
                              if (value.isEmpty) {
                                return "एक मान्य नाम दर्ज करें";
                              }
                              return null;
                            },
                          ),
                          DropDownPicker(
                            onChanged: (val) {
                              model.changeAge(val);
                            },
                            viewOnly: false,
                            listValues: model.ageList,
                            labelText: "उम्र",
                            hintText: "उम्र",
                            currentValue: model.selectedAge,
                          ),
                          // TextFieldWithLabel(
                          //   label: model.isEnglish
                          //       ? "Father/Husband Name"
                          //       : model.isShimlaCampaign
                          //           ? "पिता/पति का नाम"
                          //           : "ತಂದೆ\ಗಂಡ",
                          //   hintText: model.isEnglish
                          //       ? "Enter Father or Husband Name"
                          //       : model.isShimlaCampaign
                          //           ? "पिता/पति का नाम"
                          //           : "ತಂದೆ ಅಥವಾ ಗಂಡನ ಹೆಸರನ್ನು ನಮೂದಿಸಿ",
                          //   keyBoardType: TextInputType.name,
                          //   controller: model.relativeNameController,
                          //   validation: (value) {
                          //     if (value.isEmpty) {
                          //       return model.isEnglish
                          //           ? 'Enter A Valid Name'
                          //           : model.isShimlaCampaign
                          //               ? "एक मान्य नाम दर्ज करें"
                          //               : "ಮಾನ್ಯವಾದ ಹೆಸರನ್ನು ನಮೂದಿಸಿ";
                          //     }
                          //     return null;
                          //   },
                          // ),
                          DropDownPicker(
                            onChanged: (val) {
                              model.changeGender(val);
                            },
                            viewOnly: false,
                            listValues: model.genders,
                            labelText: "लिंग",
                            hintText: "लिंग",
                            currentValue: model.selectedGender,
                          ),

                          DropDownPicker(
                              currentValue: model.selectedAssemblyId,
                              listValues: model.assemblyDropDownList,
                              onChanged: (val) {
                                model.changeAssembly(val);
                              },
                              labelText: "विधानसभा",
                              hintText: "विधानसभा"),
                          // Container(
                          //   padding: EdgeInsets.only(right: 5, left: 5),
                          //   width: MediaQuery.of(context).size.width - 10,
                          //   margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //           child: Text("परिवार के अन्य वोटरों का सत्यापन")),
                          //       ElevatedButton(
                          //           child: Row(
                          //             children: [
                          //               Icon(Icons.search, color: Colors.white),
                          //               Text("Search")
                          //             ],
                          //           ),
                          //           onPressed: () {
                          //             if (!model.isVoterFamilySearchable) {
                          //               showCustomSnackBar(
                          //                   "Search Voter First", context);
                          //               return;
                          //             }
                          //             context.read<AddCampaignMpVM>().searchFamilyVoter(
                          //                   context,
                          //                   model.familyVoterSearchController.text,
                          //                 );
                          //           })
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    model.loadingFamilyVotersList
                        ? SliverToBoxAdapter(child: NetworkLoading())
                        : model.votersList.isNotEmpty
                            ? SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) => Container(
                                          height: 170,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 5),
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors
                                                      .primaries[5].shade700)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${model.votersList[index].name}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .blue.shade800),
                                                    ),
                                                    Text(
                                                      "${model.votersList[index].voterId}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .blue.shade800),
                                                    ),
                                                    Text(
                                                      "${model.votersList[index].age}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              DropDownPicker(
                                                  currentValue: model
                                                      .votersList[index]
                                                      .selectedFamilyVoterOption,
                                                  listValues: [
                                                    DropdownItem(
                                                        "सत्यापित: घर पे हैं",
                                                        "सत्यापित: घर पे हैं"),
                                                    DropdownItem(
                                                        "सत्यापित: बाहर रहते हैं",
                                                        "सत्यापित: बाहर रहते हैं"),
                                                    DropdownItem("मृत", "मृत"),
                                                    DropdownItem(
                                                        "फर्जी/असत्यापित",
                                                        "फर्जी/असत्यापित"),
                                                  ],
                                                  onChanged: (val) {
                                                    context
                                                        .read<AddCampaignMpVM>()
                                                        .changeVoterListFamilyOption(
                                                            val, index);
                                                  },
                                                  labelText:
                                                      "परिवार के अन्य वोटरों का सत्यापन",
                                                  hintText:
                                                      "परिवार के अन्य वोटरों का सत्यापन")
                                            ],
                                          ),
                                        ),
                                    childCount: model.votersList.length),
                              )
                            : SliverToBoxAdapter(
                                child: SizedBox(),
                              ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Text("लाभ लेने इच्छुक गारंटी",
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14)),
                                ),
                                MultiSelectDialogField(
                                  items: model.inclinationList,
                                  onConfirm: (values) => context
                                      .read<AddCampaignMpVM>()
                                      .changeInclination(values),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  buttonText: Text("कमलनाथ ने क्या 11 वचन दिए हैं...",
                                      style: Constants.formFieldItemTextStyle
                                          .copyWith(color: Colors.grey)),
                                  title: Text("कमलनाथ ने क्या 11 वचन दिए हैं..."),
                                  buttonIcon: FaIcon(
                                    FontAwesomeIcons.angleDown,
                                    size: 20,
                                    color: Color(0xff788EA9),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          DropDownPicker(
                            currentValue: model.selectedParty,
                            listValues: model.partyList,
                            onChanged: (value) {
                              context
                                  .read<AddCampaignMpVM>()
                                  .changeParty(value);
                            },
                            labelText: "वोटर/परिवार का झुकाव",
                            hintText: "वोटर/परिवार का झुकाव",
                          ),
                          // DropDownPicker(
                          //   currentValue: model.selectedVoterListOption,
                          //   listValues: model.voterListOptionList,
                          //   onChanged: (value) {
                          //     context
                          //         .read<AddCampaignMpVM>()
                          //         .VoterListOption(value);
                          //   },
                          //   labelText:
                          //       "क्या परिवार में किसी सदस्य का वोटर लिस्ट में नाम दर्ज करना हैं?",
                          //   hintText:
                          //       "क्या परिवार में किसी सदस्य का वोटर लिस्ट में नाम दर्ज करना हैं?",
                          // ),

                          TextFieldWithLabel(
                            label: "मोबाइल नंबर",
                            hintText: "मोबाइल नंबर",
                            keyBoardType: TextInputType.phone,
                            controller: model.mobileController,
                            maxLength: 10,
                            focusNode:
                                context.read<AddCampaignMpVM>().mobileFocus,
                            validation: (value) {
                              if (value.isEmpty) {
                                return "एक वैध मोबाइल नंबर दर्ज करें";
                              }
                              return null;
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 150,
                              height: 70,
                              child: Center(
                                child: URoundButton(
                                    title: "गारंटी कोड",
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
                          ),
                          if (model.otpSend && !model.otpVerified)
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: Pinput(
                                length: 6,
                                focusNode: model.otpCodeFocus,
                                controller: model.otpCodeController,
                                defaultPinTheme: defaultPinTheme,
                                followingPinTheme: defaultPinTheme,
                                submittedPinTheme: defaultPinTheme,
                                pinAnimationType: PinAnimationType.fade,
                              ),
                            ),

                          TextFieldWithLabel(
                            label: "लीडर मोबाइल नंबर",
                            hintText: "लीडर मोबाइल नंबर",
                            keyBoardType: TextInputType.phone,
                            controller: model.refererMobileController,
                            maxLength: 10,
                            focusNode:
                                context.read<AddCampaignMpVM>().refererFocus,
                            validation: (value) {
                              return null;
                            },
                          ),

                          Row(
                            children: [
                              Checkbox(
                                value: model.checkBoxTicked,
                                onChanged: (value) {
                                  // context
                                  //     .read<AddCampaignMpVM>().validateVoterIdAndShowPopUp();
                                  context
                                      .read<AddCampaignMpVM>()
                                      .changeCheckBox(context
                                          .read<AddCampaignMpVM>()
                                          .validateVoterIdAndShowPopUp(
                                              context));
                                },
                              ), //Checkb
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  'बूथ सदस्य बनाएं',
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          // Container(
                          //     margin: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                          //     alignment: Alignment.centerLeft,
                          //     child: Text(
                          //       "",
                          //       style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          //     )),
                          // RatingBar.builder(
                          //   initialRating: model.rating,
                          //   minRating: 1,
                          //   direction: Axis.horizontal,
                          //   allowHalfRating: true,
                          //   itemCount: 5,
                          //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          //   itemBuilder: (context, _) => Icon(
                          //     Icons.star,
                          //     color: Colors.amber,
                          //   ),
                          //   onRatingUpdate: (rating) {
                          //     context.read<AddCampaignMpVM>().changeRating(rating);
                          //   },
                          // ),
                          SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                              width: 200,
                              child: IycIconButton(
                                  title: "सबमिट करें",
                                  onTap: () {
                                    if (context
                                        .read<AddCampaignMpVM>()
                                        .validateForm(context)) {
                                      context
                                          .read<AddCampaignMpVM>()
                                          .addCampaign(context);
                                    }
                                  })),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ]),
          );
          if (model.isLoading) return NetworkLoading();
          return CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ToggleSwitch(
                    minWidth: MediaQuery.of(context).size.width,
                    initialLabelIndex: model.selectedVoterSearchType,
                    cornerRadius: 10.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: ['NAME', 'EPIC ID'],
                    //  icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
                    activeBgColors: [
                      [Theme.of(context).primaryColor],
                      [Theme.of(context).primaryColor]
                    ],
                    onToggle: (index) {
                      context
                          .read<AddCampaignMpVM>()
                          .changeVoterSearchType(index);
                    },
                  ),
                  if (model.selectedVoterSearchType == 0)
                    DropDownPicker(
                        currentValue: model.selectedParliamentCodeSearch,
                        listValues: model.parliamentDropdownItems,
                        onChanged: (parliament) => context
                            .read<AddCampaignMpVM>()
                            .changeParliament(parliament),
                        labelText: "Select by Parliament Constituency",
                        hintText: "Parliament Constituency"),
                  if (model.selectedVoterSearchType == 0)
                    DropDownPicker(
                        currentValue: model.selectedAssemblyCodeSearch,
                        listValues: model.assemblyDropdownItems,
                        onChanged: (assembly) => context
                            .read<AddCampaignMpVM>()
                            .changeAssemblySearch(assembly),
                        labelText: "Select by Assembly",
                        hintText: "assembly"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      padding: EdgeInsets.only(right: 5, left: 5),
                      width: MediaQuery.of(context).size.width - 10,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: model.idController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (str) {
                              context.read<AddCampaignMpVM>().searchVoter(
                                    context,
                                    str,
                                  );
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                suffixIcon: model.filteredVotersList.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.clear),
                                        color: Constants.kitThemeGradients[0],
                                        onPressed: () {
                                          model.idController.clear();
                                          context
                                              .read<AddCampaignMpVM>()
                                              .clearVoterList();
                                        },
                                      )
                                    : null,
                                hintText: model.selectedVoterSearchType == 0
                                    ? "Search eg: Raj"
                                    : "Search eg: CJ102454"),
                          )),
                          ElevatedButton(
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.white),
                                Text("Search")
                              ],
                            ),
                            onPressed: (model.showSearch)
                                ? () {
                                    context
                                        .read<AddCampaignMpVM>()
                                        .searchVoterByKeyword(
                                          model.idController.text,
                                          context,
                                        );
                                  }
                                : null,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            /// All search related widget are above
            // model.loadingResult
            //     ? SliverToBoxAdapter(
            //         child: Center(child: CircularProgressIndicator()))
            //     : model.filteredVotersList.length > 0
            //         ? SliverList(
            //             delegate: SliverChildBuilderDelegate(
            //             (context, index) => ListTile(
            //               title: Text(
            //                 model.filteredVotersList[index].name,
            //               ),
            //               subtitle: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(model.filteredVotersList[index].voterId),
            //                   Text(model.filteredVotersList[index]
            //                           .fatherOrHusbandName ??
            //                       ""),
            //                 ],
            //               ),
            //               onTap: () async {
            //                 await Alert(
            //                   context: context,
            //                   onWillPopActive: true,
            //                   content: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         VoterListInfoLabel(
            //                           label: "Name",
            //                           value:
            //                               model.filteredVotersList[index].name,
            //                         ),
            //                         VoterListInfoLabel(
            //                           label: "Father Name",
            //                           value: model.filteredVotersList[index]
            //                               .fatherOrHusbandName,
            //                         ),
            //                         VoterListInfoLabel(
            //                           label: "Voter ID",
            //                           value: model
            //                               .filteredVotersList[index].voterId,
            //                         ),
            //                         VoterListInfoLabel(
            //                           label: "Gender",
            //                           value: model
            //                               .filteredVotersList[index].gender,
            //                         ),
            //                         VoterListInfoLabel(
            //                           label: "Parliament",
            //                           value: model.filteredVotersList[index]
            //                                   .parliament ??
            //                               "",
            //                         ),
            //                         VoterListInfoLabel(
            //                           label: "Assembly",
            //                           value: model.filteredVotersList[index]
            //                                   .assembly ??
            //                               "",
            //                         ),
            //                       ]),
            //                   buttons: [
            //                     DialogButton(
            //                       child: Text(
            //                         "CANCEL",
            //                         style: TextStyle(
            //                             color: Colors.white, fontSize: 20),
            //                       ),
            //                       onPressed: () => Navigator.of(context).pop(),
            //                       width: 120,
            //                     ),
            //                     DialogButton(
            //                       child: Text(
            //                         "CONFIRM",
            //                         style: TextStyle(
            //                             color: Colors.white, fontSize: 20),
            //                       ),
            //                       onPressed: () {
            //                         Navigator.of(context).pop();
            //                         Navigator.of(context)
            //                             .pop(model.filteredVotersList[index]);
            //                       },
            //                       width: 120,
            //                     )
            //                   ],
            //                 ).show();
            //                 //   Navigator.of(context).pop(model.voterList[index]);
            //               },
            //               trailing:
            //                   Text(model.filteredVotersList[index].gender),
            //             ),
            //             childCount: model.filteredVotersList.length,
            //           ))
            //         : SliverToBoxAdapter(
            //             child: SizedBox(
            //             height: 400,
            //             child: Center(
            //               child: Text(model.idController.text.isEmpty
            //                   ? "Search Voter by Name or ID "
            //                   : "no member found"),
            //             ),
            //           )),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  TextFieldWithLabel(
                    label: "नाम",
                    hintText: "नाम",
                    controller: model.nameController,
                    validation: (value) {
                      if (value.isEmpty) {
                        return "एक मान्य नाम दर्ज करें";
                      }
                      return null;
                    },
                  ),
                  DropDownPicker(
                    onChanged: (val) {
                      model.changeAge(val);
                    },
                    viewOnly: false,
                    listValues: model.ageList,
                    labelText: "उम्र",
                    hintText: "उम्र",
                    currentValue: model.selectedAge,
                  ),
                  // TextFieldWithLabel(
                  //   label: model.isEnglish
                  //       ? "Father/Husband Name"
                  //       : model.isShimlaCampaign
                  //           ? "पिता/पति का नाम"
                  //           : "ತಂದೆ\ಗಂಡ",
                  //   hintText: model.isEnglish
                  //       ? "Enter Father or Husband Name"
                  //       : model.isShimlaCampaign
                  //           ? "पिता/पति का नाम"
                  //           : "ತಂದೆ ಅಥವಾ ಗಂಡನ ಹೆಸರನ್ನು ನಮೂದಿಸಿ",
                  //   keyBoardType: TextInputType.name,
                  //   controller: model.relativeNameController,
                  //   validation: (value) {
                  //     if (value.isEmpty) {
                  //       return model.isEnglish
                  //           ? 'Enter A Valid Name'
                  //           : model.isShimlaCampaign
                  //               ? "एक मान्य नाम दर्ज करें"
                  //               : "ಮಾನ್ಯವಾದ ಹೆಸರನ್ನು ನಮೂದಿಸಿ";
                  //     }
                  //     return null;
                  //   },
                  // ),
                  DropDownPicker(
                    onChanged: (val) {
                      model.changeGender(val);
                    },
                    viewOnly: false,
                    listValues: model.genders,
                    labelText: "लिंग",
                    hintText: "लिंग",
                    currentValue: model.selectedGender,
                  ),

                  DropDownPicker(
                      currentValue: model.selectedAssemblyId,
                      listValues: model.assemblyDropDownList,
                      onChanged: (val) {
                        model.changeAssembly(val);
                      },
                      labelText: "विधानसभा",
                      hintText: "विधानसभा"),
                  // Container(
                  //   padding: EdgeInsets.only(right: 5, left: 5),
                  //   width: MediaQuery.of(context).size.width - 10,
                  //   margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: Text("परिवार के अन्य वोटरों का सत्यापन")),
                  //       ElevatedButton(
                  //           child: Row(
                  //             children: [
                  //               Icon(Icons.search, color: Colors.white),
                  //               Text("Search")
                  //             ],
                  //           ),
                  //           onPressed: () {
                  //             if (!model.isVoterFamilySearchable) {
                  //               showCustomSnackBar(
                  //                   "Search Voter First", context);
                  //               return;
                  //             }
                  //             context.read<AddCampaignMpVM>().searchFamilyVoter(
                  //                   context,
                  //                   model.familyVoterSearchController.text,
                  //                 );
                  //           })
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            model.loadingFamilyVotersList
                ? SliverToBoxAdapter(child: NetworkLoading())
                : model.votersList.isNotEmpty
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (context, index) => Container(
                                  height: 170,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 5),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.primaries[5].shade700)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${model.votersList[index].name}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade800),
                                            ),
                                            Text(
                                              "${model.votersList[index].voterId}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade800),
                                            ),
                                            Text(
                                              "${model.votersList[index].age}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DropDownPicker(
                                          currentValue: model.votersList[index]
                                              .selectedFamilyVoterOption,
                                          listValues: [
                                            DropdownItem("सत्यापित: घर पे हैं",
                                                "सत्यापित: घर पे हैं"),
                                            DropdownItem(
                                                "सत्यापित: बाहर रहते हैं",
                                                "सत्यापित: बाहर रहते हैं"),
                                            DropdownItem("मृत", "मृत"),
                                            DropdownItem("फर्जी/असत्यापित",
                                                "फर्जी/असत्यापित"),
                                          ],
                                          onChanged: (val) {
                                            context
                                                .read<AddCampaignMpVM>()
                                                .changeVoterListFamilyOption(
                                                    val, index);
                                          },
                                          labelText:
                                              "परिवार के अन्य वोटरों का सत्यापन",
                                          hintText:
                                              "परिवार के अन्य वोटरों का सत्यापन")
                                    ],
                                  ),
                                ),
                            childCount: model.votersList.length),
                      )
                    : SliverToBoxAdapter(
                        child: SizedBox(),
                      ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text("लाभ लेने इच्छुक गारंटी",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 14)),
                        ),
                        MultiSelectDialogField(
                          items: model.inclinationList,
                          onConfirm: (values) => context
                              .read<AddCampaignMpVM>()
                              .changeInclination(values),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          buttonText: Text("लाभ लेने इच्छुक गारंटी",
                              style: Constants.formFieldItemTextStyle
                                  .copyWith(color: Colors.grey)),
                          title: Text("लाभ लेने इच्छुक गारंटी"),
                          buttonIcon: FaIcon(
                            FontAwesomeIcons.angleDown,
                            size: 20,
                            color: Color(0xff788EA9),
                          ),
                        ),
                      ],
                    ),
                  ),

                  DropDownPicker(
                    currentValue: model.selectedParty,
                    listValues: model.partyList,
                    onChanged: (value) {
                      context.read<AddCampaignMpVM>().changeParty(value);
                    },
                    labelText: "वोटर/परिवार का झुकाव",
                    hintText: "वोटर/परिवार का झुकाव",
                  ),
                  // DropDownPicker(
                  //   currentValue: model.selectedVoterListOption,
                  //   listValues: model.voterListOptionList,
                  //   onChanged: (value) {
                  //     context.read<AddCampaignMpVM>().VoterListOption(value);
                  //   },
                  //   labelText:
                  //       "क्या परिवार में किसी सदस्य का वोटर लिस्ट में नाम दर्ज करना हैं?",
                  //   hintText:
                  //       "क्या परिवार में किसी सदस्य का वोटर लिस्ट में नाम दर्ज करना हैं?",
                  // ),

                  TextFieldWithLabel(
                    label: "मोबाइल नंबर",
                    hintText: "मोबाइल नंबर",
                    keyBoardType: TextInputType.phone,
                    controller: model.mobileController,
                    maxLength: 10,
                    focusNode: context.read<AddCampaignMpVM>().mobileFocus,
                    validation: (value) {
                      if (value.isEmpty) {
                        return "एक वैध मोबाइल नंबर दर्ज करें";
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 150,
                      height: 70,
                      child: Center(
                        child: URoundButton(
                            title: "गारंटी कोड",
                            onTap: () async {
                              final isValid =
                                  model.mobileController.text.length == 10;
                              if (!isValid) {
                                return;
                              }
                              model.getOtp(context);
                            }),
                      ),
                    ),
                  ),
                  if (model.otpSend && !model.otpVerified)
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: Pinput(
                        length: 6,
                        focusNode: model.otpCodeFocus,
                        controller: model.otpCodeController,
                        defaultPinTheme: defaultPinTheme,
                        followingPinTheme: defaultPinTheme,
                        submittedPinTheme: defaultPinTheme,
                        pinAnimationType: PinAnimationType.fade,
                      ),
                    ),

                  TextFieldWithLabel(
                    label: "लीडर मोबाइल नंबर",
                    hintText: "लीडर मोबाइल नंबर",
                    keyBoardType: TextInputType.phone,
                    controller: model.refererMobileController,
                    maxLength: 10,
                    focusNode: context.read<AddCampaignMpVM>().refererFocus,
                    validation: (value) {
                      return null;
                    },
                  ),

                  Row(
                    children: [
                      Checkbox(
                        value: model.checkBoxTicked,
                        onChanged: (value) {
                          // context
                          //     .read<AddCampaignMpVM>().validateVoterIdAndShowPopUp();
                          context.read<AddCampaignMpVM>().changeCheckBox(context
                              .read<AddCampaignMpVM>()
                              .validateVoterIdAndShowPopUp(context));
                        },
                      ), //Checkb
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          'बूथ सदस्य बनाएं',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  // Container(
                  //     margin: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       "",
                  //       style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  //     )),
                  // RatingBar.builder(
                  //   initialRating: model.rating,
                  //   minRating: 1,
                  //   direction: Axis.horizontal,
                  //   allowHalfRating: true,
                  //   itemCount: 5,
                  //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  //   itemBuilder: (context, _) => Icon(
                  //     Icons.star,
                  //     color: Colors.amber,
                  //   ),
                  //   onRatingUpdate: (rating) {
                  //     context.read<AddCampaignMpVM>().changeRating(rating);
                  //   },
                  // ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                      width: 200,
                      child: IycIconButton(
                          title: "सबमिट करें",
                          onTap: () {
                            if (context
                                .read<AddCampaignMpVM>()
                                .validateForm(context)) {
                              context
                                  .read<AddCampaignMpVM>()
                                  .addCampaign(context);
                            }
                          })),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ]);
        },
      ),
    );
  }
}
