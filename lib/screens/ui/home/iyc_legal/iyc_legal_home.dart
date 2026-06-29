import 'package:flutter/material.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/iyc_legal/iyc_legal_home_vm.dart';
import 'package:provider/provider.dart';

class IycLegalHome extends StatefulWidget {
  const IycLegalHome({Key? key}) : super(key: key);

  @override
  State<IycLegalHome> createState() => _IycLegalHomeState();
}

class _IycLegalHomeState extends State<IycLegalHome> {
  @override
  void initState() {
    context.read<IycLegalHomeVM>().getLegalCellList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Legal Cell"),
          centerTitle: true,
        ),
        body: Consumer<IycLegalHomeVM>(
          builder: (_, model, __) => model.isLoadingLegalCell
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : model.legalCellList.isEmpty
                  ? Center(
                      child: Text("No Members available"),
                    )
                  : ListView.builder(
                      itemCount: model.legalCellList.length,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      itemBuilder: (context, index) => ExpansionTile(
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        expandedAlignment: Alignment.centerLeft,
                        title: Text(
                            model.legalCellList[index].firstName +
                                " " +
                                model.legalCellList[index].lastName,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                        subtitle: Text(
                          "ID:" + model.legalCellList[index].memberId,
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, bottom: 20),
                            child: Text(
                              "Bar Council ID : " +
                                  model.legalCellList[index].barCouncilId,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Status : " +
                                  model.legalCellList[index].paymentStatus,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          )
                        ],
                      ),
                    ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: URoundButton(
          title: "Add Member",
          onTap: () => context.read<IycLegalHomeVM>().onTapAddMember(context),
          color: Constants.themeGradients[0],
          labelColor: Constants.themeGradients[1],
          svgIcon: "assets/icons/plus_icon.svg",
          width: MediaQuery.of(context).size.width * 0.44,
        ));
  }
}
