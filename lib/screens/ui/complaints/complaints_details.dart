import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iyc/screens/widgets/button/upload_button.dart';
import 'package:iyc/screens/widgets/button/next_prev_button.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/view_model/complaints/complaints_details_vm.dart';
import 'package:provider/provider.dart';

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
        title: Text("Complaints Details"),
      ),
      body: SingleChildScrollView(
        child: Consumer<ComplaintDetailsVm>(
          builder: (_, model, __) => model.isLoadingPage
              ? NetworkLoading()
              : GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Column(
                    children: [
                      LabelAndContentWidget(
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
                      Container(
                        child: Text("Complaint Details"),
                        color: Colors.red,
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
                        content: "${widget.candidatePost}",
                      ),
                      Container(
                        height: 100,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all()),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[a-zA-Z0-9]+|\s")),
                          ],
                          decoration: InputDecoration.collapsed(
                            hintText: "complaint is about....",
                          ),
                          maxLines: null,
                          controller: model.detailsController,
                        ),
                      ),
                      Row(
                        children: [
                          UploadButton(
                            labelText: "",
                            buttonTextLabel: model.showPickedSupportingDocument1
                                ? "Change Document "
                                : "Upload  Document (optional)",
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(ImageSource.gallery);
                                              },
                                              child: Text("gallery")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(ImageSource.camera);
                                              },
                                              child: Text("Camera"))
                                        ],
                                      )).then((value) async {
                                if (value != null)
                                  context
                                      .read<ComplaintDetailsVm>()
                                      .pickSupportingDocument(
                                        value,
                                        context
                                            .read<ComplaintDetailsVm>()
                                            .pickedSupportingDocument1Path,
                                      );
                              });
                            },
                          ),
                          model.showPickedSupportingDocument1
                              ? NextPrevButton(
                                  title: "View",
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              insetPadding: EdgeInsets.zero,
                                              content: SizedBox.expand(
                                                child: Image.file(model
                                                    .pickedSupportingDocument1!),
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text("Close"),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                )
                                              ],
                                            ));
                                  })
                              : Container(),
                        ],
                      ),
                      Row(
                        children: [
                          UploadButton(
                            labelText: "",
                            buttonTextLabel: model.showPickedSupportingDocument2
                                ? "Change Document "
                                : "Upload  Document (optional)",
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(ImageSource.gallery);
                                              },
                                              child: Text("gallery")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(ImageSource.camera);
                                              },
                                              child: Text("Camera"))
                                        ],
                                      )).then((value) async {
                                if (value != null)
                                  context
                                      .read<ComplaintDetailsVm>()
                                      .pickSupportingDocument(
                                        value,
                                        context
                                            .read<ComplaintDetailsVm>()
                                            .pickedSupportingDocument2Path,
                                      );
                              });
                            },
                          ),
                          model.showPickedSupportingDocument2
                              ? NextPrevButton(
                                  title: "View",
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              insetPadding: EdgeInsets.zero,
                                              content: SizedBox.expand(
                                                child: Image.file(model
                                                    .pickedSupportingDocument2!),
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text("Close"),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                )
                                              ],
                                            ));
                                  })
                              : Container(),
                        ],
                      ),
                      Row(
                        children: [
                          UploadButton(
                            labelText: "",
                            buttonTextLabel: model.showPickedSupportingDocument3
                                ? "Change Document "
                                : "Upload  Document (optional)",
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(ImageSource.gallery);
                                              },
                                              child: Text("gallery")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(ImageSource.camera);
                                              },
                                              child: Text("Camera"))
                                        ],
                                      )).then((value) async {
                                if (value != null)
                                  context
                                      .read<ComplaintDetailsVm>()
                                      .pickSupportingDocument(
                                        value,
                                        context
                                            .read<ComplaintDetailsVm>()
                                            .pickedSupportingDocument3Path,
                                      );
                              });
                            },
                          ),
                          model.showPickedSupportingDocument3
                              ? NextPrevButton(
                                  title: "View",
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              insetPadding: EdgeInsets.zero,
                                              content: SizedBox.expand(
                                                child: Image.file(model
                                                    .pickedSupportingDocument3!),
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text("Close"),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                )
                                              ],
                                            ));
                                  })
                              : Container(),
                        ],
                      ),
                      URoundButton(
                          title: "submit",
                          onTap: () {
                            context
                                .read<ComplaintDetailsVm>()
                                .addComplaint(context, widget.candidatePost);
                          })
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
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(label)),
          Expanded(flex: 2, child: Text(": $content"))
        ],
      ),
    );
  }
}
