import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/reports/booth_jodo_report_model.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/report/campaign_report_vm.dart';
import 'package:provider/provider.dart';

class CampaignReport extends StatefulWidget {
  const CampaignReport({Key? key}) : super(key: key);

  @override
  State<CampaignReport> createState() => _CampaignReportState();
}

class _CampaignReportState extends State<CampaignReport> {
  void initState() {
    context.read<CampaignReportVM>().initCampaign('');
    context.read<CampaignReportVM>().getReports(context, '');
    context
        .read<CampaignReportVM>()
        .controller
        .addListener(context.read<CampaignReportVM>().onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    context.read<CampaignReportVM>().controller.dispose();
    context.read<CampaignReportVM>().controller1.dispose();
    context.read<CampaignReportVM>().debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CampaignReportVM>(
          builder: (_, model, __) => CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Text("Campaign Report"),
                    pinned: true,
                    bottom: PreferredSize(
                        child: Container(
                          color: Colors.white,
                          child: Consumer<CampaignReportVM>(
                            builder: (_, model, __) => Column(
                              children: [
                                DropDownPicker(
                                  currentValue: model.selectedReportType,
                                  height: 55,
                                  listValues: model.reportTypeList,
                                  onChanged: (val) => context
                                      .read<CampaignReportVM>()
                                      .changeReportType(val, context),
                                  labelText: "",
                                  hintText: "",
                                ),
                                model.selectedReportType == '1'
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: TextFormField(
                                          controller: model.controller1,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(15),
                                            border: InputBorder.none,
                                            hintText:
                                                'Search',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            // hintStyle: TextStyle(color: Constants.themeGradientsMain[0],fontWeight: FontWeight.w400),
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                  color: Constants
                                                      .themeGradients[0],
                                                  width: 1),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                  color: Constants
                                                      .themeGradients[0]),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.deepOrange),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                  color: Constants
                                                      .themeGradients[0]),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            model.onSearchByName(value);
                                          },
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: TextFormField(
                                          controller: model.controller,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(15),
                                            border: InputBorder.none,
                                            hintText: 'Search',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            // hintStyle: TextStyle(color: Constants.themeGradientsMain[0],fontWeight: FontWeight.w400),
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                  color: Constants
                                                      .themeGradients[0],
                                                  width: 1),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                  color: Constants
                                                      .themeGradients[0]),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.deepOrange),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                  color: Constants
                                                      .themeGradients[0]),
                                            ),
                                          ),
                                          // onChanged: (value) {
                                          //   model.onSearchByName(value);
                                          // },
                                        ),
                                      ),
                                model.selectedReportType == '1'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              " State",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade800),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'District',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade800),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Assembly',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade800),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Total',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              " State",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade800),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'District',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade800),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Assembly',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade800),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Name',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Total',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                        preferredSize: Size(0.00, 150)),
                  ),
                  model.loadingPage
                      ? SliverToBoxAdapter(child: NetworkLoading())
                      : model.boothJodoReportList.isNotEmpty
                          ? (model.controller.text.length > 2 || model.controller1.text.length > 2)
                              ? model.boothJodoReportListByName.isEmpty
                                  ? SliverToBoxAdapter(
                                      child: Center(
                                        child: Text("No Reports found "),
                                      ),
                                    )
                                  : SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          (context, index) =>
                                              BoothJodoReportCard(
                                                report: model
                                                        .boothJodoReportListByName[
                                                    index],
                                                reportType:
                                                    model.selectedReportType,
                                              ),
                                          childCount: model
                                              .boothJodoReportListByName
                                              .length),
                                    )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) => BoothJodoReportCard(
                                            report: model
                                                .boothJodoReportList[index],
                                            reportType:
                                                model.selectedReportType,
                                          ),
                                      childCount:
                                          model.boothJodoReportList.length),
                                )
                          : SliverToBoxAdapter(
                              child: Center(
                                child: Text("No Reports found "),
                              ),
                            )
                ],
              )),
    );
  }
}

class BoothJodoReportCard extends StatelessWidget {
  const BoothJodoReportCard(
      {Key? key, required this.report, required this.reportType})
      : super(key: key);
  final BoothJodoReportModel report;
  final String reportType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.065,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.primaries[5].shade700)),
      child: reportType == "1"
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${report.stateCode ?? ""}",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Text(
                    "${report.districtName ?? ""}",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Text(
                    "${report.assemblyName ?? ""}",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Text(
                    "${report.total ?? ""}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                  flex: 1,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${report.stateCode ?? ""}",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Text(
                    "${report.districtName ?? ""}",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Text(
                    "${report.assemblyName ?? ""}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Text(
                    "${report.name ?? ""}",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Text("${report.total ?? ""}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold)),
                  flex: 1,
                ),
              ],
            ),
    );
  }
}

class SectionHeaderDelegate extends StatelessWidget {
  final double height;
  final String reportType;

  SectionHeaderDelegate(this.reportType, [this.height = 50]);

  @override
  Widget build(context) {
    return Container(
      color: Theme.of(context).primaryColor,
      alignment: Alignment.center,
      child: reportType == "1"
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'State',
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Assembly',
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Total',
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Verified",
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )
          : reportType == "2"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'State',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Assembly',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Member',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Total',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Verified",
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'State',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    // Expanded(
                    //   flex: 2,
                    //   child: Text(
                    //     'District Name',
                    //     style: TextStyle(
                    //         color: Colors.black45,
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w700),
                    //   ),
                    // ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Assembly Name',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Member name",
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Total',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
