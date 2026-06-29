import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/model/api_model/yuva_user/voter.dart';
import 'package:iyc/screens/ui/home/campaign/view_campaign_data.dart';
import 'package:iyc/screens/ui/home/yuva_booth/search_voters_list.dart';
import 'package:iyc/screens/widgets/button/iyc_icon_button.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/overlay/overlay_entry.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/campaign/add_campain_tl_vm.dart';
import 'package:iyc/view_model/campaign/view_campaign_data_vm.dart';
import 'package:iyc/view_model/yuva_booth/search_voters_list_vm.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddCampaignTL extends StatefulWidget {
  const AddCampaignTL(
      {Key? key,
      required this.campaignId,
       required this.isShimlaCampaign,
      this.langCode})
      : super(key: key);

  final String campaignId;
  final bool isShimlaCampaign;
  final String? langCode;

  @override
  State<AddCampaignTL> createState() => _AddCampaignTLState();
}

class _AddCampaignTLState extends State<AddCampaignTL> {
  @override
  void initState() {
    context.read<AddCampaignTLVM>().idController.addListener(() => context
        .read<AddCampaignTLVM>()
        .idControllerListner(context.read<AddCampaignTLVM>().idController));

    context.read<AddCampaignTLVM>().initVotersList(context, widget.langCode);
    context.read<AddCampaignTLVM>().mobileFocus.addListener(() {
      bool hasFocus = context.read<AddCampaignTLVM>().mobileFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    context.read<AddCampaignTLVM>().campaignCodeFocus.addListener(() {
      bool hasFocus = context.read<AddCampaignTLVM>().otpCodeFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });

    context.read<AddCampaignTLVM>().initAddCampaign(context, widget.campaignId,
        // isShimlaCampaign: widget.isShimlaCampaign
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
        title: Text("తెలంగాణ డోర్ టు డోర్"),
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
          Consumer<AddCampaignTLVM>(
            builder: (context, model, __) {
              return 
              // model.isShimlaCampaign
                  // ? SizedBox()
                  // : 
                  TextButton(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(5),
                        child: Text(
                          model.isEnglish ? "TL" : "EN",
                          style: TextStyle(
                              // fontSize: 18,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () async {
                        context.read<AddCampaignTLVM>().changeLanguage(context);
                      },
                    );
            },
          ),
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
                      child: SearchVotersList(
                        langCode: context.read<AddCampaignTLVM>().isEnglish
                            ? "EN"
                            : "TL",
                      )));

              if (voter != null)
                context.read<AddCampaignTLVM>().updateUserData(voter);
            },
          ),
        ],
      ),
      body: Consumer<AddCampaignTLVM>(
        builder: (context, model, __) {
          if (model.isLoading)
            return NetworkLoading();
          return CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 10),
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
                          .read<AddCampaignTLVM>()
                          .changeVoterSearchType(index);
                    },
                  ),
                  if (model.selectedVoterSearchType == 0)
                    DropDownPicker(
                        currentValue: model.selectedParliamentCodeSearch,
                        listValues: model.parliamentDropdownItems,
                        onChanged: (parliament) => context
                            .read<AddCampaignTLVM>()
                            .changeParliament(parliament),
                        labelText: "Select by Parliament Constituency",
                        hintText: "Parliament Constituency"),
                  if (model.selectedVoterSearchType == 0)
                    DropDownPicker(
                        currentValue: model.selectedAssemblyCodeSearch,
                        listValues: model.assemblyDropdownItems,
                        onChanged: (assembly) => context
                            .read<AddCampaignTLVM>()
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
                              // onSubmitted: (str) {
                              //   context.read<AddCampaignRjVM>().searchVoter(
                              //         context,
                              //         str,
                              //       );
                              // },
                              onSubmitted: (str) {
                                context.read<AddCampaignTLVM>().searchVoter(
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
                                              .read<AddCampaignTLVM>()
                                              .clearVoterList();
                                        },
                                      )
                                    : null,
                                hintText: model.selectedVoterSearchType == 0
                                    ? (model.isEnglish
                                        ? "Search eg: Raj"
                                        : "శోధన ఉదాహరణ: రాజ్")
                                    : "Search eg: CJ102454",
                              ),
                            ),
                          ),
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
                                        .read<AddCampaignTLVM>()
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
                  ),
                  TextFieldWithLabel(
                    label: model.isEnglish
                        ? "Full Name"
                        : model.isShimlaCampaign
                            ? "पूरा नाम"
                            : "పేరు",
                    hintText: model.isEnglish
                        ? "Enter Full Name"
                        : model.isShimlaCampaign
                            ? "पूरा नाम"
                            : "పేరు",
                    controller: model.nameController,
                    validation: (value) {
                      if (value.isEmpty) {
                        return model.isEnglish
                            ? 'Enter A Valid Name'
                            : model.isShimlaCampaign
                                ? "एक मान्य नाम दर्ज करें"
                                : "ಮಾನ್ಯವಾದ ಹೆಸರನ್ನು ನಮೂದಿಸಿ";
                      }
                      return null;
                    },
                  ),
                  // TextFieldWithLabel(
                  //   label: model.isEnglish ? "EPIC Voter ID" : "ఓటర్ల ID",
                  //   hintText: model.isEnglish ? "Enter Epic Voter ID" : "ఓటర్ల ID",
                  //   keyBoardType: TextInputType.name,
                  //   controller: model.epicIdController,
                  //   validation: (value) {
                  //     if (value.isEmpty) {
                  //       return model.isEnglish ? 'Enter A Valid ID' : "ఓటర్ల ID";
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
                    labelText: model.isEnglish
                        ? "Gender"
                        : model.isShimlaCampaign
                            ? "लिंग"
                            : "లింగము",
                    hintText: model.isEnglish
                        ? "Select a gender"
                        : model.isShimlaCampaign
                            ? "एक लिंग का चयन करें"
                            : "లింగము",
                    currentValue: model.selectedGender,
                  ),
                  DropDownPicker(
                    onChanged: (val) {
                      model.changeAge(val);
                    },
                    viewOnly: false,
                    listValues: model.ageList,
                    labelText: model.isEnglish
                        ? "Age"
                        : model.isShimlaCampaign
                            ? "उम्र"
                            : "వయస్సు",
                    hintText: model.isEnglish
                        ? "Select Age"
                        : model.isShimlaCampaign
                            ? "आयु का चयन करें"
                            : "వయస్సు",
                    currentValue: model.selectedAge,
                  ),
                  DropDownPicker(
                      currentValue: model.selectedAssemblyId,
                      listValues: model.assemblyDropDownList,
                      onChanged: (val) {
                        model.changeAssembly(val);
                      },
                      labelText:
                          model.isEnglish ? "Assembly" : "విధాన సభ అసెంబ్లీ ",
                      hintText:
                          model.isEnglish ? "Assembly" : "విధాన సభ అసెంబ్లీ "),

                  // Container(
                  //   padding: EdgeInsets.only(right: 5, left: 5),
                  //   width: MediaQuery.of(context).size.width - 10,
                  //   margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  //   child: Row(
                  //     children: [
                  //       Expanded(child: Text("परिवार के अन्य वोटरों ?")),
                  //       ElevatedButton(
                  //           child: Row(
                  //             children: [
                  //               Icon(Icons.search, color: Colors.white),
                  //               Text("Search")
                  //             ],
                  //           ),
                  //           onPressed: () {
                  //             if (!model.isVoterFamilySearchable) {
                  //               showCustomSnackBar("Search Voter First", context);
                  //               return;
                  //             }
                  //             context.read<AddCampaignTLVM>().searchFamilyVoter(
                  //                   context,
                  //                   model.familyVoterSearchController.text,
                  //                 );
                  //           })
                  //     ],
                  //   ),
                  // ),
                  DropDownPicker(
                    currentValue: model.selectedCategory,
                    listValues: model.categoryList,
                    onChanged: (value) {
                      context.read<AddCampaignTLVM>().changeCategory(value);
                    },
                    labelText: model.isEnglish ? "Category" : "शవర్గం",
                    hintText: model.isEnglish ? "Category" : "शవర్గం",
                  ),
                  // Container(
                  //   padding: EdgeInsets.only(right: 5, left: 5),
                  //   width: MediaQuery.of(context).size.width - 10,
                  //   margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: Text(model.isEnglish
                  //               ? "Verification of other voters in the Family"
                  //               : "కుటుంబంలోని ఇతర ఓటర్ల ధృవీకరణ")),
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
                  //             context.read<AddCampaignTLVM>().searchFamilyVoter(
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
                                          listValues: model.declarerList,
                                          onChanged: (val) {
                                            context
                                                .read<AddCampaignTLVM>()
                                                .changeVoterListFamilyOption(
                                                    val, index);
                                          },
                                          labelText: model.isEnglish
                                              ? "Verification of other voters in the Family"
                                              : "కుటుంబంలోని ఇతర ఓటర్ల ధృవీకరణ",
                                          hintText: model.isEnglish
                                              ? "Verification of other voters in the Family"
                                              : "కుటుంబంలోని ఇతర ఓటర్ల ధృవీకరణ")
                                    ],
                                  ),
                                ),
                            childCount: model.votersList.length),
                      )
                    : SliverToBoxAdapter(
                        child: SizedBox(),
                      ),

            // DropD
            SliverToBoxAdapter(
              child: Column(children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(model.isEnglish ? " Guarantees" : "హామీలు",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14)),
                      ),
                      model.isShimlaCampaign
                          ? DropDownPicker(
                              onChanged: (val) {
                                model.changeInclination(val);
                              },
                              viewOnly: false,
                              listValues: model.inclinations,
                              labelText:
                                  "शिमला के सुनहरे भविष्य के लिए कांग्रेस के मुख्य संकल्प में से आपके लिए सबसे महत्वपूर्ण कौन सा है? ",
                              hintText: "उत्तर चुनें",
                              currentValue: model.selectedInclination,
                              selectedBuilder: (context) => model.inclinations
                                  .map((e) => Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              e.name,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.clip,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ))
                                  .toList(),
                            )
                          : MultiSelectDialogField(
                              items: model.inclinationList,
                              onConfirm: (values) => context
                   .read<AddCampaignTLVM>()
                   .changeInclination(values),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              buttonText: Text(
                                model.selectedInclinations.isEmpty
                                    ? model.isEnglish
                                        ? "Select a Guarantees"
                                        : "ఒక హామీని ఎంచుకున్నారు"
                                    : model.isEnglish
                                        ? "Selected Guarantees"
                                        : "ఎంచుకున్న హామీలు",
                                style: Constants.formFieldItemTextStyle
                                    .copyWith(color: Colors.grey),
                              ),
                              title: Text(model.isEnglish
                                  ? "Selected a Guarantees"
                                  : "ఒక హామీని ఎంచుకున్నారు"),
                              buttonIcon: Icon(
                                FontAwesomeIcons.angleDown,
                                size: 20,
                                color: Color(0xff788EA9),
                              ),
                            ),
                    ],
                  ),
                  // child: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(bottom: 5.0),
                  //       child: Text(
                  //           // "सरकारी योजनाओं के लाभ की जानकारी (हां/ नहीं), आपको लाभ मिला (✓)",
                  //           model.isEnglish
                  //               ? "Select Guarantees (✓)"
                  //               : "హామీని హామీలు (✓)",
                  //           style: TextStyle(
                  //               color: Colors.grey.shade600, fontSize: 14)),
                  //     ),
                  //     ...List.generate(
                  //       model.inclinationList.length,
                  //       (index) => ListTile(
                  //         title: Text(model.inclinationList[index].label),
                  //         contentPadding: EdgeInsets.zero,
                  //         trailing: SizedBox(
                  //           width: 130,
                  //           // height: 30,
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //             children: [
                  //               Checkbox(
                  //                 value: model.selectedYesOrNo.contains(index),
                  //                 onChanged: (value) {
                  //                   model.onClickCheckBox(index);
                  //                   print(model.inclinationList[index].value);
                  //                 },
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     // MultiSelectDialogField(
                  //     //   items: model.inclinationList,
                  //     //   onConfirm: (values) => context
                  //     //       .read<AddCampaignTLVM>()
                  //     //       .changeInclination(values),
                  //     //   decoration: BoxDecoration(
                  //     //     border: Border.all(color: Theme.of(context).primaryColor),
                  //     //     borderRadius: BorderRadius.circular(8),
                  //     //   ),
                  //     //   buttonText: Text("लाभ लेने",
                  //     //       style: Constants.formFieldItemTextStyle
                  //     //           .copyWith(color: Colors.grey)),
                  //     //   title: Text("सरकारी योजनाओं के लाभ की जानकारी (हां/नहीं)"),
                  //     //   buttonIcon: Icon(
                  //     //     FontAwesomeIcons.angleDown,
                  //     //     size: 20,
                  //     //     color: Color(0xff788EA9),
                  //     //   ),
                  //     // ),
                  //   ],
                  // ),
                ),
                DropDownPicker(
                  currentValue: model.selectedParty,
                  listValues: model.partyList,
                  onChanged: (value) {
                    context.read<AddCampaignTLVM>().changeParty(value);
                  },
                  labelText: model.isEnglish
                      ? "Family Preference To party"
                      : "వోటర్ మద్దతు గల పార్టీ",
                  hintText: model.isEnglish
                      ? "Family Preference To party"
                      : "వోటర్ మద్దతు గల పార్టీ",
                ),
                DropDownPicker(
                  currentValue: model.selectedVoterListOption,
                  listValues: model.voterListOptionList,
                  onChanged: (value) {
                    context.read<AddCampaignTLVM>().VoterListOption(value);
                  },
                  labelText: model.isEnglish
                      ? "Add name to voter list"
                      : "కొత్త వోటర్ లిస్ట్ ను చేర్చు",
                  hintText: model.isEnglish
                      ? "Add name to voter list"
                      : "కొత్త వోటర్ లిస్ట్ ను చేర్చు",
                ),
                TextFieldWithLabel(
                  label: model.isEnglish
                      ? "Phone Number"
                      : model.isShimlaCampaign
                          ? "मोबाइल नंबर"
                          : "ఫోన్ నంబర్",
                  hintText: model.isEnglish
                      ? "Phone Number"
                      : model.isShimlaCampaign
                          ? "मोबाइल नंबर"
                          : "ఫోన్ నంబర్",
                  keyBoardType: TextInputType.phone,
                  controller: model.mobileController,
                  maxLength: 10,
                  focusNode: context.read<AddCampaignTLVM>().mobileFocus,
                  validation: (value) {
                    if (value.isEmpty) {
                      return model.isEnglish
                          ? 'Enter A Valid Mobile'
                          : model.isShimlaCampaign
                              ? "एक वैध मोबाइल नंबर दर्ज करें"
                              : "ఫోన్ నంబర్";
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 170,
                    height: 70,
                    child: Center(
                      child: URoundButton(
                          title: model.isEnglish
                              ? "Verification Code"
                              : "కోడ్ ను నిర్ధారించు",
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
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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

                Row(
                  children: [
                    Checkbox(
                      value: model.checkBoxTicked,
                      onChanged: (value) {
                        context.read<AddCampaignTLVM>().changeCheckBox(context
                            .read<AddCampaignTLVM>()
                            .validateVoterIdAndShowPopUp(
                                context, model.isEnglish));
                      },
                    ), //Checkb
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        model.isEnglish
                            ? "Enrol as Booth Jodo "
                            : 'ఎన్రోల్ భూత్ జోడో మెంబర్ ను జత పరుచు',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),

                SizedBox(
                    width: 200,
                    child: IycIconButton(
                        title: model.isEnglish
                            ? "Submit"
                            : model.isShimlaCampaign
                                ? "प्रस्तुत करना"
                                : "సమర్పించు",
                        onTap: () {
                          if (context
                              .read<AddCampaignTLVM>()
                              .validateForm(context)) {
                            context
                                .read<AddCampaignTLVM>()
                                .addCampaign(context);
                          }
                        })),
                SizedBox(
                  height: 20,
                ),
              ]),
            )
          ]);
        },
      ),
    );
  }
}
