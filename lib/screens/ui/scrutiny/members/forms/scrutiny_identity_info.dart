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
      appBar: AppBar(
        title:
            Text("Identity Information", style: Constants.appbarTitleTextStyle),
        backgroundColor: Constants.themeGradients[0],
        centerTitle: true,
      ),
      body: Consumer<ScrutinyIdentityInfoVM>(
          builder: (_, model, __) => SingleChildScrollView(
                child: Column(
                  children: [
                    DropDownPicker(
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
                    TextFieldWithLabel(
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
