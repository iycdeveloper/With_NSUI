import 'package:flutter/material.dart';
import 'package:iyc/screens/ui/home/home_page_drawer.dart';
import 'package:iyc/screens/ui/home/ob/ecternal_training.dart';
import 'package:iyc/screens/ui/home/ob/ob_home.dart';
import 'package:iyc/screens/ui/home/yuva_booth/add_booth_jodo.dart';
import 'package:iyc/screens/ui/home/yuva_booth/add_yuva_data_meeting.dart';
import 'package:iyc/screens/ui/home/yuva_booth/view_booth_jodo.dart';
import 'package:iyc/screens/ui/home/yuva_booth/yuva_user_list.dart';
import 'package:iyc/screens/widgets/cards/icon_card.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/ob/external_training_vm.dart';
import 'package:iyc/view_model/yuva_booth/add_booth_jodo_vm.dart';
import 'package:iyc/view_model/yuva_booth/add_yuva_data_meeting_vm.dart';
import 'package:iyc/view_model/yuva_booth/view_booth_jodo_vm.dart';
import 'package:iyc/view_model/yuva_booth/yuva_booth_home_vm.dart';
import 'package:iyc/view_model/yuva_booth/yuva_users_list_vm.dart';
import 'package:provider/provider.dart';

import '../../../widgets/network_loading.dart';
import '../user_reports/user_reports.dart';
import 'package:url_launcher/url_launcher.dart';

class YuvaBoothHome extends StatefulWidget {
  const YuvaBoothHome({Key? key}) : super(key: key);

  @override
  State<YuvaBoothHome> createState() => _YuvaBoothHomeState();
}

class _YuvaBoothHomeState extends State<YuvaBoothHome> {
  @override
  void initState() {
    context.read<YuvaBoothHomeVM>().getYuvaUser(context);
    context.read<YuvaBoothHomeVM>().initPage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomePageDrawer(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Election Management"),
      ),
      body: Consumer<YuvaBoothHomeVM>(
          builder: (_, model, __) => model.loadingPage
              ? NetworkLoading()
              : model.showError
                  ? Center(
                      child: Row(
                      children: [
                        IconCard(
                            title: "Pehla Vote",
                            icon: "assets/iyc_icons/voting-box.png",
                            onTap: () async {
                              if (!await launchUrl(
                                Uri.parse("https://pehlavote.iyc.in/"),
                                mode: LaunchMode.externalApplication,
                              )) {
                                throw Exception(
                                    'Could not launch https://yuvamatha.com/en_gb/}');
                              }
                            }),
                        IconCard(
                            title: "OB",
                            icon: "assets/iyc_icons/meeting-point.png",
                            onTap: () async {
                              toPage(context, NobHome());
                            }),
                      ],
                    ))
                  : ListView(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            IconCard(
                                title: "Pehla Vote",
                                icon: "assets/iyc_icons/voting-box.png",
                                onTap: () async {
                                  if (!await launchUrl(
                                    Uri.parse("https://pehlavote.iyc.in/"),
                                    mode: LaunchMode.externalApplication,
                                  )) {
                                    throw Exception(
                                        'Could not launch https://yuvamatha.com/en_gb/}');
                                  }
                                }),
                            // IconCard(
                            //     title: "External Training",
                            //     icon: "assets/iyc_icons/round-table.png",
                            //     onTap: () {
                            //       toPage(
                            //           context,
                            //           ChangeNotifierProvider(
                            //               create: (context) => ExternalTrainingVM(),
                            //               child: ExternalTraining()));
                            //     }),
                            if (int.parse(model.yuvaUser!.roleId) <
                                5) // restricted booth in charge
                              IconCard(
                                title: "Add Role",

                                icon:
                                    "assets/iyc_icons/system-administrator.png",
                                onTap: () async {
                                  await showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SimpleDialog(
                                          // <-- SEE HERE
                                          title: const Text('Select Role Type'),
                                          children: model.generateDialogOptions(
                                              context, model.yuvaUser!.roleId),
                                        );
                                      });
                                },
                                // onTap: () {
                                //   toPage(
                                //       context,
                                //       ChangeNotifierProvider(
                                //           create: (context) => AddYuvaUserVM(),
                                //           child: AddYuvaUser(
                                //               yuvaUser: model.yuvaUser!,
                                //               yuvaUserList:
                                //                   model.yuvaUsersList!)));
                                // },
                              ),
                            if (int.parse(model.yuvaUser!.roleId) <
                                5) // restricted booth in charge
                              IconCard(
                                  title: "My Team",
                                  icon: "assets/iyc_icons/customer.png",
                                  onTap: () => toPage(
                                      context,
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              YuvaUsersListVM(),
                                          child: YuvaUsersList(
                                              roleId:
                                                  model.yuvaUser?.roleId)))),

