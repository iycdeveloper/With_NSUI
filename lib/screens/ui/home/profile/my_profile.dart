import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iyc/provider/auth/register_provider.dart';
import 'package:iyc/screens/ui/home/profile/id_card_generater.dart';
import 'package:iyc/screens/widgets/button/iyc_icon_button.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/profile/profile_vm.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    context.read<ProfileVm>().getUserPoints(context);
    context.read<ProfileVm>().getUserProfile(context);
    context.read<ProfileVm>().getProfilePic(context);
    context.read<ProfileVm>().getAuthPoint(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () async {
              },
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      toPage(
                          context,
                          IdCardGenerator(
                            userDetails: context.read<ProfileVm>().userDetail!,
                          ));
                    },
                    child: Text(
                      'ID Card   ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Icon(Icons.edit),
                  Text(
                    "Edit",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: Consumer<ProfileVm>(
        builder: (_, model, __) => model.isLoading
            ? NetworkLoading()
            : model.userDetail == null
                ? Center(
                    child: Text("No user details found"),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width,
                                height: 260,
                                //  MediaQuery.of(context).size.height / 2 - 40,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 20,
                                        spreadRadius: 10,
                                      )
                                    ],
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                    )),
                                child: Column(
                                  children: <Widget>[
                                    // Row(
                                    //   mainAxisAlignment:
                                    //   MainAxisAlignment.spaceBetween,
                                    //   children: <Widget>[
                                    //     Padding(
                                    //       padding:
                                    //       const EdgeInsets.only(left: 130),
                                    //       child: Container(
                                    //         height: 105,
                                    //         width: 105,
                                    //         decoration: BoxDecoration(
                                    //             color: Colors.indigo[500],
                                    //             borderRadius:
                                    //             BorderRadius.circular(52.5),
                                    //             boxShadow: [
                                    //               BoxShadow(
                                    //                 color: Colors.yellow,
                                    //                 spreadRadius: 2,
                                    //               )
                                    //             ]),
                                    //         child: CircleAvatar(
                                    //           radius: 50,
                                    //           backgroundImage: NetworkImage(
                                    //               "https://pixabay.com/images/download/blank-profile-picture-973460_640.png?attachment"),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      model.userDetail!.name,
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      model.userDetail?.roleName ?? "",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RatingBarIndicator(
                                      rating: double.parse(model.authPoint),
                                      itemCount: 5,
                                      itemSize: 30.0,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    // Text(
                                    //   "${model.stateList.firstWhere((element) => element.stateCode == model.userDetail!.stateCode).name} (Home)",
                                    //   style: TextStyle(
                                    //     fontSize: 18,
                                    //     fontWeight: FontWeight.w700,
                                    //     color: Colors.white,
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // if (model.userDetail!.workingState != null)
                                    //   Text(
                                    //     "${model.stateList.firstWhereOrNull((element) => element.stateCode == model.userDetail!.workingState)?.name} (Work)",
                                    //     style: TextStyle(
                                    //       fontSize: 18,
                                    //       fontWeight: FontWeight.w700,
                                    //       color: Colors.white,
                                    //     ),
                                    //   ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Column(children: [
                                            Text("Points",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                            Text(
                                              model.userPoint,
                                            ),
                                          ]),
                                        ),
                                        // Container(
                                        //   padding: EdgeInsets.all(20),
                                        //   decoration: BoxDecoration(
                                        //       color: Colors.white,
                                        //       borderRadius:
                                        //       BorderRadius.circular(20)),
                                        //   child: Column(children: [
                                        //     Text("Level",
                                        //         style: TextStyle(
                                        //           fontSize: 18,
                                        //           fontWeight: FontWeight.w700,
                                        //         )),
                                        //     Text("1"),
                                        //   ]),
                                        // ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                            child: Padding(
                                padding: EdgeInsets.only(bottom: 20, top: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [],
                                ))),
                        LabelAndContent(
                          label: "Home State",
                          content: "${model.stateList.firstWhere((element) => element.stateCode == model.userDetail!.stateCode).name}",
                        ),
                        if (model.userDetail!.workingState != null)
                        LabelAndContent(
                          label: "Work State",
                          content: "${model.stateList.firstWhereOrNull((element) => element.stateCode == model.userDetail!.workingState)?.name}",
                        ),
                        LabelAndContent(
                          label: "Mobile",
                          content: model.userDetail!.mobile,
                        ),
                        LabelAndContent(
                          label: "Date of Birth",
                          content: model.userDetail!.dateOfBirth,
                        ),
                        if (model.districtList.any((element) =>
                            element.districtCode ==
                            model.userDetail!.districtCode))
                          LabelAndContent(
                            label: "District",
                            content: model.districtList
                                .firstWhere((element) =>
                                    element.districtCode ==
                                    model.userDetail!.districtCode)
                                .name,
                          ),
                        if (model.assemblyList.any((element) =>
                            element.assemblyCode ==
                            model.userDetail!.assemblyCode))
                          LabelAndContent(
                            label: "Assembly",
                            content: model.assemblyList
                                .firstWhere((element) =>
                                    element.assemblyCode ==
                                    model.userDetail!.assemblyCode)
                                .name,
                          ),
                        // IycIconButton(
                        //     title: "Download ID Card",
                        //     onTap: () => context
                        //         .read<ProfileVm>()
                        //         .downloadIdCard(context)),
                        if (Platform.isIOS)
                          IycIconButton(
                              title: "Delete Account",
                              onTap: () async {
                                await Alert(
                                  context: context,
                                  type: AlertType.warning,
                                  onWillPopActive: true,
                                  title: "Delete Account",
                                  desc: "Send Email for Account Deletion",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OKAY",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () async {
                                        String? encodeQueryParameters(
                                            Map<String, String> params) {
                                          return params.entries
                                              .map((MapEntry<String, String>
                                                      e) =>
                                                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                              .join('&');
                                        }

// ···
                                        final Uri emailLaunchUri = Uri(
                                          scheme: 'mailto',
                                          path: 'developer@inc.in',
                                          query: encodeQueryParameters(<String,
                                              String>{
                                            'subject':
                                                'Account deletion ${model.userDetail?.mobile}',
                                          }),
                                        );

                                        launchUrl(emailLaunchUri);
                                        Navigator.of(context).pop();
                                      },
                                      width: 120,
                                    )
                                  ],
                                ).show();
                              })
                      ],
                    ),
                  ),
      ),
    );
  }
}

class LabelAndContent extends StatelessWidget {
  const LabelAndContent({Key? key, required this.label, required this.content})
      : super(key: key);
  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.lightBlueAccent))),
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
              vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(label,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(content,
                  style: TextStyle(color: Colors.black87, fontSize: 18)),
            )
          ])),
    );
  }
}
