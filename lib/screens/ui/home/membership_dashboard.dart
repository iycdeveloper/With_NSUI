import 'package:flutter/material.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/provider/batch/batch_list_provider.dart';
import 'package:iyc/provider/membership_register/membership_api_providers/membership_list_provider.dart';
import 'package:iyc/provider/nomination/nominations_provider.dart';
import 'package:iyc/provider/scrutiny/scrutiny_batch_vm.dart';
import 'package:iyc/screens/ui/complaints/complaints_home.dart';
import 'package:iyc/screens/ui/membership_ui/batch/batch_main.dart';
import 'package:iyc/screens/ui/nominations/nominations_main.dart';
import 'package:iyc/screens/ui/reports/reports_main.dart';
import 'package:iyc/screens/ui/scrutiny/batch/scrutiny_batch_list.dart';
import 'package:iyc/screens/widgets/cards/icon_card.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/complaints/complaints_home_vm.dart';
import 'package:iyc/view_model/iyc_legal/iyc_legal_home_vm.dart';
import 'package:iyc/view_model/nomination/view_nomination_vm.dart';
import 'package:iyc/view_model/report/reports_vm.dart';
import 'package:provider/provider.dart';

import '../../../view_model/ro_access/ro_home_vm.dart';
import 'home_page_drawer.dart';
import 'iyc_legal/iyc_legal_home.dart';
import 'ro_access/ro_access_home.dart';

class MembershipDashboard extends StatefulWidget {
  const MembershipDashboard({Key? key}) : super(key: key);

  @override
  State<MembershipDashboard> createState() => _MembershipDashboardState();
}

class _MembershipDashboardState extends State<MembershipDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        drawer: HomePageDrawer(),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("Membership"),
        ),
        body: ListView(
          children: [
            Wrap(alignment: WrapAlignment.center, children: [
              IconCard(
                  onTap: () {
                    toPage(
                      context,
                      MultiProvider(providers: [
                        ChangeNotifierProvider(
                          create: (context) =>
                              NominationsProvider(apiConfig: sl<ApiConfig>()),
                        ),
                        ChangeNotifierProvider(
                            create: (context) => ViewNominationVm())
                      ], child: NominationsMain()),
                    );
                  },
                  title: "Nomination",
                  icon: "assets/iyc_icons/nomination.png"),
              IconCard(
                  onTap: () {
                    toPage(
                      context,
                      MultiProvider(providers: [
                        ChangeNotifierProvider(
                          create: (context) => sl<MembershipListProvider>(),
                        ),
                        ChangeNotifierProvider(
                          create: (context) =>
                              BatchListProvider(apiConfig: sl()),
                        ),
                      ], child: BatchMain()),
                    );
                  },
                  title: "Membership",
                  icon: "assets/iyc_icons/membership-card.png"),
              IconCard(
                  onTap: () async {
                    toPage(
                        context,
                        MultiProvider(providers: [
                          ChangeNotifierProvider(
                            create: (context) => ScrutinyBatchVM(
                                scrutinyRepo: sl(), apiConfig: sl()),
                          )
                        ], child: ScrutinyBatchList()));
                  },
                  title: "Scrutiny",
                  icon: "assets/iyc_icons/scrutiny.png"),
              IconCard(
                  onTap: () async {
                    toPage(
                        context,
                        MultiProvider(providers: [
                          ChangeNotifierProvider(
                            create: (context) => ComplaintsHomeVM(),
                          )
                        ], child: ComplaintsHome()));
                  },
                  title: "Complaints",
                  icon: "assets/iyc_icons/complain.png"),
              IconCard(
                  onTap: () {
                    toPage(
                        context,
                        ChangeNotifierProvider(
                          create: (context) => ReportsVM(),
                          child: ReportsMain(),
                        ));
                  },
                  title: "Reports",
                  icon: "assets/iyc_icons/report.png"),
              IconCard(
                  onTap: () async {
                    toPage(
                        context,
                        MultiProvider(providers: [
                          ChangeNotifierProvider(
                            create: (context) => RoHomeVM(),
                          )
                        ], child: RoAccessHome()));
                  },
                  title: "RO Access",
                  icon: "assets/iyc_icons/cfo.png"),
              IconCard(
                  onTap: () async {
                    toPage(
                        context,
                        MultiProvider(providers: [
                          ChangeNotifierProvider(
                            create: (context) => IycLegalHomeVM(),
                          )
                        ], child: IycLegalHome()));
                  },
                  title: "Legal Cell",
                  icon: "assets/iyc_icons/lawyer.png"),
            ]),
          ],
        ));
  }
}
