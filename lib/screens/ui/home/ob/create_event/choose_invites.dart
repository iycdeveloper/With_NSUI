import 'package:flutter/material.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/view_model/ob/create_event/choose_invites_vm.dart';
import 'package:provider/provider.dart';

class ChooseInvites extends StatefulWidget {
  const ChooseInvites({Key? key}) : super(key: key);

  @override
  State<ChooseInvites> createState() => _ChooseInvitesState();
}

class _ChooseInvitesState extends State<ChooseInvites> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    context.read<ChooseInvitesVM>().initObList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(context.watch<ChooseInvitesVM>().appBarTitle),
        ),
        body: Consumer<ChooseInvitesVM>(
          builder: (context, state, __) {
            if (state.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      () {
                        switch (state.currentObIndex) {
                          case 1:
                            return DropDownPicker(
                              onChanged: (val) {
                                state.changeSelectedValue(val, context);
                              },
                              listValues: state.districtList
                                  ?.map((value) => DropdownItem(
                                        value.name,
                                        value.districtCode,
                                      ))
                                  .toList(),
                              labelText: "Ob District",
                              hintText: "Filter by District ",
                              currentValue: state.selectedOBDistrict,
                            );
                          case 2:
                            return DropDownPicker(
                              onChanged: (val) {
                                state.changeSelectedValue(val, context);
                              },
                              listValues: state.assemblyList
                                  ?.map((value) => DropdownItem(
                                        value.name,
                                        value.assemblyCode,
                                      ))
                                  .toList(),
                              labelText: "Ob Assembly",
                              hintText: "Filter by Assembly ",
                              currentValue: state.selectedOBAssembly,
                            );
                          default:
                            return SizedBox();
                        }
                      }(),
                      if (state.currentObIndex > 0 &&
                          state.tempObUsers.length > 0)
                        Container(
                          height: 60,
                          child: SwitchListTile(
                              value: state.isSelectAll,
                              title: Text("Select All"),
                              onChanged: (value) => context
                                  .read<ChooseInvitesVM>()
                                  .changeSelectAllSwitch(value)),
                        ),
                    ],
                  ),
                ),
                (state.tempObUsers.length > 0)
                    ? SliverList(
                        //  controller: scrollController,
                        delegate: SliverChildBuilderDelegate(
                            (context, index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SwitchListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color: state.tempObUsers[index]
                                                    .isSelected
                                                ? Colors
                                                    .lightGreenAccent.shade700
                                                : Colors.black38)),
                                    title: Text(
                                        "${state.tempObUsers[index].firstName + " " + state.tempObUsers[index].lastName}"),
                                    subtitle: Text(
                                        state.tempObUsers[index].postAlloted),
                                    value: state.tempObUsers[index].isSelected,
                                    tileColor:
                                        state.tempObUsers[index].isSelected
                                            ? Colors.lightGreen.shade200
                                            : Colors.white,
                                    onChanged: (bool value) {
                                      context
                                          .read<ChooseInvitesVM>()
                                          .changeSelection(value, index);
                                    },
                                  ),
                                ),
                            childCount: state.tempObUsers.length),
                      )
                    : SliverToBoxAdapter(
                        child: Center(
                          child: Text("No Ob Users"),
                        ),
                      ),
              ],
            );
          },
        ),
        bottomNavigationBar: URoundButton(
            height: 60,
            title: context.watch<ChooseInvitesVM>().currentObIndex == 2
                ? "Submit"
                : "Next",
            onTap: () {
              context.read<ChooseInvitesVM>().showNextObUsers(context);
            }));
  }
}
