import 'package:flutter/material.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/screens/ui/members/inc/label_with_text_widget.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/members/member_page_vm.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({Key? key, required this.member}) : super(key: key);
  final BatchMember member;

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  int pageNumber = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    context.read<MemberPageVM>().setMemberDetails(widget.member);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberPageVM>(
      builder: (_, model, __) => Scaffold(
        body: model.isLoading
            ? const NetworkLoading()
            : PageView(
                controller: pageController,
                onPageChanged: (page) {
                  setState(() {
                    pageNumber = page;
                  });
                },
                children: [
                  buildBasicInfoPage(),
                  buildContactInfoPage(),
                  buildPersonalInfoPage(),
                  buildIdentityInfoPage(),
                  buildConstituencyInfoPage(),
                  buildCandidatesInfoPage()
                ],
              ),
        bottomNavigationBar: pageNumber < 5
            ? URoundButton(
                title: "Next", onTap: () => onNext(pageNumber, context))
            : URoundButton(
                title: "Close", onTap: () => Navigator.of(context).pop()),
      ),
    );
  }

  onNext(int pageNumber, BuildContext context) {
    pageController.nextPage(
        duration: const Duration(milliseconds: 50), curve: Curves.easeIn);
  }

  Widget buildBasicInfoPage() => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Basic Information",
                style: Constants.appbarTitleTextStyle),
            backgroundColor: Constants.themeGradients[0],
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                TextFieldWithLabel(
                  label: "First Name",
                  hintText: "First Name",
                  keyBoardType: TextInputType.name,
                  readOnly: true,
                  controller: context.read<MemberPageVM>().usernameController,
                ),
                TextFieldWithLabel(
                  label: "Last Name",
                  hintText: "Last Name",
                  keyBoardType: TextInputType.name,
                  controller: context.read<MemberPageVM>().lastNameController,
                  readOnly: true,
                ),
                TextFieldWithLabel(
                  label: "Your Profession",
                  readOnly: true,
                  hintText: "Your Profession",
                  keyBoardType: TextInputType.name,
                  controller: context.read<MemberPageVM>().professionController,
                  validation: (value) {
                    if (value.isEmpty) {
                      return 'Enter A Valid Profession';
                    }
                    return null;
                  },
                ),
                TextFieldWithLabel(
                  label: "Father/Husband Name",
                  hintText: "Father/Husband Name",
                  readOnly: true,
                  keyBoardType: TextInputType.name,
                  controller: context.read<MemberPageVM>().fatherNameController,
                  validation: (value) {
                    if (value.isEmpty) {
                      return 'Enter A Valid Name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildContactInfoPage() => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Contact Information",
                style: Constants.appbarTitleTextStyle),
            backgroundColor: Constants.themeGradients[0],
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                TextFieldWithLabel(
                  label: "Mobile No.",
                  hintText: "Mobile No.",
                  readOnly: true,
                  keyBoardType: TextInputType.number,
                  controller: context.read<MemberPageVM>().mobileController,
                  validation: (value) {
                    if (value.isEmpty || value.length != 10) {
                      return 'Enter A Valid Mobile No';
                    }
                    return null;
                  },
                ),
                TextFieldWithLabel(
                  label: "Email Id",
                  hintText: "Email Id",
                  keyBoardType: TextInputType.name,
                  controller: context.read<MemberPageVM>().emailController,
                  readOnly: true,
                ),
                TextFieldWithLabel(
                  label: "Address",
                  readOnly: true,
                  hintText: "Address",
                  keyBoardType: TextInputType.name,
                  controller: context.read<MemberPageVM>().addressController,
                ),
                TextFieldWithLabel(
                  label: "Pin",
                  hintText: "Pin",
                  readOnly: true,
                  keyBoardType: TextInputType.name,
                  controller: context.read<MemberPageVM>().pinController,
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildPersonalInfoPage() => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Personal Information",
                style: Constants.appbarTitleTextStyle),
            backgroundColor: Constants.themeGradients[0],
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                TextFieldWithLabel(
                  label: "Gender",
                  hintText: "Gender",
                  readOnly: true,
                  keyBoardType: TextInputType.number,
                  controller: context.read<MemberPageVM>().genderController,
                ),
                TextFieldWithLabel(
                  label: "Date of Birth",
                  keyBoardType: TextInputType.name,
                  controller: context.read<MemberPageVM>().dobController,
                  readOnly: true,
                ),
                TextFieldWithLabel(
                  label: "Category",
                  readOnly: true,
                  hintText: "Category",
                  keyBoardType: TextInputType.name,
                  controller: context.read<MemberPageVM>().categoryController,
                ),
                TextFieldWithLabel(
                  label: "Education",
                  hintText: "Education",
                  keyBoardType: TextInputType.name,
                  controller: context.read<MemberPageVM>().educationController,
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildIdentityInfoPage() => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Identity Info", style: Constants.appbarTitleTextStyle),
            backgroundColor: Constants.themeGradients[0],
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                TextFieldWithLabel(
                  label: "Id Type",
                  readOnly: true,
                  hintText: "Id Type",
                  keyBoardType: TextInputType.name,
                  controller: context.read<MemberPageVM>().idTypeController,
                ),
                TextFieldWithLabel(
                  label: "Id Value",
                  readOnly: true,
                  hintText: "Id Value",
                  keyBoardType: TextInputType.name,
                  controller: context.read<MemberPageVM>().idProofController,
                ),
                context.read<MemberPageVM>().idTypeController.text ==
                        'E Voter ID'
                    ? TextFieldWithLabel(
                        label: "AADHAR Value",
                        readOnly: true,
                        hintText: "AADHAR Value",
                        keyBoardType: TextInputType.name,
                        controller:
                            context.read<MemberPageVM>().aadharController,
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
      );

  Widget buildConstituencyInfoPage() => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Constituency Info",
                style: Constants.appbarTitleTextStyle),
            backgroundColor: Constants.themeGradients[0],
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                TextFieldWithLabel(
                  label: "State",
                  readOnly: true,
                  hintText: "State",
                  keyBoardType: TextInputType.name,
                  controller: context.read<MemberPageVM>().stateNameController,
                ),
                TextFieldWithLabel(
                  label: "Parliamentary Constituency",
                  readOnly: true,
                  hintText: "Parliamentary Constituency",
                  keyBoardType: TextInputType.name,
                  controller:
                      context.read<MemberPageVM>().districtNameController,
                ),
                AppConstants.blockStatesList.contains(
                        context.read<MemberPageVM>().currentMember?.stateCode)
                    ? TextFieldWithLabel(
                        label: "Block Constituency",
                        readOnly: true,
                        hintText: "Block Constituency",
                        keyBoardType: TextInputType.name,
                        controller:
                            context.read<MemberPageVM>().blockNameController,
                      )
                    : TextFieldWithLabel(
                        label: "Assembly Constituency/Block",
                        readOnly: true,
                        hintText: "Assembly Constituency/Block",
                        keyBoardType: TextInputType.name,
                        controller:
                            context.read<MemberPageVM>().assemblyNameController,
                      ),
                if (context
                    .read<MemberPageVM>()
                    .mandalamNameController
                    .text
                    .isNotEmpty)
                  TextFieldWithLabel(
                    label: "Mandalam/Block",
                    readOnly: true,
                    hintText: "Mandalam/Block",
                    keyBoardType: TextInputType.name,
                    controller:
                        context.read<MemberPageVM>().mandalamNameController,
                  ),
                LabelWithTextWidget(
                  label: "Booth",
                  text: context.read<MemberPageVM>().currentMember!.boothCode ??
                      "",
                )
              ],
            ),
          ),
        ),
      );

  Widget buildCandidatesInfoPage() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Candidates Info", style: Constants.appbarTitleTextStyle),
          backgroundColor: Constants.themeGradients[0],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextFieldWithLabel(
                label: "State President Candidate",
                readOnly: true,
                hintText: "State President Candidate",
                keyBoardType: TextInputType.name,
                controller: context
                    .read<MemberPageVM>()
                    .statePresidentCandidateController,
              ),
              TextFieldWithLabel(
                label: "State General Secretary Candidate",
                readOnly: true,
                hintText: "State General Secretary Candidate",
                keyBoardType: TextInputType.name,
                controller:
                    context.read<MemberPageVM>().stateGsCandidateController,
              ),
              TextFieldWithLabel(
                label: "District President Candidate",
                readOnly: true,
                hintText: "District Candidate",
                keyBoardType: TextInputType.name,
                controller:
                    context.read<MemberPageVM>().districtCandidateController,
              ),
              // if (context.read<MemberPageVM>().currentMember?.stateCode == "KL")
              TextFieldWithLabel(
                label: "District GS Candidate",
                readOnly: true,
                hintText: "District Candidate",
                keyBoardType: TextInputType.name,
                controller:
                    context.read<MemberPageVM>().districtCandidateGsController,
              ),
              TextFieldWithLabel(
                label: "Assembly Candidate",
                readOnly: true,
                hintText: "Assembly Candidate",
                keyBoardType: TextInputType.name,
                controller:
                    context.read<MemberPageVM>().assemblyCandidateController,
              ),
              if ([
                "KL",
                "TL",
                "KA",
                "DL",
                "HP",
                "HR",
                "TN",
                "MB",
                "TS",
                "MP",
                "GJ"
              ].contains(context.read<MemberPageVM>().currentMember?.stateCode))
                TextFieldWithLabel(
                  label: "Mandalam Candidate",
                  readOnly: true,
                  hintText: "Mandalam Candidate",
                  keyBoardType: TextInputType.name,
                  controller:
                      context.read<MemberPageVM>().mandalamCandidateController,
                ),
              if (context.read<MemberPageVM>().otpSent &&
                  !context.read<MemberPageVM>().otpVerified)
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Pinput(
                    length: 6,
                    // focusNode: model.otpCodeFocus,
                    controller: context.read<MemberPageVM>().otpCodeController,
                    defaultPinTheme: defaultPinTheme,
                    followingPinTheme: defaultPinTheme,
                    submittedPinTheme: defaultPinTheme,
                    pinAnimationType: PinAnimationType.fade,
                  ),
                ),
              if (context.read<MemberPageVM>().isEnableCSNverify) ...[
                if (!context.read<MemberPageVM>().otpVerified)
                  SizedBox(
                    height: 90,
                    child: URoundButton(
                        title: context.read<MemberPageVM>().otpSent
                            ? "Verify"
                            : "Get OTP To Verify CSN",
                        onTap: () {
                          context.read<MemberPageVM>().otpSent
                              ? context
                                  .read<MemberPageVM>()
                                  .onClickValidateOtp(context)
                              : context
                                  .read<MemberPageVM>()
                                  .onClickSendOtp(context);
                        }),
                  )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
