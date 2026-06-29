import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constants.dart';
import '../../../../view_model/ro_access/ro_home_vm.dart';
import '../../../widgets/u_round_edge_container.dart';

class RoAccessHome extends StatefulWidget {
  const RoAccessHome({Key? key}) : super(key: key);

  @override
  State<RoAccessHome> createState() => _RoAccessHomeState();
}

class _RoAccessHomeState extends State<RoAccessHome> {
  late TextEditingController mobileId;

  @override
  void initState() {
    context.read<RoHomeVM>().getRoDetails(context);
    mobileId = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RO Access Home"),
      ),
      body: Consumer<RoHomeVM>(
        builder: (_, model, __) => model.loadingPage
            ? NetworkLoading()
            : model.showRoSearch
                ? Column(
                    children: [
                      PreferredSize(
                        preferredSize: Size(0.0, 85.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Constants.themeGradients[1],
                          padding: EdgeInsets.only(
                            top: 3,
                          ),
                          child: Row(children: [
                            URoundEdgeContainer(
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: TextField(
                                  controller: mobileId,
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (str) {
                                    context
                                        .read<RoHomeVM>()
                                        .searchRoPaymentStatus(context, str);
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Constants.kitThemeGradients[0],
                                      ),
                                      hintText: "Search eg: 9999900000"),
                                )),
                            // IconButton(
                            //   onPressed: () {},
                            //   icon: Image.asset(
                            //     "assets/icons/reload.svg",
                            //     color: Constants.themeGradients[0],
                            //   ),
                            // )
                          ]),
                        ),
                      ),
                      Expanded(
                          child: model.batchMapList.isNotEmpty
                              ? ListView.builder(
                                  itemCount: model.batchMapList.length,
                                  itemBuilder: (context, index) => Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Card(
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(children: [
                                              buildLabelAndContent(
                                                  "BATCH ID",
                                                  model.batchMapList[index]
                                                      ["batch_no"]),
                                              buildLabelAndContent(
                                                  "PAYMENT ID",
                                                  model.batchMapList[index]
                                                      ["payment_id"]),
                                              buildLabelAndContent(
                                                  "CREATED ON",
                                                  DateFormat("dd-MM-y")
                                                      .format(DateTime.parse(
                                                          model.batchMapList[
                                                                  index]
                                                              ["created_on"]))
                                                      .toString()),
                                              buildLabelAndContent(
                                                  "PAYMENT STATUS",
                                                  model.batchMapList[index]
                                                      ["payment_status"]),
                                            ]),
                                          ),
                                        ),
                                      ))
                              : Center(child: Text("NO RO Access List")))
                    ],
                  )
                : SizedBox.expand(
                    child: Center(child: Text(" RO Access Disabled"))),
      ),
    );
  }

  Padding buildLabelAndContent(String label, String content) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(label,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Constants.themeTextGradients[1],
                        fontSize: 14))),
          ),
          Text(":"),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.center,
              child: Text(content,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 14),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
