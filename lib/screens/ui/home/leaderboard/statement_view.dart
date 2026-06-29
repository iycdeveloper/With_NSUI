import 'package:flutter/material.dart';
import 'package:iyc/view_model/leaderboard/statement_vm.dart';
import 'package:provider/provider.dart';

class StatementView extends StatefulWidget {
  const StatementView({Key? key}) : super(key: key);

  @override
  State<StatementView> createState() => _StatementViewState();
}

class _StatementViewState extends State<StatementView> {
  @override
  void initState() {
    context.read<StatementVM>().initPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatementVM>(
      builder: (_, model, __) => Scaffold(
        appBar: AppBar(
          title: Text('Statement'),
          actions: [
            Center(
                child: Row(
              children: [
                InkWell(
                  onTap: () {
                    model.showDropdown(context);
                  },
                  child: Row(
                    children: [
                      Text(
                        'M: ${model.selectedMonth}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    model.showDropdownYear(context);
                  },
                  child: Row(
                    children: [
                      Text(
                        'Y: ${model.selectedYear}  ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ),
              ],
            ))
          ],
        ),
        body: model.pointStatement == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                scrollDirection: Axis.vertical,
                children: [
                  DataTable(
                      columns: [
                        DataColumn(label: Text('Date Time')),
                        DataColumn(label: Text('Point category')),
                        DataColumn(label: Text('Points')),
                      ],
                      rows: List.generate(
                        model.pointStatement!.length,
                            (index){
                          print(model.pointStatement!.length);
                          return DataRow(cells: [
                            DataCell(Text(
                                '${model.pointStatement![index]['date_time']}'
                                    .substring(0, 16))),
                            DataCell(Text(
                                model.pointStatement![index]['point_category'])),
                            DataCell(Text(model.pointStatement![index]['point'])),
                          ]);
                        },
                      )),
                ],
              ),
      ),
    );
  }
}
