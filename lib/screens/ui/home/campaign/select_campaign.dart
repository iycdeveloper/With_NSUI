import 'package:flutter/material.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/screens/widgets/button/iyc_icon_button.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/campaign/leaderboard_campaign_vm.dart';
import 'package:iyc/view_model/campaign/select_campaign_vm.dart';
import 'package:provider/provider.dart';

import 'leaderboard_campaign.dart';

class SelectCampaign extends StatefulWidget {
  const SelectCampaign({Key? key, this.isCampaignReport}) : super(key: key);

  final bool? isCampaignReport;

  @override
  State<SelectCampaign> createState() => _SelectCampaignState();
}

class _SelectCampaignState extends State<SelectCampaign> {
  @override
  void initState() {
    context.read<SelectCampaignVM>().getCampaignList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/iyc_logo.png",
          height: 50,
        ),
        centerTitle: true,
      ),
      body: Consumer<SelectCampaignVM>(
        builder: (context, model, __) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              model.isEnglish ? "Select a Campaign" : "ಅಭಿಯಾನ ಆಯ್ಕೆ ಮಾಡಿ",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            DropDownPicker(
                currentValue: model.selectedCampaign,
                listValues: model.campaignDropdownItems,
                onChanged: (val) => context
                    .read<SelectCampaignVM>()
                    .changeSelectedCampaign(val),
                labelText: "",
                hintText: model.isEnglish
                    ? "Choose your Campaign"
                    : "ನಿಮ್ಮ ಅಭಿಯಾನ ಸೂಚಿಸಿ"),
            SizedBox(
              width: 200,
              child: IycIconButton(
                  title: model.isEnglish ? "Select" : " ಆಯ್ಕೆ",
                  onTap: () async {
                    if (context.read<SelectCampaignVM>().selectedCampaign !=
                        null)
                      getRoute(context, widget.isCampaignReport ?? false);
                  }),
            ),
            model.showLeaderBoard
                ? SizedBox(
                    width: 200,
                    child: IycIconButton(
                        title: "Leaderboard",
                        onTap: () async {
                          if (context
                                  .read<SelectCampaignVM>()
                                  .selectedCampaign !=
                              null)
                            await toPage(
                                context,
                                ChangeNotifierProvider(
                                  create: (context) => LeaderboardCampaignVM(),
                                  child: LeaderboardCampaign(
                                      model.selectedCampaign!),
                                ));
                        }),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  // dynamic getRoute(BuildContext context, bool isCampaignReport) {
  //   switch (context.read<SelectCampaignVM>().selectedCampaign) {
  //     case "6":
  //       return isCampaignReport
  //           ? ChangeNotifierProvider(
  //           create: (context) => CampaignReportVM(),
  //           child: CampaignReport())
  //           : ChangeNotifierProvider(
  //         create: (context) => AddCampaignCgVM(),
  //         child: AddCampaignCg(
  //           campaignId:
  //           context.read<SelectCampaignVM>().selectedCampaign!,
  //         ),
  //       );
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
  //     case "4":
  //       return isCampaignReport
  //           ? ChangeNotifierProvider(
  //               create: (context) => CampaignReportVM(),
  //               child: CampaignReport())
  //           : ChangeNotifierProvider(
  //               create: (context) => AddCampaignMpVM(),
  //               child: AddCampaignMp(
  //                 campaignId:
  //                     context.read<SelectCampaignVM>().selectedCampaign!,
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
  //     case "8":
  //       RoutesManagement.goToHrCampaignScreen();
  //       return;
  //     case "9":
  //       RoutesManagement.goToRozgarNyayPatraScreen();
  //       return;
  //     case "11":
  //       RoutesManagement.goToHmCampaignScreen();
  //       return;
  //     case "12":
  //       RoutesManagement.goToNyayGuaranteeScreen();
  //       return;
  //     case "13":
  //       RoutesManagement.goToChCampaignScreen();
  //       return ;
  //     case "14":
  //       RoutesManagement.goToJhCampaignScreen();
  //       return ;
  //
  //       // return isCampaignReport
  //       //     ? ChangeNotifierProvider(
  //       //     create: (context) => CampaignReportVM(),
  //       //     child: CampaignReport())
  //       //     : ChangeNotifierProvider(
  //       //   create: (context) => NyayGuaranteeVM(),
  //       //   child: NyayGuaranteeCampaign(
  //       //     campaignId:
  //       //     context.read<SelectCampaignVM>().selectedCampaign!,
  //       //   ),
  //       // );
  //     case "8":
  //       return ChangeNotifierProvider(
  //         create: (context) => AddCampaignHrVM(),
  //         child: AddCampaignHr(
  //           campaignId: context.read<SelectCampaignVM>().selectedCampaign!,
  //         ),
  //       );
  //     case "10":
  //       return ChangeNotifierProvider(
  //         create: (context) => AddCampaignChVM(),
  //         child: AddCampaignCh(
  //           campaignId: context.read<SelectCampaignVM>().selectedCampaign!,
  //         ),
  //       );
  //     case "11":
  //       return ChangeNotifierProvider(
  //         create: (context) => AddCampaignHmVM(),
  //         child: AddCampaignHm(
  //           campaignId: context.read<SelectCampaignVM>().selectedCampaign!,
  //         ),
  //       );
  //
  //     default:
  //       CustomSnackBar.showErrorSnackBar(
  //           'Form not available please contact support. Make sure your app updated at latest version');
  //       return;
  //     // return isCampaignReport
  //     //     ? ChangeNotifierProvider(
  //     //         create: (context) => CampaignReportVM(),
  //     //         child: CampaignReport())
  //     //     : ChangeNotifierProvider(
  //     //         create: (context) => AddCampaignVM(),
  //     //         child: AddCampaign(
  //     //             campaignId:
  //     //                 context.read<SelectCampaignVM>().selectedCampaign!,
  //     //             isShimlaCampaign:
  //     //                 context.read<SelectCampaignVM>().selectedCampaign ==
  //     //                     "2"),
  //     //       );
  //   }
  // }

  void getRoute(BuildContext context, bool isCampaignReport) {
    switch (context.read<SelectCampaignVM>().selectedCampaign) {
      case "8":
        RoutesManagement.goToHrCampaignScreen(context.read<SelectCampaignVM>().title!);
        break;
      case "9":
        RoutesManagement.goToRozgarNyayPatraScreen(context.read<SelectCampaignVM>().title!);
        break;
      case "11":
        RoutesManagement.goToHmCampaignScreen(context.read<SelectCampaignVM>().title!);
        break;
      case "12":
        RoutesManagement.goToNyayGuaranteeScreen(context.read<SelectCampaignVM>().title!);
        break;
      case "13":
        RoutesManagement.goToChCampaignScreen(context.read<SelectCampaignVM>().title!);
        break;
      case "14":
        RoutesManagement.goToJhCampaignScreen(context.read<SelectCampaignVM>().title!);
        break ;
      case "15":
        RoutesManagement.goToChaloPanchayat();
        break ;
      case "16":
        RoutesManagement.goToUddanCampaign(context.read<SelectCampaignVM>().title!);
        break ;
      default:
        CustomSnackBar.showErrorSnackBar(
            'Form not available please contact support. Make sure your app updated at latest version');
        break;
    }
  }
}
//GestureDetector(
//                       onTap: model.selectedCampaign != null
//                           ? () async {
//                               await toPage(
//                                   context,
//                                   ChangeNotifierProvider(
//                                     create: (context) =>
//                                         LeaderboardCampaignVM(),
//                                     child: LeaderboardCampaign(
//                                         model.selectedCampaign!),
//                                   ));
//                             }
//                           : null,
//                       child: Text(
//                         "Leaderboard",
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.alata(
//                             fontSize: 20,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ))
