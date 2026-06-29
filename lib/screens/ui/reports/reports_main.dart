import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/report/reports_vm.dart';
import 'package:provider/provider.dart';

class ReportsMain extends StatefulWidget {
  const ReportsMain({
    Key? key,
  }) : super(key: key);

  @override
  State<ReportsMain> createState() => _ReportsMainState();
}

class _ReportsMainState extends State<ReportsMain> {
  @override
  void initState() {
    context.read<ReportsVM>().getReports(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: HomePageDrawer(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Constants.themeGradients[0],
        title: Text(
          "Reports",
          // "MB-005-00-16",
          style: Constants.appbarTitleTextStyle,
        ),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     size: 30,
        //     color: Colors.white,
        //   ),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      body: Consumer<ReportsVM>(
        builder: (_, model, __) => model.loadingPage
            ? const NetworkLoading()
            : model.reportList.isEmpty
                ? const Center(
                    child: Text("No reports available"),
                  )
                : ListView.builder(
                    itemCount: model.reportList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () => {},
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Card(
                              child: Row(children: [
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 1),
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        model.reportList[index].reportName!,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Constants
                                                  .themeTextGradients[1],
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 1),
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        model.reportList[index].module!,
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                URoundButton(
                                  onTap: () {
                                    context.read<ReportsVM>().downLoadReport(
                                        model.reportList[index].reportLink!,
                                        context);
                                  },
                                  title: "Download",
                                  height:
                                      MediaQuery.of(context).size.height / 14,
                                  width: MediaQuery.of(context).size.width / 4,
                                  color: Constants.themeGradients[1],
                                  labelColor: Constants.themeGradients[0],
                                ),
                              ]),
                            ),
                          ));
                    }),
      ),
    );
  }
}
