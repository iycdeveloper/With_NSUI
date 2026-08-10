import 'package:iyc/nusi/widgets/dropdown_picker_nsui.dart';
import 'package:iyc/nusi/widgets/textfeild_with_label_nsui.dart';
import 'package:iyc/screens/ui/scrutiny/widgets/scrutiny_theme.dart';
import 'package:flutter/material.dart';
import 'package:iyc/screens/widgets/button/upload_button.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_identity_info_vm.dart';
import 'package:provider/provider.dart';

class ScrutinyIdentityInfoPage extends StatelessWidget {
  const ScrutinyIdentityInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
            context.watch<ScrutinyIdentityInfoVM>().enableAadhaarEdit
                ? "Aadhaar Verification"
                : "Identity Information",
            style: const TextStyle(
                color: ScrutinyTheme.brand,
                fontSize: 19,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        iconTheme: const IconThemeData(color: ScrutinyTheme.brand),
        centerTitle: true,
      ),
      body: Consumer<ScrutinyIdentityInfoVM>(
          builder: (_, model, __) => SingleChildScrollView(
                child: Column(
                  children: [
                    /// ID Proof is Aadhaar-only, so on an Aadhaar re-upload
                    /// the picker has nothing to choose between — the header
                    /// below states it instead.
                    if (model.enableAadhaarEdit)
                      const ScrutinySectionHeader(
                          icon: Icons.badge_outlined,
                          title: 'Aadhaar Card')
                    else
                      DropDownPickerNSUI(
                          currentValue: model.selectedIdProof,
                          listValues: model.idProofList,
                          viewOnly: model.disableFields,
                          onChanged: (val) {
                            context
                                .read<ScrutinyIdentityInfoVM>()
                                .changeIdProof(val);
                          },
                          labelText: "Id Proof",
                          hintText: "Select Id Proof"),
                    /// On an Aadhaar re-upload the ID number is not collected
                    /// at all — the card images are the evidence.
                    if (!model.enableAadhaarEdit)
                      TextFieldWithLabelNSUI(
                          label: "Id Document Number",
                          hintText: "Document Number",
                          //focusNode: model.emailFocus,
                          // nextFocus: model.addressFocus,
                          keyBoardType: TextInputType.emailAddress,
                          controller: model.idController,
                          readOnly: !model.enableIDEdit, // for disable field
                          validation: (value) {
                            if (value != null) {
                              if (value.length > 10) {
                                return null;
                              }
                              return 'Enter a Valid Document Number';
                            }
                          }),
                    Column(
                      children: [
                        if (model.enableAadhaarEdit) ...[
                          UploadButtonImage(
                            onTap: (str) => context
                                .read<ScrutinyIdentityInfoVM>()
                                .pickDocument(str, model.pickedAadhaarFrontPath,
                                    DocumentType.adhaaridFront),
                            showImage: model.showAadhaarFront,
                            pickedFile: model.pickedAadhaarFront,
                            passedContext: context,
                            buttonTextLabel: model.showAadhaarFront
                                ? "Change Aadhaar Card (Front)"
                                : "Upload Aadhaar Card (Front)",
                          ),
                          UploadButtonImage(
                            onTap: (str) => context
                                .read<ScrutinyIdentityInfoVM>()
                                .pickDocument(str, model.pickedAadhaarBackPath,
                                    DocumentType.adhaaridBack),
                            showImage: model.showAadhaarBack,
                            pickedFile: model.pickedAadhaarBack,
                            passedContext: context,
                            buttonTextLabel: model.showAadhaarBack
                                ? "Change Aadhaar Card (Back)"
                                : "Upload Aadhaar Card (Back)",
                          ),
                        ],
                        if (model.enableIDEdit)
                          UploadButtonImage(
                            onTap: (str) => context
                                .read<ScrutinyIdentityInfoVM>()
                                .pickDocument(str, model.pickedIdProofPath,
                                    DocumentType.idFront),
                            showImage: model.showIdImage,
                            pickedFile: model.pickedIdFile,
                            passedContext: context,
                            buttonTextLabel: model.showIdImage
                                ? "Change ID Document (F) "
                                : "Upload ID Document (F) ",
                          ),
                        if (model.enableIDEdit)
                          UploadButtonImage(
                            onTap: (str) => context
                                .read<ScrutinyIdentityInfoVM>()
                                .pickDocument(
                                    str,
                                    model.pickedDocumentBackFilePath,
                                    DocumentType.idBack),
                            showImage: model.showDocumentBack,
                            pickedFile: model.pickedDocumentBack,
                            buttonTextLabel: model.showDocumentBack
                                ? "Change ID Document (B)"
                                : "Upload ID Document (B)",
                          ),
                        if (model.enableAMImageEdit)

                        UploadButtonImage(
                          onlyCamera: true,
                            onTap: (str) => context
                                .read<ScrutinyIdentityInfoVM>()
                                .pickDocument(str, model.pickedAMFilePath,
                                    DocumentType.amImage),
                            showImage: model.showAMImage,
                            pickedFile: model.pickedAMFile,
                            buttonTextLabel: model.showAMImage
                                ? "Change AM Image"
                                : "Upload AM Image",
                          ),
                        if (model.enableAMVideoEdit)
                          UploadButtonVideo(
                            buttonTextLabel: model.showVideoFile
                                ? "Change video"
                                : "Upload Video",
                            onTap: (str) => context
                                .read<ScrutinyIdentityInfoVM>()
                                .saveVideo(str),
                            pickedFile: model.pickedVideoFile,
                            showImage: model.showVideoFile,
                          ),
                      ],
                    ),
                  ],
                ),
              )),
    );
  }
}
