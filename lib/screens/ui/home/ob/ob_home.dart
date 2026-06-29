import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iyc/screens/ui/home/ob/ecternal_training.dart';
import 'package:iyc/screens/widgets/cards/icon_card.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/ob/checkin_page_vm.dart';
import 'package:iyc/view_model/ob/events_vm.dart';
import 'package:iyc/view_model/ob/external_training_vm.dart';
import 'package:provider/provider.dart';

import 'checkin_page.dart';
import 'events_page.dart';

class NobHome extends StatefulWidget {
  const NobHome({Key? key}) : super(key: key);

  @override
  State<NobHome> createState() => _NobHomeState();
}

class _NobHomeState extends State<NobHome> {
  String description = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OB"),
        centerTitle: true,
      ),
      body: Center(
        child: Wrap(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconCard(
                title: "Check IN",
                icon: "assets/iyc_icons/check-in.png",
                onTap: () {
                  toPage(
                      context,
                      ChangeNotifierProvider(
                        create: (_) => CheckInPageVM(),
                        child: CheckInPage(),
                      ));
                }),
            IconCard(
                title: "Meetings",
                icon: "assets/iyc_icons/round-table.png",
                onTap: () {
                  toPage(
                      context,
                      CalendarControllerProvider(
                          controller: EventController(),
                          child: ChangeNotifierProvider(
                              create: (context) => EventsVM(),
                              child: EventsPage())));
                }),
            IconCard(
                title: "External Training",
                icon: "assets/images/externalelections.png",
                onTap: () {
                  toPage(
                      context,
                      ChangeNotifierProvider(
                          create: (context) => ExternalTrainingVM(),
                          child: ExternalTraining()));
                })
          ],
        ),
      ),
    );
  }
}
