import 'package:flutter/material.dart';
import 'package:iyc/screens/ui/home/campaign/view_campaign_data.dart';
import 'package:iyc/screens/widgets/button/submit.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/overlay/overlay_entry.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/campaign/nyay_guarantee_vm.dart';
import 'package:iyc/view_model/campaign/view_campaign_data_vm.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class NyayGuaranteeCampaign extends StatefulWidget {
  const NyayGuaranteeCampaign(
      {Key? key, required this.campaignId, this.langCode})
      : super(key: key);
  final String campaignId;
  final String? langCode;

  @override
  State<NyayGuaranteeCampaign> createState() => _AddNyayGuaranteeCampaign();
}

class _AddNyayGuaranteeCampaign extends State<NyayGuaranteeCampaign> {
  @override
  void initState() {
    context.read<NyayGuaranteeVM>().idController.addListener(() => context
        .read<NyayGuaranteeVM>()
        .idControllerListner(context.read<NyayGuaranteeVM>().idController));

    context.read<NyayGuaranteeVM>().initVotersList(context, widget.langCode);
    context.read<NyayGuaranteeVM>().mobileFocus.addListener(() {
      bool hasFocus = context.read<NyayGuaranteeVM>().mobileFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    context.read<NyayGuaranteeVM>().campaignCodeFocus.addListener(() {
      bool hasFocus = context.read<NyayGuaranteeVM>().otpCodeFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });

    context.read<NyayGuaranteeVM>().initAddCampaign(context, widget.campaignId);

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
        title: Text("न्याय गारंटी"),
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
          Consumer<NyayGuaranteeVM>(
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
                      context.read<NyayGuaranteeVM>().changeLanguage(context);
                    },
                  )),
        ],
      ),
      body: Consumer<NyayGuaranteeVM>(
        builder: (context, model, __) {
          if (model.isLoading) return NetworkLoading();
          return CustomScrollView(slivers: [
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
                    onChanged: (val) {
                      model.changeGender(val);
                    },
                    viewOnly: false,
                    listValues: model.genders,
                    labelText: model.isEnglish ? "Gender" : " लिंग",
                    hintText: model.isEnglish ? "Gender" : " लिंग",
                    currentValue: model.selectedGender,
                  ),
                  DropDownPicker(
                    currentValue: model.selectedCategory,
                    listValues: model.categoryList,
                    onChanged: (value) {
                      context.read<NyayGuaranteeVM>().changeCategory(value);
                    },
                    labelText: model.isEnglish ? "Category" : "श्रेणी",
                    hintText: model.isEnglish ? "Category" : "श्रेणी",
                  ),
                  DropDownPicker(
                    currentValue: model.stateCode,
                    listValues: model.stateListDropdown,
                    onChanged: (val) {
                      model.changeState(val);
                    },
                    labelText:
                    model.isEnglish ? "State" : "राज्य",
                    hintText:
                    model.isEnglish ? "State" : "राज्य",
                  ),
                  DropDownPicker(
                    currentValue: model.selectedParliamentCode,
                    listValues: model.parliamentDropdown,
                    onChanged: (val) {
                      model.onChangeParliament(val);
                    },
                    labelText:
                    model.isEnglish ? "Parliamentary Constituency" : "लोक सभा",
                    hintText:
                    model.isEnglish ? "Parliamentary Constituency" : "लोक सभा",
                  ),
                  DropDownPicker(
                    currentValue: model.selectedAssemblyId,
                    listValues: model.assemblyDropdown,
                    onChanged: (val) {
                      model.changeAssembly(val);
                    },
                    labelText:
                        model.isEnglish ? "Assembly Constituency" : "विधानसभा",
                    hintText:
                        model.isEnglish ? "Assembly Constituency" : "विधानसभा",
                  ),
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
                                  ? "Select Your Preferred Nyay Guarantee (Yes/ No)"
                                  : "अपने मुख्य न्याय गारंटी का चयन करें (हाँ/नहीं)",
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
                                              .read<NyayGuaranteeVM>()
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
                                            .read<NyayGuaranteeVM>()
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
                      ],
                    ),
                  ),
                  TextFieldWithLabel(
                    label: model.isEnglish ? "Mobile No" : "मोबाइल नंबर",
                    hintText: model.isEnglish ? "Mobile No" : "मोबाइल नंबर",
                    keyBoardType: TextInputType.phone,
                    controller: model.mobileController,
                    maxLength: 10,
                    focusNode: context.read<NyayGuaranteeVM>().mobileFocus,
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
                      width: 180,
                      height: 70,
                      child: Center(
                        child: URoundButton(
                            title: model.isEnglish
                                ? "Get Nyay Code"
                                : "न्याय कोड प्राप्त करें",
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
                  SizedBox(
                    height: 40,
                  ),
                  TextFieldWithLabel(
                    label: model.isEnglish
                        ? "Leader mobile number"
                        : "नेता का मोबाइल नंबर",
                    hintText: model.isEnglish
                        ? "Leader mobile number"
                        : "नेता का मोबाइल नंबर",
                    keyBoardType: TextInputType.text,
                    controller: model.leaderMobileController,
                    maxLength: 10,
                    // focusNode: context.read<NyayGuaranteeVM>().otpCodeFocus,
                    validation: (value) {
                      if (value.isEmpty) {
                        return "Enter Leader mobile number";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                      width: 200,
                      child: SubmitButton(
                          title: model.isEnglish ? "Submit" : "सबमिट करें",
                          onTap: () {
                            if (context
                                .read<NyayGuaranteeVM>()
                                .validateForm(context))
                              context
                                  .read<NyayGuaranteeVM>()
                                  .addCampaign(context);
                          })),
                  SizedBox(
                    height: 50,
                  ),
                  // DropDownPicker(
                  //     currentValue: model.selectedAssemblyId,
                  //     listValues: model.assemblyDropDownList,
                  //     onChanged: (val) {
                  //       model.changeAssembly(val);
                  //     },
                  //     labelText: model.isEnglish ? "Vidhan Sabha" : "विधानसभा",
                  //     hintText: model.isEnglish ? "Vidhan Sabha" : "विधानसभा"),
                  // TextFieldWithLabel(
                  //   label: model.isEnglish
                  //       ? "Village/ Town/ City"
                  //       : "ग्राम/कस्बा/शहर",
                  //   hintText: model.isEnglish
                  //       ? "Village/ Town/ City"
                  //       : "ग्राम/कस्बा/शहर",
                  //   //  keyBoardType: TextInputType.name,
                  //   controller: model.placeController,
                  //   validation: (value) {
                  //     if (value.isEmpty) {
                  //       return "एक ग्राम/कस्बा/शहर दर्ज करें";
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // DropDownPicker(
                  //   currentValue: model.selectedCategory,
                  //   listValues: model.categoryList,
                  //   onChanged: (value) {
                  //     context.read<NyayGuaranteeVM>().changeCategory(value);
                  //   },
                  //   labelText: model.isEnglish ? "Category" : "श्रेणी",
                  //   hintText: model.isEnglish ? "Category" : "श्रेणी",
                  // ),
                  // TextFieldWithLabel(
                  //   label: model.isEnglish ? "Caste" : "जाति",
                  //   hintText: model.isEnglish ? "Caste" : "जाति",
                  //   //   keyBoardType: TextInputType.name,
                  //   controller: model.casteController,
                  //   validation: (value) {
                  //     if (value.isEmpty) {
                  //       return "एक जाति दर्ज करें";
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // TextFieldWithLabel(
                  //   label: model.isEnglish ? "Occupation" : "व्यवसाय",
                  //   hintText: model.isEnglish ? "Occupation" : "व्यवसाय",
                  //   //   keyBoardType: TextInputType.name,
                  //   controller: model.jobController,
                  //   validation: (value) {
                  //     if (value.isEmpty) {
                  //       return "एक व्यवसाय दर्ज करें";
                  //     }
                  //     return null;
                  //   },
                  // ),
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
                  //             context.read<NyayGuaranteeVM>().searchFamilyVoter(
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
          ]);
        },
      ),
    );
  }
}
