import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/reports/booth_jodo_report_model.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/report/booth_jodo_report_vm.dart';
import 'package:provider/provider.dart';

class BoothJodoReport extends StatefulWidget {
  const BoothJodoReport({Key? key}) : super(key: key);

  @override
  State<BoothJodoReport> createState() => _BoothJodoReportState();
}

class _BoothJodoReportState extends State<BoothJodoReport> {
  @override
  void initState() {
    context.read<BoothJodoReportVM>().getReports(context);
    context
        .read<BoothJodoReportVM>()
        .controller
        .addListener(context.read<BoothJodoReportVM>().onSearchChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BoothJodoReportVM>(
          builder: (_, model, __) => CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Text("Booth Jodo Report"),
                    pinned: true,
                    bottom: PreferredSize(
                        child: Container(
                          color: Colors.white,
                          child: Consumer<BoothJodoReportVM>(
                            builder: (_, model, __) => Column(
                              children: [
                                DropDownPicker(
                                  currentValue: model.selectedReportType,
                                  height: 55,
                                  listValues: model.reportTypeList,
                                  onChanged: (val) => context
                                      .read<BoothJodoReportVM>()
                                      .changeReportType(val, context),
                                  labelText: "",
                                  hintText: "",
                                ),
                              ],
                            ),
                          ),
                        ),
                        preferredSize: Size(0.00, 150)),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextFormField(
                        controller: model.controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey),
                          // hintStyle: TextStyle(color: Constants.themeGradientsMain[0],fontWeight: FontWeight.w400),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                                color: Constants.themeGradients[0], width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Constants.themeGradients[0]),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.deepOrange),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Constants.themeGradients[0]),
                          ),
                        ),
                        onChanged: (value) {
                          model.onSearchByName(value);
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SectionHeaderDelegate(model.selectedReportType!),
                  ),
                  model.loadingPage
                      ? SliverToBoxAdapter(child: NetworkLoading())
                      : model.boothJodoReportList.isNotEmpty
                          ? model.boothJodoReportSearchList.isNotEmpty
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) => BoothJodoReportCard(
                                            report:
                                                model.boothJodoReportSearchList[
                                                    index],
                                          ),
                                      childCount: model
                                          .boothJodoReportSearchList.length),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) => BoothJodoReportCard(
                                            report: model
                                                .boothJodoReportList[index],
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
  const BoothJodoReportCard({Key? key, required this.report}) : super(key: key);
  final BoothJodoReportModel report;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.065,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.primaries[5].shade700)),
      child: Row(
        children: [
          if (report.name != null && report.name!.isNotEmpty)
            Expanded(
              child: Text(
                "${report.name}",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800),
              ),
              flex: 2,
            ),
          Expanded(
            child: Text(
              "${report?.districtName ?? ""}",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800),
            ),
            flex: 2,
          ),
          Expanded(
            child: Text(
              "${report.assemblyName}",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            flex: 1,
          ),
          if (report.total != null)
            Expanded(
              child: Text("${report.total}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.deepOrange, fontWeight: FontWeight.bold)),
              flex: 1,
            ),
          Expanded(
            child: Text("${report.verifiedNumbers ?? report.boothCount}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.deepOrange, fontWeight: FontWeight.bold)),
            flex: 1,
          ),
          Expanded(
            child: Text("${report.verifiedBooth ?? report.memberCount}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.deepOrange, fontWeight: FontWeight.bold)),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (reportType == "2")
            Expanded(
              flex: 2,
              child: Text(
                'Name',
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
            ),
          Expanded(
            flex: 2,
            child: Text(
              'District Name',
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
          ),
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
          if (reportType != "3")
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
              reportType == "3" ? "Booth Number" : 'Verified Numbers',
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
              reportType == "3" ? "Member Count" : 'Booth Count',
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          )
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