                            // if (["3", "4"].contains(model.yuvaUser!.roleId))
                            //   IconCard(
                            //     title: "Add Booth In Charge",
                            //     icon:
                            //         "assets/iyc_icons/system-administrator.png",
                            //     onTap: () {
                            //       toPage(
                            //           context,
                            //           ChangeNotifierProvider(
                            //               create: (context) => AddYuvaUserVM(),
                            //               child: AddYuvaUser(
                            //                 yuvaUser: model.yuvaUser!,
                            //                 yuvaUserList: model.yuvaUsersList!,
                            //                 roleId: "4",
                            //
                            //                 /// for adding booth in charge
                            //               )));
                            //     },
                            //   ),
                            // if (["3", "4"].contains(model.yuvaUser!.roleId))
                            //   IconCard(
                            //       title: "View Booth in Charge",
                            //       icon: "assets/iyc_icons/customer.png",
                            //       onTap: () => toPage(
                            //           context,
                            //           ChangeNotifierProvider(
                            //               create: (context) =>
                            //                   YuvaUsersListVM(),
                            //               child: YuvaUsersList()))),

                            // Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Expanded(
                            //         flex: 1,
                            //         child: IycIconButton(
                            //           title: context
                            //               .read<YuvaBoothHomeVM>()
                            //               .getAppbarName(
                            //                   model.yuvaUser!.roleId),
                            //           onTap: () {
                            //             toPage(
                            //                 context,
                            //                 ChangeNotifierProvider(
                            //                     create: (context) =>
                            //                         AddYuvaUserVM(),
                            //                     child: AddYuvaUser(
                            //                         yuvaUser: model.yuvaUser!,
                            //                         yuvaUserList:
                            //                             model.yuvaUsersList!)));
                            //           },
                            //         ),
                            //       ),
                            //       Expanded(
                            //           flex: 1,
                            //           child: IycIconButton(
                            //               title: "View",
                            //               onTap: () => toPage(
                            //                   context,
                            //                   ChangeNotifierProvider(
                            //                       create: (context) =>
                            //                           YuvaUsersListVM(),
                            //                       child: YuvaUsersList()))))
                            //     ]),
                            if (model.yuvaUser?.roleId == "3")
                              IconCard(
                                  title: "Add Meeting FeedBack",
                                  icon: "assets/iyc_icons/feedback.png",
                                  onTap: () {
                                    toPage(
                                        context,
                                        ChangeNotifierProvider(
                                            create: (context) =>
                                                AddYuvaDataMeetingVM(),
                                            child: AddYuvaData(
                                                yuvaUser: model.yuvaUser!,
                                                yuvaUsersList:
                                                    model.yuvaUsersList!)));
                                  }),
                            // IycIconButton(
                            //   title: "Add Meeting FeedBack",
                            //   onTap: () {
                            //     toPage(
                            //         context,
                            //         ChangeNotifierProvider(
                            //             create: (context) =>
                            //                 AddYuvaDataMeetingVM(),
                            //             child: AddYuvaData(
                            //                 yuvaUser: model.yuvaUser!,
                            //                 yuvaUsersList:
                            //                     model.yuvaUsersList!)));
                            //   },
                            // ),

                            // IconCard(
                            //     title: "Booth Jodo",
                            //     icon: "assets/iyc_icons/add-user.png",
                            //     onTap: () {
                            //       toPage(
                            //           context,
                            //           ChangeNotifierProvider(
                            //               create: (context) => AddBoothJodoVM(),
                            //               child: AddBoothJodo(
                            //                   yuvaUser: model.yuvaUser!,
                            //                   yuvaUserList:
                            //                       model.yuvaUsersList!)));
                            //     }),
                            // IycIconButton(
                            //     title: "Booth Jodo",
                            //     onTap: () {
                            //       toPage(
                            //           context,
                            //           ChangeNotifierProvider(
                            //               create: (context) => AddBoothJodoVM(),
                            //               child: AddBoothJodo(
                            //                   yuvaUser: model.yuvaUser!,
                            //                   yuvaUserList:
                            //                       model.yuvaUsersList!)));
                            //     }),
                            IconCard(
                                title: "View Booth Jodo",
                                icon: "assets/iyc_icons/friendlist.png",
                                onTap: () {
                                  toPage(
                                      context,
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              ViewBoothJodoVM(),
                                          child: ViewBoothJodo()));
                                }),
                            model.isLoadingObAccess
                                ? CircularProgressIndicator()
                                : model.showObAccess
                                    ? IconCard(
                                        title: "OB",
                                        icon:
                                            "assets/iyc_icons/meeting-point.png",
                                        onTap: () async {
                                          toPage(context, NobHome());
                                        })
                                    : SizedBox(),

                            IconCard(
                                title: "Reports",
                                icon: "assets/iyc_icons/report.png",
                                onTap: () async {
                                  toPage(context, UserReports());
                                })
                            // IycIconButton(
                            //     title: "View Booth Jodo",
                            //     onTap: () {
                            //       toPage(
                            //           context,
                            //           ChangeNotifierProvider(
                            //               create: (context) =>
                            //                   ViewBoothJodoVM(),
                            //               child: ViewBoothJodo()));
                            //     })
                          ],
                        )
                      ],
                    )),
    );
  }
}
