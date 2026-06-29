import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/model/api_model/yuva_user/voter.dart';
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
import 'package:iyc/view_model/campaign/add_campaign_vm.dart';
import 'package:iyc/view_model/campaign/view_campaign_data_vm.dart';
import 'package:iyc/view_model/yuva_booth/search_voters_list_vm.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class AddCampaign extends StatefulWidget {
  const AddCampaign(
      {Key? key, required this.campaignId, required this.isShimlaCampaign})
      : super(key: key);

  final String campaignId;
  final bool isShimlaCampaign;

  @override
  State<AddCampaign> createState() => _AddCampaignState();
}

class _AddCampaignState extends State<AddCampaign> {
  @override
  void initState() {
    context.read<AddCampaignVM>().mobileFocus.addListener(() {
      bool hasFocus = context.read<AddCampaignVM>().mobileFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    context.read<AddCampaignVM>().campaignCodeFocus.addListener(() {
      bool hasFocus = context.read<AddCampaignVM>().otpCodeFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });

    context.read<AddCampaignVM>().initAddCampaign(context, widget.campaignId,
        isShimlaCampaign: widget.isShimlaCampaign);
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
        title: Image.asset(
          "assets/images/iyc_logo.png",
          height: 50,
        ),
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
          Consumer<AddCampaignVM>(
            builder: (context, model, __) {
              return model.isShimlaCampaign
                  ? SizedBox()
                  : TextButton(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(5),
                        child: Text(
                          model.isEnglish ? "KA" : "EN",
                          style: TextStyle(
                              // fontSize: 18,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () async {
                        context.read<AddCampaignVM>().changeLanguage(context);
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
                      child: SearchVotersList()));

              if (voter != null)
                context.read<AddCampaignVM>().updateUserData(voter);
            },
          ),
        ],
      ),
      body: Consumer<AddCampaignVM>(
        builder: (context, model, __) {
          if (model.isLoading) return NetworkLoading();
          return SingleChildScrollView(
              child: Column(children: [
            TextFieldWithLabel(
              label: model.isEnglish
                  ? "Full Name"
                  : model.isShimlaCampaign
                      ? "पूरा नाम"
                      : "ಪೂರ್ಣ ಹೆಸರು",
              hintText: model.isEnglish
                  ? "Enter Full Name"
                  : model.isShimlaCampaign
                      ? "पूरा नाम"
                      : "ಪೂರ್ಣ ಹೆಸರನ್ನು ನಮೂದಿಸಿ",
              keyBoardType: TextInputType.name,
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
            TextFieldWithLabel(
              label: model.isEnglish
                  ? "Father/Husband Name"
                  : model.isShimlaCampaign
                      ? "पिता/पति का नाम"
                      : "ತಂದೆ\ಗಂಡ",
              hintText: model.isEnglish
                  ? "Enter Father or Husband Name"
                  : model.isShimlaCampaign
                      ? "पिता/पति का नाम"
                      : "ತಂದೆ ಅಥವಾ ಗಂಡನ ಹೆಸರನ್ನು ನಮೂದಿಸಿ",
              keyBoardType: TextInputType.name,
              controller: model.relativeNameController,
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
                      : "ಲಿಂಗ",
              hintText: model.isEnglish
                  ? "Select a gender"
                  : model.isShimlaCampaign
                      ? "एक लिंग का चयन करें"
                      : "ಲಿಂಗವನ್ನು ಆಯ್ಕೆಮಾಡಿ",
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
                      : "ವಯಸ್ಸು",
              hintText: model.isEnglish
                  ? "Select Age"
                  : model.isShimlaCampaign
                      ? "आयु का चयन करें"
                      : "ವಯಸ್ಸು ಆಯ್ಕೆಮಾಡಿ",
              currentValue: model.selectedAge,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                        model.isEnglish
                            ? " Promises"
                            : model.isShimlaCampaign
                                ? "सवाल"
                                : " ಆಯ್ಕೆಮಾಡಿ",
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
                                          overflow: TextOverflow.visible,
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
                              .read<AddCampaignVM>()
                              .changeInclination(values),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          buttonText: Text(
                              model.selectedInclinations.isEmpty
                                  ? model.isEnglish
                                      ? "Select a Promise"
                                      : "ಪ್ರಾಮಿಸ್ ಆಯ್ಕೆಮಾಡಿ"
                                  : model.isEnglish
                                      ? "Selected Promise"
                                      : " ಆಯ್ಕೆಮಾಡಿ",
                              style: Constants.formFieldItemTextStyle
                                  .copyWith(color: Colors.grey)),
                          title: Text(model.isEnglish
                              ? "Selected a Promise"
                              : " ಆಯ್ಕೆಮಾಡಿ"),
                          buttonIcon: Icon(
                            FontAwesomeIcons.angleDown,
                            size: 20,
                            color: Color(0xff788EA9),
                          ),
                        ),
                ],
              ),
            ),
            if (model.isShimlaCampaign)
              DropDownPicker(
                currentValue: model.selectedWard,
                listValues: model.boothListDropDown,
                onChanged: (value) {
                  context.read<AddCampaignVM>().changeWard(value);
                },
                labelText: "वार्ड",
                hintText: "वार्ड का चयन करें",
              ),
            TextFieldWithLabel(
              label: model.isEnglish
                  ? "Phone Number"
                  : model.isShimlaCampaign
                      ? "मोबाइल नंबर"
                      : "ಪೋನ್ ನಂ",
              hintText: model.isEnglish
                  ? "Phone Number"
                  : model.isShimlaCampaign
                      ? "मोबाइल नंबर"
                      : "ಫೋನ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ",
              keyBoardType: TextInputType.phone,
              controller: model.mobileController,
              maxLength: 10,
              focusNode: context.read<AddCampaignVM>().mobileFocus,
              validation: (value) {
                if (value.isEmpty) {
                  return model.isEnglish
                      ? 'Enter A Valid Mobile'
                      : model.isShimlaCampaign
                          ? "एक वैध मोबाइल नंबर दर्ज करें"
                          : "ಮಾನ್ಯವಾದ ಮೊಬೈಲ್ ಅನ್ನು ನಮೂದಿಸಿ";
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
                      title: model.isEnglish
                          ? "Get OTP"
                          : model.isShimlaCampaign
                              ? "ओटीपी प्राप्त"
                              : "ಒಟಿಪಿ ಪಡೆಯಿರಿ",
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
            Container(
                margin: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  model.isEnglish
                      ? "Rate Reception"
                      : model.isShimlaCampaign
                          ? "दर रिसेप्शन"
                          : " ರೇಟಿಂಗ್",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                )),
            RatingBar.builder(
              initialRating: model.rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                context.read<AddCampaignVM>().changeRating(rating);
              },
            ),
            SizedBox(
              height: 40,
            ),
            model.isLocationCaptured
                ? SizedBox(
                    width: 200,
                    child: IycIconButton(
                        title: model.isEnglish
                            ? "Submit"
                            : model.isShimlaCampaign
                                ? "प्रस्तुत करना"
                                : "ಸಲ್ಲಿಸು",
                        onTap: () {
                          if (context
                              .read<AddCampaignVM>()
                              .validateForm(context)) {
                            context.read<AddCampaignVM>().addCampaign(context);
                          }
                        }))
                : SizedBox(
                    width: 200,
                    child: IycIconButton(
                        title: model.isEnglish
                            ? "Capture Location"
                            : model.isShimlaCampaign
                                ? "स्थान कैप्चर करें"
                                : "ಸ್ಥಳ ಸೂಚಿಸಿ",
                        onTap: () {
                          if (context
                              .read<AddCampaignVM>()
                              .validateForm(context)) {
                            context
                                .read<AddCampaignVM>()
                                .captureLocation(context);
                          }
                        })),
            SizedBox(
              height: 20,
            ),
          ]));
        },
      ),
    );
  }
}
