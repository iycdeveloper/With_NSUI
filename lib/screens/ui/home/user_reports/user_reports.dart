import 'package:flutter/material.dart';
import 'package:iyc/screens/ui/home/campaign/add_campaign.dart';
import 'package:iyc/screens/ui/home/campaign/add_campaign_cg.dart';
import 'package:iyc/screens/ui/home/campaign/add_campaign_mp.dart';
import 'package:iyc/screens/ui/home/campaign/add_campaign_rj.dart';
import 'package:iyc/screens/ui/home/campaign/add_campaign_tl.dart';
import 'package:iyc/screens/ui/home/campaign/select_campaign.dart';
import 'package:iyc/screens/ui/home/user_reports/booth_jodo_report.dart';
import 'package:iyc/screens/ui/home/user_reports/campaign_report.dart';
import 'package:iyc/screens/widgets/cards/icon_card.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/campaign/add_campaign_cg_vm.dart';
import 'package:iyc/view_model/campaign/add_campaign_mp_vm.dart';
import 'package:iyc/view_model/campaign/add_campaign_rj_vm.dart';
import 'package:iyc/view_model/campaign/add_campaign_vm.dart';
import 'package:iyc/view_model/campaign/add_campain_tl_vm.dart';
import 'package:iyc/view_model/campaign/select_campaign_vm.dart';
import 'package:iyc/view_model/report/booth_jodo_report_vm.dart';
import 'package:iyc/view_model/report/campaign_report_vm.dart';
import 'package:iyc/view_model/yuva_booth/search_voters_list_vm.dart';
import 'package:provider/provider.dart';

class UserReports extends StatefulWidget {
  const UserReports({Key? key}) : super(key: key);

  @override
  State<UserReports> createState() => _UserReportsState();
}

class _UserReportsState extends State<UserReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
      ),
      body: Center(
          child: Row(
        children: [
          IconCard(
            title: "Booth Jodo Report",
            icon: "assets/iyc_icons/report.png",
            onTap: () {
              toPage(
                  context,
                  ChangeNotifierProvider(
                      create: (context) => BoothJodoReportVM(),
                      child: BoothJodoReport()));
            },
          ),
          IconCard(
            title: "Campaign Report",
            icon: "assets/iyc_icons/report.png",
            onTap: () async {
              // await toPage(context,
              // getRoute(context, true));
              // toPage(
              //     context,
              //     ChangeNotifierProvider(
              //         create: (context) => SelectCampaignVM(),
              //         child: getRoute(context, true)));
              toPage(
                  context,
                  ChangeNotifierProvider(
                      create: (context) => CampaignReportVM(),
                      child: CampaignReport()));
            },
          ),
        ],
      )),
    );
  }

  // Widget getRoute(BuildContext context, bool isCampaignReport) {
  //   switch (context.read<SelectCampaignVM>().selectedCampaign) {
  //     case "6":
  //       return isCampaignReport
  //           ? ChangeNotifierProvider(
  //               create: (context) => CampaignReportVM(),
  //               child: CampaignReport())
  //           : ChangeNotifierProvider(
  //               create: (context) => AddCampaignCgVM(),
  //               child: AddCampaignCg(
  //                 campaignId:
  //                     context.read<SelectCampaignVM>().selectedCampaign!,
  //               ),
  //             );
  //     case "7":
  //       return isCampaignReport
  //           ? ChangeNotifierProvider(
  //               create: (context) => CampaignReportVM(),
  //               child: CampaignReport())
  //           : ChangeNotifierProvider(
  //               create: (context) => AddCampaignRjVM(),
  //               child: AddCampaignRj(
  //                 campaignId:
  //                     context.read<SelectCampaignVM>().selectedCampaign!,
  //               ),
  //             );
  //
  //     case "4":
  //       return isCampaignReport
  //           ? ChangeNotifierProvider(
  //               create: (context) => CampaignReportVM(),
  //               child: CampaignReport())
  //           : ChangeNotifierProvider(
  //               create: (context) => SearchVotersListVM(),
  //               child: ChangeNotifierProvider(
  //                 create: (context) => AddCampaignMpVM(),
  //                 child: AddCampaignMp(
  //                   campaignId:
  //                       context.read<SelectCampaignVM>().selectedCampaign!,
  //                 ),
  //               ),
  //             );
  //     case "5":
  //       return isCampaignReport
  //           ? ChangeNotifierProvider(
  //               create: (context) => CampaignReportVM(),
  //               child: CampaignReport())
  //           : ChangeNotifierProvider(
  //               create: (context) => AddCampaignTLVM(),
  //               child: AddCampaignTL(
  //                 campaignId:
  //                     context.read<SelectCampaignVM>().selectedCampaign!,
  //                 isShimlaCampaign: false,
  //               ),
  //             );
  //
  //     default:
  //       return isCampaignReport
  //           ? ChangeNotifierProvider(
  //               create: (context) => CampaignReportVM(),
  //               child: CampaignReport())
  //           : ChangeNotifierProvider(
  //               create: (context) => AddCampaignVM(),
  //               child: AddCampaign(
  //                   campaignId:
  //                       context.read<SelectCampaignVM>().selectedCampaign!,
  //                   isShimlaCampaign:
  //                       context.read<SelectCampaignVM>().selectedCampaign ==
  //                           "2"),
  //             );
  //   }
  // }
}
