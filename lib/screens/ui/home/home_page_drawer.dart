import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iyc/provider/auth/auth_api_provider.dart';
import 'package:iyc/screens/ui/home/profile/my_profile.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/profile/profile_vm.dart';
import 'package:provider/provider.dart';

import '../../widgets/drawer/drawer_item_with_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({Key? key}) : super(key: key);

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
          child: ListView(
        children: [
          ListTile(
            tileColor: Constants.themeGradients[0],
          ),
          DrawerItemSvg.png(
            onTap: () async {
              toPage(
                  context,
                  ChangeNotifierProvider(
                    create: (context) => ProfileVm(),
                    child: MyProfile(),
                  ));
            },
            iconData: "assets/images/profile.png",
            labelName: "My Profile",
          ),
          // Consumer<HomePageDashboardVM>(
          //   builder: (_, model, __) =>
          //       ['PB', 'CG'].contains(model.yuvaUser!.stateCode)
          //           ? DrawerItemSvg.png(
          //               onTap: () async {
          //                 toPage(
          //                     context,
          //                     ChangeNotifierProvider(
          //                       create: (context) => RewardsVm(),
          //                       child: MyRewards(),
          //                     ));
          //               },
          //               iconData: "assets/images/rewards.png",
          //               labelName: "My Rewards",
          //             )
          //           : SizedBox(),
          // ),
          // DrawerItemSvg.png(
          //   onTap: () async {
          //     toPage(
          //         context,
          //         ChangeNotifierProvider(
          //           create: (context) => RewardsVm(),
          //           child: MyRewards(),
          //         )
          //
          //     );
          //   },
          //   iconData: "assets/iyc_icons/user.png",
          //   labelName: "My Activities",
          // ),
          //
          // ........................................... my Rewards
          //
          // DrawerItemSvg.png(
          //   onTap: () async {
          //     toPage(context, UserReports());
          //   },
          //   iconData: "assets/iyc_icons/report.png",
          //   labelName: "Reports",
          // ),
          // DrawerItemSvg.png(
          //   onTap: () async {
          //     toPage(
          //         context,
          //         ChangeNotifierProvider(
          //             create: (context) => LeaderBoardListVM(),
          //             child: LeaderBoardList()));
          //   },
          //   iconData: "assets/iyc_icons/board.png",
          //   labelName: "LeaderBoard",
          // ),
          DrawerItemSvg.png(
            onTap: () async {
              _makePhoneCall("9481959178");
            },
            iconData: "assets/iyc_icons/technical-support.png",
            labelName: "Support (Mon-Sat 9AM-6PM )",
          ),
          // DrawerItemSvg(
          //   onTap: () async {
          //     toPage(
          //         context,
          //         MultiProvider(providers: [
          //           ChangeNotifierProvider(
          //             create: (context) =>
          //                 ScrutinyBatchVM(scrutinyRepo: sl(), apiConfig: sl()),
          //           )
          //         ], child: ScrutinyBatchList()));
          //   },
          //   iconData: "assets/icons/scrutiny_icon.svg",
          //   labelName: "Scrutiny",
          // ),
          // DrawerItemSvg(
          //   onTap: () async {
          //     toPage(
          //         context,
          //         MultiProvider(providers: [
          //           ChangeNotifierProvider(
          //             create: (context) => ComplaintsHomeVM(),
          //           )
          //         ], child: ComplaintsHome()));
          //   },
          //   iconData: 'assets/icons/noun_complaint.svg',
          //   labelName: "Complaints",
          // ),
          // DrawerItemSvg(
          //   onTap: () async {
          //     toPage(
          //         context,
          //         MultiProvider(providers: [
          //           ChangeNotifierProvider(
          //             create: (context) => RoHomeVM(),
          //           )
          //         ], child: RoAccessHome()));
          //   },
          //   iconData: 'assets/icons/noun_complaint.svg',
          //   labelName: "RO Access",
          // ),
          // DrawerItemSvg(
          //   onTap: () async {
          //     toPage(
          //         context,
          //         MultiProvider(providers: [
          //           ChangeNotifierProvider(
          //             create: (context) => YuvaBoothHomeVM(),
          //           )
          //         ], child: YuvaBoothHome()));
          //   },
          //   iconData: 'assets/icons/noun_complaint.svg',
          //   labelName: "Election Management",
          // ),
          // DrawerItemSvg(
          //   onTap: () async {
          //     toPage(context, NobHome());
          //   },
          //   iconData: 'assets/icons/noun_complaint.svg',
          //   labelName: "OB",
          // ),
          // DrawerItemSvg(
          //   onTap: () async {
          //     toPage(
          //         context,
          //         MultiProvider(providers: [
          //           ChangeNotifierProvider(
          //             create: (context) => IycLegalHomeVM(),
          //           )
          //         ], child: IycLegalHome()));
          //   },
          //   iconData: 'assets/icons/noun_complaint.svg',
          //   labelName: "Legal Cell",
          // ),
          DrawerItemSvg.png(
            onTap: () async {
              context.read<AuthApiProvider>().logout(context: context);
            },
            iconData: "assets/iyc_icons/check-out.png",
            labelName: "Logout",
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "version ${AppConstants.versionName}",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          // if (kDebugMode)
          //   DrawerItemSvg(
          //     onTap: () async {
          //       final Address? result = await toPage(context, ApiTestPage());
          //       print(result?.formattedAddress);
          //     },
          //     iconData: 'assets/icons/noun_complaint.svg',
          //     labelName: "Test API page",
          //   ),
        ],
      )),
    );
  }
}
