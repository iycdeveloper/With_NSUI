import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/yuva_user/yuva_users_model.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/dropdown/state_picker_dropdown.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/yuva_booth/yuva_users_list_vm.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class YuvaUsersList extends StatefulWidget {
  const YuvaUsersList({Key? key, required this.roleId}) : super(key: key);
  final String? roleId;

  @override
  State<YuvaUsersList> createState() => _YuvaUsersListState();
}

class _YuvaUsersListState extends State<YuvaUsersList> {
  @override
  void initState() {
    context.read<YuvaUsersListVM>().getYuvaUsers(context);
    context.read<YuvaUsersListVM>().init(widget.roleId, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<YuvaUsersListVM>(
      builder: (_, model, __) =>Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Constants.themeGradients[0],
            title: Text("Users List"),
            // actions: [
            //   IconButton(onPressed: () async {
            //     await showDialog<void>(
            //     context: context,
            //     builder: (BuildContext context) {
            //     return SimpleDialog(
            //     title: const Text('Select Role Type'),
            //     children: model.generateDialogOptions(
            //     context, widget.roleId!),
            //     );
            //     });
            //   }, icon: Icon(Icons.add))
            // ],
          ),
          body: Consumer<YuvaUsersListVM>(
              builder: (_, model, __) => CustomScrollView(
                    slivers: [
                      if (model.roleId == "1")
                        SliverToBoxAdapter(
                          child: StatePickerDropDown(
                            currentState: model.selectedState,
                            selectedState: model.selectedStateName,
                            stateList: model.stateList,
                            // viewOnly: model.enableDistrictEdit,
                            onChanged: (value) {
                              context.read<YuvaUsersListVM>().changeSelectedState(
                                  context
                                      .read<YuvaUsersListVM>()
                                      .stateList!
                                      .singleWhere((element) =>
                                          element.stateCode == value),
                                  context);
                            },
                            onTap: () {},
                          ),
                        ),
                      model.loadingPage
                          ? SliverToBoxAdapter(child: NetworkLoading())
                          : model.yuvaUsersList.isNotEmpty
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) => YuvaListCard(
                                            yuvaUsersModel:
                                                model.yuvaUsersList[index],
                                            assemblyList: model.assemblyList,
                                            districtList: model.districtList,
                                          )))
                              : SliverToBoxAdapter(
                                  child: Center(
                                    child: Text("No Yuva Users found create new"),
                                  ),
                                )
                    ],
                  ))),
    );
  }
}

class YuvaListCard extends StatelessWidget {
  final YuvaUsersModel yuvaUsersModel;
  final List<Districts> districtList;
  final List<Assembly> assemblyList;

  const YuvaListCard(
      {Key? key,
      required this.yuvaUsersModel,
      required this.districtList,
      required this.assemblyList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow()],
          borderRadius: BorderRadius.circular(5),
          color: Colors.white),
      child: ExpansionTile(
        title: Text(yuvaUsersModel.roleName,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
        subtitle: Text(
          yuvaUsersModel.firstName + " " + yuvaUsersModel.lastName,
          style: TextStyle(color: Colors.black, fontSize: 13),
        ),
        childrenPadding: EdgeInsets.only(
          left: 16,
        ),
        children: [
          if (yuvaUsersModel.districtAssigned != null &&
              yuvaUsersModel.districtAssigned!.isNotEmpty)
            buildYuvaTileRow(
              "District Assigned",
              districtList
                  .where((element) => yuvaUsersModel.districtAssigned!
                      .split(",")
                      .toList()
                      .contains(element.districtCode))
                  .toList()
                  .map((e) => e.name)
                  .toList()
                  .reduce((value, element) => "$value,$element"),
            ),
          if (yuvaUsersModel.assemblyAssigned != null &&
              yuvaUsersModel.assemblyAssigned!.isNotEmpty)
            buildYuvaTileRow(
                "Assemblies Assigned",
                assemblyList
                    .where((element) => yuvaUsersModel.assemblyAssigned!
                        .split(",")
                        .toList()
                        .contains(element.assemblyCode))
                    .toList()
                    .map((e) => e.name)
                    .toList()
                    .reduce((value, element) => "$value,$element")),
          buildYuvaTileRow("Mobile Number", yuvaUsersModel.mobile),
          if (yuvaUsersModel.email != null)
            buildYuvaTileRow("Email Id", yuvaUsersModel.email!),
        ],
      ),
    );
  }

  Padding buildYuvaTileRow(String label, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("$label: "), Expanded(child: Text(content))],
      ),
    );
  }
}
