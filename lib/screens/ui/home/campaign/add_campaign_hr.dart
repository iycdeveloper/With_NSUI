import 'package:flutter/material.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_button.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/screens/ui/home/campaign/view_campaign_data.dart';
import 'package:iyc/screens/widgets/button/iyc_icon_button.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/overlay/overlay_entry.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/campaign/add_campaign_hr_vm.dart';
import 'package:iyc/view_model/campaign/view_campaign_data_vm.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddCampaignHr extends StatefulWidget {
  const AddCampaignHr({Key? key, required this.campaignId, this.langCode})
      : super(key: key);
  final String campaignId;
  final String? langCode;

  @override
  State<AddCampaignHr> createState() => _AddCampaignHrState();
}

class _AddCampaignHrState extends State<AddCampaignHr> {

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

  @override
  void initState() {
    context.read<AddCampaignHrVM>().idController.addListener(() => context
        .read<AddCampaignHrVM>()
        .idControllerListner(context.read<AddCampaignHrVM>().idController));

    context.read<AddCampaignHrVM>().initVotersList(context, widget.langCode);
    context.read<AddCampaignHrVM>().mobileFocus.addListener(() {
      bool hasFocus = context.read<AddCampaignHrVM>().mobileFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    context.read<AddCampaignHrVM>().campaignCodeFocus.addListener(() {
      bool hasFocus = context.read<AddCampaignHrVM>().otpCodeFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    context.read<AddCampaignHrVM>().refererFocus.addListener(() {
      bool hasFocus = context.read<AddCampaignHrVM>().refererFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    context.read<AddCampaignHrVM>().initAddCampaign(
      context,
      widget.campaignId,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("हरियाणा कांग्रेस संकल्प"),
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
          // TextButton(
          //   child: Text(
          //     "Search",
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   onPressed: () async {
          //     Voter? voter = await toPage(
          //         context,
          //         ChangeNotifierProvider(
          //             create: (context) => SearchVotersListVM(),
          //             child: SearchVotersList()));
          //
          //     if (voter != null)
          //       context.read<AddCampaignHrVM>().updateUserData(voter);
          //   },
          // ),
        ],
      ),
      body: Consumer<AddCampaignHrVM>(
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
                          .read<AddCampaignHrVM>()
                          .changeVoterSearchType(index);
                    },
                  ),
                  if (model.selectedVoterSearchType == 0)
                    DropDownPicker(
                        currentValue: model.selectedParliamentCodeSearch,
                        listValues: model.parliamentDropdownItems,
                        onChanged: (parliament) => context
                            .read<AddCampaignHrVM>()
                            .changeParliament(parliament),
                        labelText: "Select by Parliament Constituency",
                        hintText: "Parliament Constituency"),
                  if (model.selectedVoterSearchType == 0)
                    DropDownPicker(
                        currentValue: model.selectedAssemblyCodeSearch,
                        listValues: model.assemblyDropdownItems,
                        onChanged: (assembly) => context
                            .read<AddCampaignHrVM>()
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
                                    context.read<AddCampaignHrVM>().searchVoter(
                                      context,
                                      str,
                                    );
                                  },
                                  // onSubmitted: (str) {
                                  //   context.read<AddCampaignHrVM>().searchVoter(
                                  //         context,
                                  //         str,
                                  //       );
                                  // },
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
                                            .read<AddCampaignHrVM>()
                                            .clearVoterList();
                                      },
                                    )
                                        : null,
                                    hintText: model.selectedVoterSearchType == 0
                                        ? (model.isEnglish
                                        ? "Search eg: Raj"
                                        : "खोजें उदाहरण: राज")
                                        : "Search eg: CJ102454",
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
                                  .read<AddCampaignHrVM>()
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
                  UploadButtonImage(
                    buttonTextLabel: model.showProfileImage
                        ? "Change Photo"
                        : "Upload Photo",
                    onTap: (str) => model.pickDocument(str, model.pickedProfileFilePath,
                        DocumentType.amImage),
                    pickedFile: model.pickedProfileFile,
                    showImage: model.showProfileImage,
                  ),
                  TextFieldWithLabel(
                    label: "नाम",
                    hintText: "नाम",
                    // keyBoardType: TextInputType.text,
                    controller: model.nameController,
                    validation: (value) {
                      if (value.isEmpty) {
                        return "एक मान्य नाम दर्ज करें";
                      }
                      return null;
                    },
                  ),
                  DropDownPicker(
                    currentValue: model.selectedGender,
                    listValues: model.genders,
                    onChanged: (value) {
                      context.read<AddCampaignHrVM>().changeGender(value);
                    },
                    labelText: "लिंग",
                    hintText: "लिंग",
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
                  DropDownPicker(
                      currentValue: model.selectedAssemblyId,
                      listValues: model.assemblyDropDownList,
                      onChanged: (val) {
                        model.changeAssembly(val);
                      },
                      labelText: "विधानसभा",
                      hintText: "विधानसभा"),
                  TextFieldWithLabel(
                    label: "ग्राम/कस्बा/शहर",
                    hintText: "ग्राम/कस्बा/शहर",
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
                      context.read<AddCampaignHrVM>().changeCategory(value);
                    },
                    labelText: "श्रेणी",
                    hintText: "श्रेणी",
                  ),


                  TextFieldWithLabel(
                    label: "व्यवसाय",
                    hintText: "व्यवसाय",
                    //   keyBoardType: TextInputType.name,
                    controller: model.jobController,
                    validation: (value) {
                      if (value.isEmpty) {
                        return "एक व्यवसाय दर्ज करें";
                      }
                      return null;
                    },
                  ),
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
                                  .read<AddCampaignHrVM>()
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
                : SliverToBoxAdapter(child: SizedBox(),),
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
                              "हरियाणा कांग्रेस संकल्प के लाभ की जानकारी (हां/नहीं)",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 13)),
                        ),
                        ...List.generate(
                          model.inclinationList.length,
                              (index) => ListTile(
                            title: Text(model.inclinationList[index].value),
                            contentPadding: EdgeInsets.zero,
                            trailing: SizedBox(
                              width: 130,
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
                                                (model.inclinationMap[model
                                                    .inclinationList[index]
                                                    .value]!))
                                                ? Colors.lightGreen
                                                : Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "हाँ",
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
                                      print(model.inclinationMap[
                                      model.inclinationList[index].value]);
                                      context
                                          .read<AddCampaignHrVM>()
                                          .changeInclination(
                                          model
                                              .inclinationList[index].value,
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
                                            .inclinationList[index]
                                            .value] !=
                                            null &&
                                            (!model.inclinationMap[model
                                                .inclinationList[index]
                                                .value]!))
                                            ? Colors.redAccent.shade100
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        "नहीं",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: (model.inclinationMap[
                                            model
                                                .inclinationList[
                                            index]
                                                .value] !=
                                                null &&
                                                (!model.inclinationMap[model
                                                    .inclinationList[index]
                                                    .value]!))
                                                ? FontWeight.bold
                                                : null),
                                      ),
                                    ),
                                    onTap: () => context
                                        .read<AddCampaignHrVM>()
                                        .changeInclination(
                                        model.inclinationList[index].value,
                                        model.inclinationMap[model
                                            .inclinationList[index]
                                            .value] ==
                                            null
                                            ? false
                                            : null),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DropDownPicker(
                    currentValue: model.selectedFamilyVoter,
                    listValues: model.familyVoterList,
                    onChanged: (value) {
                      context.read<AddCampaignHrVM>().changeFamilyVoter(value);
                    },
                    labelText: "परिवार के अन्य वोटरों का सत्यापन",
                    hintText: "परिवार के अन्य वोटरों का सत्यापन",
                  ),
                  DropDownPicker(
                    currentValue: model.selectedNeedToAddVoter,
                    listValues: model.needToAddVoterList,
                    onChanged: (value) {
                      context.read<AddCampaignHrVM>().changeNeedToAddVoter(value);
                    },
                    labelText: "क्या परिवार में किसी सदस्य का वोटर लिस्ट में नाम दर्ज करना हैं?",
                    hintText: "क्या परिवार में किसी सदस्य का वोटर लिस्ट में नाम दर्ज करना हैं?",
                  ),
                  TextFieldWithLabel(
                    label: "नागरिक का मोबाइल नंबर",
                    hintText: "नागरिक का मोबाइल नंबर",
                    keyBoardType: TextInputType.phone,
                    controller: model.mobileController,
                    maxLength: 10,
                    focusNode: context.read<AddCampaignHrVM>().mobileFocus,
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
                            title: "संकल्प कोड",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('पारिवारिक रूझान किस राजनीतिक पार्टी की तरफ है?'),
                        Row(
                          children: [
                            SizedBox(width: 16,),
                            Checkbox(
                              value: model.selectedPartyName == 'कांग्रेस',
                              onChanged: (value) {
                                // context
                                //     .read<AddCampaignMpVM>().validateVoterIdAndShowPopUp();
                                context.read<AddCampaignHrVM>().selectParty('कांग्रेस');
                              },
                            ), //Checkb
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                'कांग्रेस',
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 16,),
                            Checkbox(
                              value: model.selectedPartyName == 'भाजपा',
                              onChanged: (value) {
                                // context
                                //     .read<AddCampaignMpVM>().validateVoterIdAndShowPopUp();
                                context.read<AddCampaignHrVM>().selectParty('भाजपा');
                              },
                            ), //Checkb
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                'भाजपा',
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 16,),
                            Checkbox(
                              value: model.selectedPartyName == 'अन्य',
                              onChanged: (value) {
                                // context
                                //     .read<AddCampaignMpVM>().validateVoterIdAndShowPopUp();
                                context.read<AddCampaignHrVM>().selectParty('अन्य');
                              },
                            ), //Checkb
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                'अन्य',
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  TextFieldWithLabel(
                    label: "लीडर मोबाइल नंबर",
                    hintText: "लीडर मोबाइल नंबर",
                    keyBoardType: TextInputType.phone,
                    controller: model.refererMobileController,
                    maxLength: 10,
                    focusNode: context.read<AddCampaignHrVM>().refererFocus,
                    validation: (value) {
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      SizedBox(width: 16,),
                      Checkbox(
                        value: model.checkBoxTicked,
                        onChanged: (value) {
                          // context
                          //     .read<AddCampaignMpVM>().validateVoterIdAndShowPopUp();
                          context.read<AddCampaignHrVM>().changeCheckBox(!model.checkBoxTicked);
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
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                      width: 200,
                      child: IycIconButton(
                          title: "सबमिट करें",
                          onTap: () {
                            if (context
                                .read<AddCampaignHrVM>()
                                .validateForm(context))
                              context
                                  .read<AddCampaignHrVM>()
                                  .addCampaign(context);
                          })),

                  SizedBox(
                    height: 20,
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
