import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/screens/ui/membership_ui/bottom_page_switcher.dart';
import 'package:iyc/screens/widgets/button/upload_button.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/view_model/membership/identity_info_vm.dart';
import 'package:iyc/view_model/membership/membership_vm.dart';
import 'package:provider/provider.dart';

// import 'bottom_page_switcher.dart';

class IdentityInfoPage extends StatefulWidget {
  const IdentityInfoPage({Key? key}) : super(key: key);

  @override
  State<IdentityInfoPage> createState() => _IdentityInfoPageState();
}

class _IdentityInfoPageState extends State<IdentityInfoPage> {
  @override
  void initState() {
    context.read<IdentityInfoVM>().init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) => SafeArea(
        child: Scaffold(
          bottomNavigationBar: isKeyboardVisible
              ? const SizedBox.shrink()
              : BottomPageSwitcher(
                  actionNext: () {
                    context.read<MembershipVM>().oneNext(3, context);
                  },
                  actionPrev: () {
                    context.read<MembershipVM>().activeStepPrevious();
                  },
                ),
          body: Consumer<IdentityInfoVM>(
              builder: (_, model, __) => SingleChildScrollView(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 20, top: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "ID Proof",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropDownPicker(
                              currentValue: model.selectedIdProof,
                              listValues: model.idProofList,
                              viewOnly: model.epicIdValidated ||
                                      model.eVoterIdValidated
                                  ? true
                                  : false,
                              onChanged: (val) {
                                FocusScope.of(context).unfocus();
                                context
                                    .read<IdentityInfoVM>()
                                    .changeIdProof(val);
                              },
                              labelText: "ID Proof",
                              hintText: "Select Id Proof"),
                          model.selectedIdProof == "EI"
                              ? TextFieldWithLabel(
                                  label: "Voter ID Card Document Number",
                                  hintText: "Voter ID Card Document Number",
                                  //focusNode: model.emailFocus,
                                  // nextFocus: model.addressFocus,
                                  keyBoardType: TextInputType.emailAddress,
                                  controller: model.idController,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15)
                                  ],
                                  readOnly: model.epicIdValidated,
                                  validation: (value) {
                                    if (value != null) {
                                      if (value.length > 10) {
                                        return null;
                                      }
                                      return 'Enter a Valid Voter Card Number';
                                    }
                                  })
                              : SizedBox(),
                          if (model.selectedIdProof == "EV") ...[
                            TextFieldWithLabel(
                                label: "E Voter ID Document Number",
                                hintText: "E Voter Document Number",
                                //focusNode: model.emailFocus,
                                // nextFocus: model.addressFocus,
                                keyBoardType: TextInputType.emailAddress,
                                controller: model.evoterIdController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(15)
                                ],
                                readOnly: model.eVoterIdValidated,
                                validation: (value) {
                                  if (value != null) {
                                    if (value.length > 10) {
                                      return null;
                                    }
                                    return 'Enter a E Voter Valid Document Number';
                                  }
                                }),
                          ],
                          if (!model.epicIdValidated &&
                              !model.eVoterIdValidated)
                            Container(
                                padding: EdgeInsets.only(
                                    left: 20.h,
                                    right: 20.h,
                                    bottom: 10.v,
                                    top: 10.v),
                                child: CustomElevatedButton(
                                    text: model.selectedIdProof == "EV"
                                        ? 'Validate E Voter ID'
                                        : 'Validate Voter ID',
                                    onTap: () {
                                      model.validateEpicId(context);
                                    })),
                          if (model.selectedIdProof == "EV" &&
                              model.eVoterIdValidated) ...[
                            TextFieldWithLabel(
                                label: "AADHAR Number",
                                hintText: "AADHAR Number",
                                // textFieldHeight:16,
                                maxLength: 12,
                                //focusNode: model.emailFocus,
                                // nextFocus: model.addressFocus,
                                // keyBoardType: TextInputType.number,
                                controller: model.adhaarIdController,
                                keyBoardType:
                                    const TextInputType.numberWithOptions(
                                        signed: true, decimal: true),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(12)
                                ],
                                // readOnly: model.epicIdValidated,
                                validation: (value) {
                                  if (value != null) {
                                    if (value.length > 12) {
                                      return null;
                                    }
                                    return 'Enter a Valid AADHAR Number';
                                  }
                                }),
                            UploadButtonImage(
                              onTap: (str) => context
                                  .read<IdentityInfoVM>()
                                  .pickDocument(
                                      str,
                                      model.pickedEvoterIdFrontProofPath,
                                      DocumentType.evoderidFront,
                                      context),
                              showImage: model.showEvoterDocumentFront,
                              pickedFile: model.pickedDocumentEvoterFront,
                              passedContext: context,
                              buttonTextLabel: model.showEvoterDocumentFront
                                  ? "Change E Voter ID Document (Front) "
                                  : "Upload E Voter ID Document (Front)",
                            ),
                            UploadButtonImage(
                              onTap: (str) => context
                                  .read<IdentityInfoVM>()
                                  .pickDocument(
                                      str,
                                      model.pickedEvoterIdBackProofPath,
                                      DocumentType.evoderidBack,
                                      context),
                              showImage: model.showEvoterocumentBack,
                              pickedFile: model.pickedDocumentEvoterBack,
                              buttonTextLabel: model.showEvoterocumentBack
                                  ? "Change E Voter Document (Back)"
                                  : "Upload E Voter Document (Back)",
                            ),
                            UploadButtonImage(
                              onTap: (str) => context
                                  .read<IdentityInfoVM>()
                                  .pickDocument(
                                      str,
                                      model.pickedAdhaarFrontFilePath,
                                      DocumentType.adhaaridFront,
                                      context),
                              showImage: model.showAdhaarDocumentFront,
                              pickedFile: model.pickedDocumentAdhaarFront,
                              passedContext: context,
                              buttonTextLabel: model.showAdhaarDocumentFront
                                  ? "Change AADHAR Document (Front) "
                                  : "Upload AADHAR Document (Front) ",
                            ),
                            UploadButtonImage(
                              onTap: (str) => context
                                  .read<IdentityInfoVM>()
                                  .pickDocument(
                                      str,
                                      model.pickedAdhaarBackFilePath,
                                      DocumentType.adhaaridBack,
                                      context),
                              showImage: model.showAdhaarDocumentBack,
                              pickedFile: model.pickedDocumentAdhaarBack,
                              buttonTextLabel: model.showAdhaarDocumentBack
                                  ? "Change AADHAR Document (Back)"
                                  : "Upload AADHAR Document (Back)",
                            ),
                          ],
                          if (model.epicIdValidated &&
                              model.selectedIdProof != "EV") ...[
                            UploadButtonImage(
                              onTap: (str) => context
                                  .read<IdentityInfoVM>()
                                  .pickDocument(str, model.pickedIdProofPath,
                                      DocumentType.idFront, context),
                              showImage: model.showIdImage,
                              pickedFile: model.pickedIdFile,
                              passedContext: context,
                              buttonTextLabel: model.showIdImage
                                  ? "Change ID Document (Front) "
                                  : "Upload ID Document (Front) ",
                            ),
                            UploadButtonImage(
                              onTap: (str) => context
                                  .read<IdentityInfoVM>()
                                  .pickDocument(
                                      str,
                                      model.pickedDocumentBackFilePath,
                                      DocumentType.idBack,
                                      context),
                              showImage: model.showDocumentBack,
                              pickedFile: model.pickedDocumentBack,
                              buttonTextLabel: model.showDocumentBack
                                  ? "Change ID Document (Back)"
                                  : "Upload ID Document (Back)",
                            ),

                            // UploadButtonImage(
                            //   onlyCamera: true,
                            //   onTap: (str) => context
                            //       .read<IdentityInfoVM>()
                            //       .pickDocument(str, model.pickedAMFilePath,
                            //           DocumentType.amImage, context),
                            //   showImage: model.showAMImage,
                            //   pickedFile: model.pickedAMFile,
                            //   buttonTextLabel: model.showAMImage
                            //       ? "Change Member Image"
                            //       : "Upload Member Image",
                            // ),
                            // // UploadButtonLiveImage(
                            // //   onTap: (str) => context
                            // //       .read<IdentityInfoVM>().clickLivePhoto(),
                            // //   showImage: model.showAMImage,
                            // //   pickedFile: model.pickedAMFile,
                            // //   buttonTextLabel: model.showAMImage
                            // //       ? "Change Member Image"
                            // //       : "Upload Member Image",
                            // // ),

                            // context
                            //         .read<MembershipVM>()
                            //         .currentMember!
                            //         .isLegalCell
                            //     ? Column(
                            //         children: [
                            //           TextFieldWithLabel(
                            //               label: "Bar Council ID",
                            //               hintText: "Bar council ID",
                            //               //focusNode: model.emailFocus,
                            //               // nextFocus: model.addressFocus,
                            //               keyBoardType:
                            //                   TextInputType.emailAddress,
                            //               controller: model.barIdController,
                            //               validation: (value) {
                            //                 if (value != null) {
                            //                   if (value.length > 4) {
                            //                     return null;
                            //                   }
                            //                   return 'Enter a Valid Bar council ID';
                            //                 }
                            //               }),
                            //           UploadButtonImage(
                            //             onTap: (str) => context
                            //                 .read<IdentityInfoVM>()
                            //                 .pickDocument(
                            //                     str,
                            //                     model
                            //                         .pickedBarCounsilIdFilePath,
                            //                     DocumentType.barCouncilId,
                            //                     context),
                            //             showImage: model.showBarIdImage,
                            //             pickedFile:
                            //                 model.pickedBarCounsilIdFile,
                            //             buttonTextLabel: model.showBarIdImage
                            //                 ? "Change Bar council ID"
                            //                 : "Upload Bar council ID",
                            //           ),
                            //         ],
                            //       )
                            //     : UploadButtonVideo(
                            //         buttonTextLabel: model.showVideoFile
                            //             ? "Change Video"
                            //             : "Upload Video ${model.showVideoOptional ? "(Optional)" : ""}",
                            //         onTap: (str) => context
                            //             .read<IdentityInfoVM>()
                            //             .saveVideo(str),
                            //         pickedFile: model.pickedVideoFile,
                            //         showImage: model.showVideoFile,
                            //       ),
                          ],
                          if (model.epicIdValidated ||
                              model.eVoterIdValidated) ...[
                            UploadButtonImage(
                              onlyCamera: true,
                              onTap: (str) {
                                context.read<IdentityInfoVM>().pickDocument(
                                    str,
                                    model.pickedAMFilePath,
                                    DocumentType.amImage,
                                    context);
                                // context
                                //     .read<IdentityInfoVM>()
                                //     .clickLivePhotoNew(context);
                              },
                              showImage: model.showAMImage,
                              pickedFile: model.pickedAMFile,
                              buttonTextLabel: model.showAMImage
                                  ? "Change Member Image"
                                  : "Upload Member Image",
                            ),
                            // UploadButtonLiveImage(
                            //   onTap: (str) => context
                            //       .read<IdentityInfoVM>().clickLivePhoto(),
                            //   showImage: model.showAMImage,
                            //   pickedFile: model.pickedAMFile,
                            //   buttonTextLabel: model.showAMImage
                            //       ? "Change Member Image"
                            //       : "Upload Member Image",
                            // ),

                            context
                                    .read<MembershipVM>()
                                    .currentMember!
                                    .isLegalCell
                                ? Column(
                                    children: [
                                      TextFieldWithLabel(
                                          label: "Bar Council ID",
                                          hintText: "Bar council ID",
                                          //focusNode: model.emailFocus,
                                          // nextFocus: model.addressFocus,
                                          keyBoardType:
                                              TextInputType.emailAddress,
                                          controller: model.barIdController,
                                          validation: (value) {
                                            if (value != null) {
                                              if (value.length > 4) {
                                                return null;
                                              }
                                              return 'Enter a Valid Bar council ID';
                                            }
                                          }),
                                      UploadButtonImage(
                                        onTap: (str) => context
                                            .read<IdentityInfoVM>()
                                            .pickDocument(
                                                str,
                                                model
                                                    .pickedBarCounsilIdFilePath,
                                                DocumentType.barCouncilId,
                                                context),
                                        showImage: model.showBarIdImage,
                                        pickedFile:
                                            model.pickedBarCounsilIdFile,
                                        buttonTextLabel: model.showBarIdImage
                                            ? "Change Bar council ID"
                                            : "Upload Bar council ID",
                                      ),
                                    ],
                                  )
                                : UploadButtonVideo(
                                    buttonTextLabel: model.showVideoFile
                                        ? "Change Video"
                                        : "Upload Video ${model.showVideoOptional ? "(Optional)" : ""}",
                                    onTap: (str) => context
                                        .read<IdentityInfoVM>()
                                        .saveVideo(str),
                                    pickedFile: model.pickedVideoFile,
                                    showImage: model.showVideoFile,
                                  ),
                          ],
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
