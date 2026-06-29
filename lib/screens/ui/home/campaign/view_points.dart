import 'package:flutter/material.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/view_model/yuva_booth/view_points_vm.dart';
import 'package:provider/provider.dart';

class ViewPoints extends StatefulWidget {
  const ViewPoints({Key? key}) : super(key: key);

  @override
  State<ViewPoints> createState() => _ViewPointsState();
}

class _ViewPointsState extends State<ViewPoints> {
  @override
  void initState() {
    context.read<ViewPointsVM>().getPoints(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("LeaderBoard"),
          centerTitle: true,
          bottom: PreferredSize(
              child: Container(
                color: Colors.white,
                child: Consumer<ViewPointsVM>(
                    builder: (_, model, __) => DropDownPicker(
                        currentValue: model.selectedLeaderBoard,
                        listValues: model.dropdownList,
                        onChanged: (val) {
                          context
                              .read<ViewPointsVM>()
                              .changeLeaderBoardType(val, context);
                        },
                        labelText: "Select Leader Board Type",
                        hintText: "Select Leader Board Type")),
              ),
              preferredSize: Size(MediaQuery.of(context).size.width, 80)),
        ),
        body: Consumer<ViewPointsVM>(
            builder: (_, model, __) => model.loadingPage
                ? NetworkLoading()
                : model.pointsList.isNotEmpty
                    ? ListView.builder(
                        itemCount: model.pointsList.length,
                        itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: ListTile(
                                title: Text(
                                    "${model.pointsList[index]["FIRST_NAME"]} ${model.pointsList[index]["LAST_NAME"]}"),
                                subtitle: Text(
                                    "${model.pointsList[index]["MOBILE"]}"),
                                trailing: Container(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                        "assets/iyc_icons/reward.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                      Text(
                                        "${model.pointsList[index]["VERIFIED_COUNT"]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                    : Center(
                        child: Text(" Leader Board is Empty"),
                      )));
  }
}
