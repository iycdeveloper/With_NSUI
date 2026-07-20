import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/size_utils.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_text_field.dart';
import 'package:iyc/app/widgets/custom_text_form_field.dart';
import 'package:iyc/screens/widgets/button/upload_button.dart';
import 'package:iyc/screens/widgets/button/next_prev_button.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/view_model/complaints/complaints_details_vm.dart';
import 'package:provider/provider.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_button.dart' as p;

class ComplaintsDetails extends StatefulWidget {
  const ComplaintsDetails(
      {Key? key,
      required this.candidateData,
      required this.candidatePost,
      required this.userMemberId,
      required this.userMemberState})
      : super(key: key);

  final Map candidateData;
  final String candidatePost;
  final String userMemberId;
  final String userMemberState;

  @override
  _ComplaintsDetailsState createState() => _ComplaintsDetailsState();
}

class _ComplaintsDetailsState extends State<ComplaintsDetails> {
  @override
  void initState() {
    context.read<ComplaintDetailsVm>().init(context, widget.candidateData,
        widget.userMemberId, widget.userMemberState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leadingWidth: mediaQueryData.size.width * 0.12,
        // leadingWidth: 44.h,
        leading: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 10),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: theme.primaryColor),
          child: IconButton(
              padding: const EdgeInsets.only(left: 10),
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
        centerTitle: true,
        title: Text(
          'Complaints Details',
          style: theme.textTheme.titleLarge!
              .copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor),
        ),
      ),
      bottomNavigationBar: Container(
          padding:
              EdgeInsets.only(left: 20.h, right: 20.h, bottom: 16.v, top: 16.v),
          // decoration: AppDecoration.outlineBlue100011,
          child: CustomElevatedButton(
            text: 'Submit',
            onTap: () => context
                .read<ComplaintDetailsVm>()
                .addComplaint(context, widget.candidatePost),
          )),
      body: SingleChildScrollView(
        child: Consumer<ComplaintDetailsVm>(
          builder: (_, model, __) => model.isLoadingPage
              ? const NetworkLoading()
              : GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),

                        child: Text(
                          "Complaint Details",
                          style: theme.textTheme.bodyMedium!
                              .copyWith(color: theme.primaryColor),
                        ),
                        // color: Colors.red,
                      ),
                      const LabelAndContentWidget(
                        label: "Complaint Type",
                        content: "Nominations",
                      ),
                      LabelAndContentWidget(
                        label: "Complaint Date",
                        content:
                            DateFormat("dd-MM-yyyy").format(DateTime.now()),
                      ),
                      LabelAndContentWidget(
                        label: "Complaint  By",
                        content: "${model.complaintBy}",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),

                        child: Text(
                          "Candidate Details",
                          style: theme.textTheme.bodyMedium!
                              .copyWith(color: theme.primaryColor),
                        ),
                        // color: Colors.red,
                      ),
                      LabelAndContentWidget(
                        label: "Candidate Name",
                        content:
                            "${widget.candidateData["FIRST_NAME"]} ${widget.candidateData["LAST_NAME"]}",
                      ),
                      LabelAndContentWidget(
                        label: "Candidate ID",
                        content: "${widget.candidateData["MEMBER_ID"]}",
                      ),
                      LabelAndContentWidget(
                        label: "Candidate Post",
                        content: widget.candidatePost,
                      ),
                      CustomFloatingTextField(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        labelText: '',
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-Z0-9]+|\s")),
                        ],
                        hintText: "Enter Your Complaint",
                        maxLines: 4,
                        controller: model.detailsController,
                      ),
                      p.UploadButtonImage(
                        showImage: model.showPickedSupportingDocument1,
                        pickedFile: model.pickedSupportingDocument1,
                        buttonTextLabel: "Upload  Document (optional)",
                        titleText: model.showPickedSupportingDocument1
                            ? "Change Document "
                            : "Upload  Document (optional)",
                        onTap: (str) async {
                          // showDialog(
                          //     context: context,
                          //     builder: (context) => CupertinoAlertDialog(
                          //           actions: [
                          //             TextButton(
                          //                 onPressed: () {
                          //                   Navigator.of(context)
                          //                       .pop(ImageSource.gallery);
                          //                 },
                          //                 child: const Text("gallery")),
                          //             TextButton(
                          //                 onPressed: () {
                          //                   Navigator.of(context)
                          //                       .pop(ImageSource.camera);
                          //                 },
                          //                 child: const Text("Camera"))
                          //           ],
                          //         )).then((value) async {
                          //   if (value != null) {
                          context
                              .read<ComplaintDetailsVm>()
                              .pickSupportingDocument(
                                str,
                                context
                                    .read<ComplaintDetailsVm>()
                                    .pickedSupportingDocument1Path,
                              );
                          //   }
                          // });
                        },
                      ),
                      p.UploadButtonImage(
                        showImage: model.showPickedSupportingDocument2,
                        pickedFile: model.pickedSupportingDocument2,
                        buttonTextLabel: "Upload  Document (optional)",
                        titleText: model.showPickedSupportingDocument2
                            ? "Change Document "
                            : "Upload  Document (optional)",
                        onTap: (str) async {
                          // showDialog(
                          //     context: context,
                          //     builder: (context) => CupertinoAlertDialog(
                          //           actions: [
                          //             TextButton(
                          //                 onPressed: () {
                          //                   Navigator.of(context)
                          //                       .pop(ImageSource.gallery);
                          //                 },
                          //                 child: const Text("gallery")),
                          //             TextButton(
                          //                 onPressed: () {
                          //                   Navigator.of(context)
                          //                       .pop(ImageSource.camera);
                          //                 },
                          //                 child: const Text("Camera"))
                          //           ],
                          //         )).then((value) async {
                          //   if (value != null) {
                          context
                              .read<ComplaintDetailsVm>()
                              .pickSupportingDocument(
                                str,
                                context
                                    .read<ComplaintDetailsVm>()
                                    .pickedSupportingDocument2Path,
                              );
                          //   }
                          // });
                        },
                      ),
                      p.UploadButtonImage(
                        showImage: model.showPickedSupportingDocument3,
                        buttonTextLabel: "Upload  Document (optional)",
                        titleText: model.showPickedSupportingDocument3
                            ? "Change Document "
                            : "Upload  Document (optional)",
                        pickedFile: model.pickedSupportingDocument3,
                        onTap: (str) async {
                          // showDialog(
                          //     context: context,
                          //     builder: (context) => CupertinoAlertDialog(
                          //           actions: [
                          //             TextButton(
                          //                 onPressed: () {
                          //                   Navigator.of(context)
                          //                       .pop(ImageSource.gallery);
                          //                 },
                          //                 child: const Text("gallery")),
                          //             TextButton(
                          //                 onPressed: () {
                          //                   Navigator.of(context)
                          //                       .pop(ImageSource.camera);
                          //                 },
                          //                 child: const Text("Camera"))
                          //           ],
                          //         )).then((value) async {
                          //   if (value != null) {
                          context
                              .read<ComplaintDetailsVm>()
                              .pickSupportingDocument(
                                str,
                                context
                                    .read<ComplaintDetailsVm>()
                                    .pickedSupportingDocument3Path,
                              );
                          //   }
                          // });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // URoundButton(
                      //     title: "submit",
                      //     onTap: () {
                      //       context
                      //           .read<ComplaintDetailsVm>()
                      //           .addComplaint(context, widget.candidatePost);
                      //     })
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class LabelAndContentWidget extends StatelessWidget {
  const LabelAndContentWidget({
    Key? key,
    required this.label,
    required this.content,
  }) : super(key: key);
  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(
                label,
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: theme.textTheme.bodyLarge!.color),
              )),
          Expanded(
              flex: 2,
              child: Text(
                ": $content",
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: theme.textTheme.bodyLarge!.color),
              ))
        ],
      ),
    );
  }
}
