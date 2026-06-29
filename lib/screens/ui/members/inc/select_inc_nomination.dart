import 'package:flutter/material.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/screens/ui/membership/widgets/state_candidate_dropdown.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/view_model/members/select_inc_monination_vm.dart';
import 'package:provider/provider.dart';

class SelectIncNomination extends StatefulWidget {
  SelectIncNomination({Key? key, required this.incMember}) : super(key: key);

  final BatchMember incMember;

  @override
  _SelectIncNominationState createState() => _SelectIncNominationState();
}

class _SelectIncNominationState extends State<SelectIncNomination> {
  @override
  void initState() {
    context
        .read<SelectIncNominationVM>()
        .setInitialMember(widget.incMember, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Nominations"),
      ),
      bottomNavigationBar: URoundButton(
          title: "Submit",
          onTap: () async =>
              context.read<SelectIncNominationVM>().onSubmit(context)),
      body: Consumer<SelectIncNominationVM>(
          builder: (_, model, __) => model.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      StateNominationPickerWidget(
                        onChanged: (val) {
                          model.changeStateNomination(val);
                        },
                        listValues: model.statePresidentNominationsList,
                        labelText: "State President Candidate",
                        currentValue: model.selectedStatePresidentNominations,
                        defaultValue: "Select State President Nomination",
                      ),
                      StateNominationPickerWidget(
                        onChanged: (val) {
                          model.changeStateGSNomination(val);
                        },
                        listValues: model.stateGeneralSecretaryNominationsList,
                        labelText: "State General Secretary Candidate",
                        currentValue: model.selectedStateGSNominations,
                        defaultValue:
                            "Select State General Secretary Nomination",
                      ),
                      StateNominationPickerWidget(
                        onChanged: (val) {
                          model.changeDistrictNomination(val);
                        },
                        listValues: model.districtNominationsList,
                        labelText: "District Candidate",
                        currentValue: model.selectedDistrictNominations,
                        defaultValue: "Select District Nomination",
                      ),
                      StateNominationPickerWidget(
                        onChanged: (val) {
                          model.changeAssemblyNomination(val);
                        },
                        listValues: model.assemblyNominationsList,
                        labelText: "Assembly Candidate",
                        currentValue: model.selectedAssemblyNominations,
                        defaultValue: "Select Assembly Nomination",
                      ),
                    ],
                  ),
                )),
    );
  }
}
