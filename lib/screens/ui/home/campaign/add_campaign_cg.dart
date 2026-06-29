import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/yuva_user/voter.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/screens/ui/home/campaign/view_campaign_data.dart';
import 'package:iyc/screens/ui/home/yuva_booth/search_voters_list.dart';
import 'package:iyc/screens/widgets/button/submit.dart';
import 'package:iyc/screens/widgets/date_picker_widget.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/overlay/overlay_entry.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/campaign/add_campaign_cg_vm.dart';
import 'package:iyc/view_model/campaign/view_campaign_data_vm.dart';
import 'package:iyc/view_model/yuva_booth/search_voters_list_vm.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddCampaignCg extends StatefulWidget {
  const AddCampaignCg({Key? key, required this.campaignId, this.langCode})
      : super(key: key);
  final String campaignId;
  final String? langCode;

  @override
  State<AddCampaignCg> createState() => _AddCampaignCgState();
}

class _AddCampaignCgState extends State<AddCampaignCg> {
  @override
  void initState() {
    context.read<AddCampaignCgVM>().idController.addListener(() => context
        .read<AddCampaignCgVM>()
        .idControllerListner(context.read<AddCampaignCgVM>().idController));

    context.read<AddCampaignCgVM>().initVotersList(context, widget.langCode);
    context.read<AddCampaignCgVM>().mobileFocus.addListener(() {
      bool hasFocus = context.read<AddCampaignCgVM>().mobileFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    context.read<AddCampaignCgVM>().campaignCodeFocus.addListener(() {
      bool hasFocus = context.read<AddCampaignCgVM>().otpCodeFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });

    context.read<AddCampaignCgVM>().initAddCampaign(context, widget.campaignId);

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
        title: Text("छत्तीसगढ़ हितग्राही कार्ड"),
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
          Consumer<AddCampaignCgVM>(
              builder: (context, model, __) => TextButton(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.all(5),
                      child: Text(
                        model.isEnglish ? "HI" : "EN",
                        style: TextStyle(
                            // fontSize: 18,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () async {
                      context.read<AddCampaignCgVM>().changeLanguage(context);
                    },
                  )),
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
                        langCode: context.read<AddCampaignCgVM>().isEnglish
                            ? "EN"
                            : "HI",
                      )));

              if (voter != null)
                context.read<AddCampaignCgVM>().updateUserData(voter);
            },
          ),
        ],
      ),
      body: Consumer<AddCampaignCgVM>(
        builder: (context, model, __) {
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
                          .read<AddCampaignCgVM>()
                          .changeVoterSearchType(index);
                    },
                  ),
                  if (model.selectedVoterSearchType == 0)
                    DropDownPicker(
                        currentValue: model.selectedParliamentCodeSearch,
                        listValues: model.parliamentDropdownItems,
                        onChanged: (parliament) => context
                            .read<AddCampaignCgVM>()
                            .changeParliament(parliament),
                        labelText: "Select by Parliament Constituency",
                        hintText: "Parliament Constituency"),
                  if (model.selectedVoterSearchType == 0)
                    DropDownPicker(
                        currentValue: model.selectedAssemblyCodeSearch,
                        listValues: model.assemblyDropdownItems,
                        onChanged: (assembly) => context
                            .read<AddCampaignCgVM>()
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
                                    context.read<AddCampaignCgVM>().searchVoter(
                                          context,
                                          str,
                                        );
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: model
                                            .filteredVotersList.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(Icons.clear),
                                            color:
                                                Constants.kitThemeGradients[0],
                                            onPressed: () {
                                              model.idController.clear();
                                              context
                                                  .read<AddCampaignCgVM>()
                                                  .clearVoterList();
                                            },
                                          )
                                        : null,
                                    hintText: model.isEnglish
                                        ? (model.selectedVoterSearchType == 0
                                            ? "Search eg: Raj"
                                            : "Search eg: CJ102454")
                                        : (model.selectedVoterSearchType == 0
                                            ? "हिंदी में खोजें जैसे: राज"
                                            : "खोजें जैसे: CJ102454"),
                                  ))),
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
                                        .read<AddCampaignCgVM>()
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
            SliverToBoxAdapter(
              child: Column(
                children: [
                  TextFieldWithLabel(
                    label: model.isEnglish ? "Name" : "नाम",
                    hintText: model.isEnglish ? "Name" : "नाम",
                    // keyBoardType: TextInputType.text,
                    controller: model.nameController,
                    validation: (value) {
                      if (value.isEmpty) {
                        return "एक मान्य नाम दर्ज करें";
                      }
                      return null;
                    },
                  ),
                  DatePickerWidget(
                      selectedDate: model.selectedDate ??
                          (model.isEnglish ? "Date of Birth" : "जन्मतिथि"),
                      labelText: model.isEnglish ? "Date of Birth" : "जन्मतिथि",
                      onTap: () async {
                        final datePick = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.now().subtract(Duration(days: 6570)),
                          firstDate:
                              DateTime.now().subtract(Duration(days: 36500)),
                          // about 18yrs ago
                          lastDate:
                              DateTime.now().subtract(Duration(days: 6570)),

                          builder: (BuildContext? context, Widget? child) {
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
                        if (datePick != null && datePick != model.eventDate) {
                          model.changeDate(datePick);
                        }
                      }),
                  DropDownPicker(
                    onChanged: (val) {
                      model.changeAge(val);
                    },
                    viewOnly: false,
                    listValues: model.ageList,
                    labelText: model.isEnglish ? "Age" : "उम्र",
                    hintText: model.isEnglish ? "Age" : "उम्र",
                    currentValue: model.selectedAge,
                  ),
                  DropDownPicker(
                      currentValue: model.selectedAssemblyId,
                      listValues: model.assemblyDropDownList,
                      onChanged: (val) {
                        model.changeAssembly(val);
                      },
                      labelText: model.isEnglish ? "Vidhan Sabha" : "विधानसभा",
                      hintText: model.isEnglish ? "Vidhan Sabha" : "विधानसभा"),
                  TextFieldWithLabel(
                    label: model.isEnglish
                        ? "Village/ Town/ City"
                        : "ग्राम/कस्बा/शहर",
                    hintText: model.isEnglish
                        ? "Village/ Town/ City"
                        : "ग्राम/कस्बा/शहर",
                    //  keyBoardType: TextInputType.name,
                    controller: model.placeController,
                    validation: (value) {
                      if (value.isEmpty) {
                        return "एक ग्राम/कस्बा/शहर दर्ज करें";
                      }
                      return null;
                    },
                  ),
                  DropDownPicker(
                    currentValue: model.selectedCategory,
                    listValues: model.categoryList,
                    onChanged: (value) {
                      context.read<AddCampaignCgVM>().changeCategory(value);
                    },
                    labelText: model.isEnglish ? "Category" : "श्रेणी",
                    hintText: model.isEnglish ? "Category" : "श्रेणी",
                  ),
                  TextFieldWithLabel(
                    label: model.isEnglish ? "Caste" : "जाति",
                    hintText: model.isEnglish ? "Caste" : "जाति",
                    //   keyBoardType: TextInputType.name,
                    controller: model.casteController,
                    validation: (value) {
                      if (value.isEmpty) {
                        return "एक जाति दर्ज करें";
                      }
                      return null;
                    },
                  ),
                  TextFieldWithLabel(
                    label: model.isEnglish ? "Occupation" : "व्यवसाय",
                    hintText: model.isEnglish ? "Occupation" : "व्यवसाय",
                    //   keyBoardType: TextInputType.name,
                    controller: model.jobController,
                    validation: (value) {
                      if (value.isEmpty) {
                        return "एक व्यवसाय दर्ज करें";
                      }
                      return null;
                    },
                  ),
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
                  //             context.read<AddCampaignCgVM>().searchFamilyVoter(
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
                                                .read<AddCampaignCgVM>()
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

            // DropDownPicker(
            //   onChanged: (val) {},
            //   viewOnly: false,
            //   listValues: [],
            //   labelText: "परिवार के अन्य वोटरों का सत्यापन",
            //   hintText: "अन्य वोटरों का सत्यापन",
            //   currentValue: null,
            // ),
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
                          child: Text(
                              model.isEnglish
                                  ? "Beneficiaries of govt policies (Yes/ No)"
                                  : "सरकारी योजनाओं के लाभ की जानकारी (हाँ/नहीं)",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 14)),
                        ),
                        ...List.generate(
                            model.inclinationList.length,
                            (index) => ListTile(
                                title: Text(model.inclinationList[index].label),
                                contentPadding: EdgeInsets.zero,
                                trailing: SizedBox(
                                  width: 90,
                                  //height: 30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                            width: 40,
                                            decoration: BoxDecoration(
                                                color: (model.inclinationMap[model
                                                                .inclinationList[
                                                                    index]
                                                                .value] !=
                                                            null &&
                                                        (model.inclinationMap[
                                                            model
                                                                .inclinationList[
                                                                    index]
                                                                .value]!))
                                                    ? Colors.lightGreen
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              model.isEnglish ? "YES" : "हाँ",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: (model.inclinationMap[
                                                                  model
                                                                      .inclinationList[
                                                                          index]
                                                                      .value] !=
                                                              null &&
                                                          (model.inclinationMap[
                                                              model
                                                                  .inclinationList[
                                                                      index]
                                                                  .value]!))
                                                      ? FontWeight.bold
                                                      : null),
                                            )),
                                        onTap: () {
                                          print(model.inclinationMap[model
                                              .inclinationList[index].value]);
                                          context
                                              .read<AddCampaignCgVM>()
                                              .changeInclination(
                                                  model.inclinationList[index]
                                                      .value,
                                                  model.inclinationMap[model
                                                              .inclinationList[
                                                                  index]
                                                              .value] ==
                                                          null
                                                      ? true
                                                      : null);
                                        },
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: (model.inclinationMap[model
                                                            .inclinationList[
                                                                index]
                                                            .value] !=
                                                        null &&
                                                    (!model.inclinationMap[model
                                                        .inclinationList[index]
                                                        .value]!))
                                                ? Colors.redAccent.shade100
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            model.isEnglish ? "NO" : "नहीं",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: (model.inclinationMap[
                                                                model
                                                                    .inclinationList[
                                                                        index]
                                                                    .value] !=
                                                            null &&
                                                        (!model.inclinationMap[
                                                            model
                                                                .inclinationList[
                                                                    index]
                                                                .value]!))
                                                    ? FontWeight.bold
                                                    : null),
                                          ),
                                        ),
                                        onTap: () => context
                                            .read<AddCampaignCgVM>()
                                            .changeInclination(
                                                model.inclinationList[index]
                                                    .value,
                                                model.inclinationMap[model
                                                            .inclinationList[
                                                                index]
                                                            .value] ==
                                                        null
                                                    ? false
                                                    : null),
                                      ),
                                    ],
                                  ),
                                ))),
                        // MultiSelectDialogField(
                        //   items: model.inclinationList,
                        //   onConfirm: (values) => context
                        //       .read<AddCampaignCgVM>()
                        //       .changeInclination(values),
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: Theme.of(context).primaryColor),
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   buttonText: Text("लाभ लेने",
                        //       style: Constants.formFieldItemTextStyle
                        //           .copyWith(color: Colors.grey)),
                        //   title: Text("सरकारी योजनाओं के लाभ की जानकारी (हां/नहीं)"),
                        //   buttonIcon: Icon(
                        //     FontAwesomeIcons.angleDown,
                        //     size: 20,
                        //     color: Color(0xff788EA9),
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  // DropDownPicker(
                  //   currentValue: model.selectedParty,
                  //   listValues: model.partyList,
                  //   onChanged: (value) {
                  //     context.read<AddCampaignCgVM>().changeParty(value);
                  //   },
                  //   labelText: "वोटर/परिवार का झुकाव",
                  //   hintText: "वोटर/परिवार का झुकाव",
                  // ),
                  // DropDownPicker(
                  //   currentValue: model.selectedDeclarer,
                  //   listValues: model.declarerList,
                  //   onChanged: (value) {
                  //     context.read<AddCampaignCgVM>().changeDeclare(value);
                  //   },
                  //   labelText: "परिवार के अन्य वोटरों का सत्यापन",
                  //   hintText: "परिवार के अन्य वोटरों का सत्यापन",
                  // ),
                  DropDownPicker(
                    currentValue: model.selectedVoterListOption,
                    listValues: model.voterListOptionList,
                    onChanged: (value) {
                      context
                          .read<AddCampaignCgVM>()
                          .changeVoterListOption(value);
                    },
                    labelText: model.isEnglish
                        ? "Add Family members in the Voter List"
                        : "क्या परिवार में किसी सदस्य का वोटर लिस्ट में नाम दर्ज करना हैं?",
                    hintText: model.isEnglish
                        ? "Add Family members in the Voter List"
                        : "क्या परिवार में किसी सदस्य का वोटर लिस्ट में नाम दर्ज करना हैं?",
                  ),
                  // DropDownPicker(
                  //   currentValue: model.selectedVoterListOption,
                  //   listValues: model.voterListOptionList,
                  //   onChanged: (value) {
                  //     context.read<AddCampaignMpVM>().VoterListOption(value);
                  //   },
                  //   labelText: " वोटर लिस्ट में नाम दर्ज करें?",
                  //   hintText: " वोटर लिस्ट में नाम दर्ज करें",
                  // ),
                  TextFieldWithLabel(
                    label: model.isEnglish ? "Mobile No" : "मोबाइल नंबर",
                    hintText: model.isEnglish ? "Mobile No" : "मोबाइल नंबर",
                    keyBoardType: TextInputType.phone,
                    controller: model.mobileController,
                    maxLength: 10,
                    focusNode: context.read<AddCampaignCgVM>().mobileFocus,
                    validation: (value) {
                      if (value.isEmpty) {
                        return "एक वैध मोबाइल नंबर दर्ज करें";
                      }
                      return null;
                    },
                  ),
                  // TextFieldWithLabel(
                  //   label: model.isEnglish
                  //       ? "Registration No"
                  //       : "रजिस्ट्रेशन नंबर",
                  //   hintText: model.isEnglish
                  //       ? "Registration No"
                  //       : "रजिस्ट्रेशन नंबर",
                  //   keyBoardType: TextInputType.text,
                  //   controller: model.otpCodeController,
                  //   maxLength: 10,
                  //   focusNode: context.read<AddCampaignCgVM>().otpCodeFocus,
                  //   validation: (value) {
                  //     if (value.isEmpty) {
                  //       return "एक वैध मोबाइल नंबर दर्ज करें";
                  //     }
                  //     return null;
                  //   },
                  // ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 180,
                      height: 70,
                      child: Center(
                        child: URoundButton(
                            title: model.isEnglish ? "Registration Code" : "रजिस्ट्रेशन कोड",
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
                          context.read<AddCampaignCgVM>().changeCheckBox(context
                              .read<AddCampaignCgVM>()
                              .validateVoterIdAndShowPopUp(
                                  context, model.isEnglish));
                        },
                      ), //Checkb
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          model.isEnglish
                              ? "Enrol as Booth Member"
                              : 'बूथ सदस्य बनाएं',
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
                  //     context.read<AddCampaignCgVM>().changeRating(rating);
                  //   },
                  // ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                      width: 200,
                      child: SubmitButton(
                          title: model.isEnglish ? "Submit" : "सबमिट करें",
                          onTap: () {
                            if (context
                                .read<AddCampaignCgVM>()
                                .validateForm(context))
                              context
                                  .read<AddCampaignCgVM>()
                                  .addCampaign(context);
                          })),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ]);
        },
      ),
    );
  }
}
