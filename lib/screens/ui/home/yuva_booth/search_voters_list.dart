import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/size_utils.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/debouncer.dart';
import 'package:iyc/view_model/yuva_booth/search_voters_list_vm.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../widgets/dropdown/dropdown_picker.dart';

class SearchVotersList extends StatefulWidget {
  const SearchVotersList({
    Key? key,
    this.langCode,
  }) : super(key: key);

  final String? langCode;
  @override
  State<SearchVotersList> createState() => _SearchVotersListState();
}

class _SearchVotersListState extends State<SearchVotersList> {
  late TextEditingController idController;
  Debouncer? debouncer = Debouncer(milliseconds: 350);

  @override
  void initState() {
    idController = TextEditingController();
    idController.addListener(() =>
        context.read<SearchVotersListVM>().idControllerListner(idController));

    context.read<SearchVotersListVM>().initVotersList(context, widget.langCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        shape: const Border(
            bottom: BorderSide(
          color: Colors.grey,
          // width: 4
        )),
        title: const Text("Search Voters List",
            style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            child: Text(
              "View",
              style: TextStyle(
                color: Color(0xff2CC7E2),
              ),
            ),
            onPressed: () async {
              RoutesManagement.goToViewBothScreen();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 40),
          child: Consumer<SearchVotersListVM>(
            builder: (_, model, __) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ToggleSwitch(
                minWidth: MediaQuery.of(context).size.width,
                initialLabelIndex: model.selectedVoterSearchType,
                cornerRadius: 10.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: ['NAME', 'EPIC ID'],
                //  icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
                activeBgColors: [
                  [Theme.of(context).primaryColor],
                  [Theme.of(context).primaryColor]
                ],
                onToggle: (index) {
                  context
                      .read<SearchVotersListVM>()
                      .changeVoterSearchType(index);
                },
              ),
            ),
          ),
          // child: DefaultTabController(
          //   length: 2,
          //   child: TabBar(
          //     tabs: [
          //       Text("NAME"),
          //       Text("EPIC ID"),
          //     ],
          //     onTap: (index) {
          //       context.read<SearchVotersListVM>().changeVoterSearchType(index);
          //     },
          //     indicatorColor: Colors.orange,
          //     labelPadding: EdgeInsets.all(5),
          //     padding: EdgeInsets.all(5),
          //   ),
          // ),
        ),
      ),
      body: Consumer<SearchVotersListVM>(
        builder: (_, model, __) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  if (model.selectedVoterSearchType == 0)
                    DropDownPicker(
                        currentValue: model.selectedState,
                        listValues: model.stateDropdownItems,
                        onChanged: (value) {
                          setState(() {
                            idController.clear();
                          });
                          context
                              .read<SearchVotersListVM>()
                              .onChangeState(value);
                        },
                        labelText: "Select State",
                        hintText: "State"),
                  // if (model.selectedVoterSearchType == 0)
                  //   DropDownPicker(
                  //       currentValue: model.selectedDistrict,
                  //       listValues: model.districtDropdownItems,
                  //       onChanged: (value) => context
                  //           .read<SearchVotersListVM>()
                  //           .onChangeDistrict(value),
                  //       labelText: "Select District",
                  //       hintText: "District"),
                  if (model.selectedVoterSearchType == 0)
                    DropDownPicker(
                        currentValue: model.selectedParliamentCode,
                        listValues: model.parliamentDropdownItems,
                        onChanged: (parliament) => context
                            .read<SearchVotersListVM>()
                            .changeParliament(parliament),
                        labelText: "Select by Parliament Constituency",
                        hintText: "Parliament Constituency"),
                  if (model.selectedVoterSearchType == 0)
                    DropDownPicker(
                        currentValue: model.selectedAssemblyCode,
                        listValues: model.assemblyDropdownItems,
                        onChanged: (assembly) => context
                            .read<SearchVotersListVM>()
                            .changeAssembly(assembly),
                        labelText: "Select by Assembly",
                        hintText: "assembly"),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Text("Voter Search Mode "),
                  //     ToggleSwitch(
                  //       minWidth: 90.0,
                  //       initialLabelIndex: model.selectedVoterSearchType,
                  //       cornerRadius: 10.0,
                  //       activeFgColor: Colors.white,
                  //       inactiveBgColor: Colors.grey,
                  //       inactiveFgColor: Colors.white,
                  //       totalSwitches: 2,
                  //       labels: ['NAME', 'EPIC ID'],
                  //       //  icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
                  //       activeBgColors: [
                  //         [Theme.of(context).primaryColor],
                  //         [Theme.of(context).primaryColor]
                  //       ],
                  //       onToggle: (index) {
                  //         context
                  //             .read<SearchVotersListVM>()
                  //             .changeVoterSearchType(index);
                  //       },
                  //     ),
                  //   ],
                  // ),
                  Container(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    width: MediaQuery.of(context).size.width - 10,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: idController,
                          textInputAction: TextInputAction.search,
                          // onChanged: (str) {
                          //   // debouncer?.run(context
                          //   //     .read<SearchVotersListVM>()
                          //   //     .searchVoterByKeyword(
                          //   //       str,
                          //   //       context,
                          //   //     ));
                          // },
                          onSubmitted: (str) {
                            context.read<SearchVotersListVM>().searchVoter(
                                  context,
                                  str,
                                );
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: model.voterListData.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      color: Constants.kitThemeGradients[0],
                                      onPressed: () {
                                        idController.clear();
                                        context
                                            .read<SearchVotersListVM>()
                                            .clearVoterList();
                                      },
                                    )
                                  : null,
                              hintText: model.selectedVoterSearchType == 0
                                  ? "Search eg: सोनी देवी"
                                  : "Search eg: CJ102454"),
                        )),
                        SizedBox(
                          width: mediaQueryData.size.width * 0.2,
                          child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search, color: Colors.white),
                                Text(
                                  "Search",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            onPressed: (model.showSearch)
                                ? () {
                                    context
                                        .read<SearchVotersListVM>()
                                        .searchVoterByKeyword(
                                          idController.text,
                                          context,
                                        );
                                  }
                                : null,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            model.loadingResult
                ? const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()))
                : model.voterListData.length > 0
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                        (context, index) => ListTile(
                          title: Text(
                            model.voterListData[index]['NAME'],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(model.voterListData[index]['VOTER_ID']),
                              Text(model.voterListData[index]['HUSBAND_NAME']
                                      .toString()
                                      .isNotEmpty
                                  ? model.voterListData[index]['HUSBAND_NAME']
                                      .toString()
                                  : model.voterListData[index]['FATHER_NAME']
                                          .toString()
                                          .isNotEmpty
                                      ? model.voterListData[index]
                                              ['FATHER_NAME']
                                          .toString()
                                      : ""),
                            ],
                          ),
                          onTap: () async {
                            await Alert(
                              context: context,
                              onWillPopActive: true,
                              // closeIcon: IconButton(onPressed: (){}, icon: Icon(Icons.close)),
                              style: AlertStyle(
                                  backgroundColor: Constants.themeGradients[0]),
                              content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VoterListInfoLabel(
                                      label: "Name",
                                      value: model.voterListData[index]['NAME'],
                                    ),
                                    VoterListInfoLabel(
                                        label: "Father/Husband Name",
                                        value:model.voterListData[index]['HUSBAND_NAME']
                                      .toString()
                                      .isNotEmpty
                                  ? model.voterListData[index]['HUSBAND_NAME']
                                      .toString()
                                  : model.voterListData[index]['FATHER_NAME']
                                          .toString()
                                          .isNotEmpty
                                      ? model.voterListData[index]
                                              ['FATHER_NAME']
                                          .toString()
                                      : ""),
                                    VoterListInfoLabel(
                                      label: "Voter ID",
                                      value: model.voterListData[index]
                                          ['VOTER_ID'],
                                    ),
                                    VoterListInfoLabel(
                                      label: "Gender",
                                      value: model.voterListData[index]
                                          ['GENDER'],
                                    ),
                                    // VoterListInfoLabel(
                                    //   label: "Parliament",
                                    //   value: model.voterListData[index][''] ??
                                    //       "",
                                    // ),
                                    VoterListInfoLabel(
                                      label: "Assembly",
                                      value: model.voterListData[index]
                                              ['ASSEMBLY_NAME'] ??
                                          "",
                                    ),
                                  ]),
                              buttons: [
                                DialogButton(
                                  child: const Text(
                                    "CANCEL",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  width: 120,
                                ),
                                DialogButton(
                                  child: const Text(
                                    "CONFIRM",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    RoutesManagement
                                        .goToVoterListViewFormScreen({
                                      'data': model.voterListData[index],
                                      'statecode': model.selectedState ?? 'BR'
                                    });
                                    // setState(() {
                                    //   idController.clear();
                                    //   model.filteredVotersList = [];
                                    //   model.selectedAssemblyCode = null;
                                    //   model.selectedParliamentCode = null;
                                    //   model.changeVoterSearchType(0);
                                    // });
                                    // Navigator.of(context)
                                    //     .pop(model.filteredVotersList[index]);
                                  },
                                  width: 120,
                                )
                              ],
                            ).show();
                            //   Navigator.of(context).pop(model.voterList[index]);
                          },
                          trailing: Text(model.voterListData[index]['GENDER']),
                        ),
                        childCount: model.voterListData.length,
                      ))
                    : SliverToBoxAdapter(
                        child: SizedBox(
                        height: 400,
                        child: Center(
                          child: Text(idController.text.isEmpty
                              ? "Search Voter by Name or ID "
                              : "no member found"),
                        ),
                      ))
          ],
        ),
      ),
    );
  }
}

class VoterListInfoLabel extends StatelessWidget {
  const VoterListInfoLabel({Key? key, required this.label, required this.value})
      : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ",
              style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white)),
          Expanded(
            child: Text(
              "$value",
              style: theme.textTheme.bodyLarge!.copyWith(
                  color: Colors.white, overflow: TextOverflow.visible),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
