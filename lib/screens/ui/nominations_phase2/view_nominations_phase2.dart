import 'package:flutter/material.dart';
import 'package:iyc/provider/nomination_phase2/nominations_provider_phase2.dart';
import 'package:iyc/screens/ui/members/inc/label_with_text_widget.dart';
import 'package:iyc/screens/ui/nominations_phase2/update_candidates_nomination_phase2.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/nomination_phase2/update_candidate_vm_phase2.dart';
import 'package:iyc/view_model/nomination_phase2/view_nomination_vm_phase2.dart';
import 'package:provider/provider.dart';

class ViewNominationPhase2 extends StatelessWidget {
  const ViewNominationPhase2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: HomePageDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Nomination Phase 2',
        ),
        centerTitle: true,
        backgroundColor: Constants.themeGradients[0],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Consumer<ViewNominationVmPhase2>(
          builder: (_, model, __) => model.isLoading
              ? const NetworkLoading()
              : Column(
                  children: [
                    LabelWithTextWidget(
                      label: "First Name",
                      text: model.nominationMember.firstName!,
                    ),
                    LabelWithTextWidget(
                      label: "Last Name",
                      text: model.nominationMember.lastName!,
                    ),
                    LabelWithTextWidget(
                      label: "Gender",
                      text: model.nominationMember.gender == "M"
                          ? "Male"
                          : model.nominationMember.gender == "F"
                              ? "Female"
                              : "Others",
                    ),
                    LabelWithTextWidget(
                      label: "Category",
                      text: model.categoryList
                          .firstWhere((element) =>
                              element.value == model.nominationMember.category)
                          .name,
                    ),
                    LabelWithTextWidget(
                      label: "State",
                      text: model.stateList
                          .firstWhere((element) =>
                              element.stateCode ==
                              model.nominationMember.stateCode)
                          .name,
                    ),
                    LabelWithTextWidget(
                      label: "District",
                      text: model.districtList
                          .firstWhere((element) =>
                              element.districtCode ==
                              model.nominationMember.districtCode)
                          .name,
                    ),
                    //
                    if (model.nominationMember.blockCode != null &&
                        model.nominationMember.blockCode!.isNotEmpty &&
                        model.nominationMember.blockCode != "0")
                      LabelWithTextWidget(
                        label: "Blocks",
                        text: model.blocksList
                            .firstWhere((element) =>
                                element.blockCode ==
                                model.nominationMember.blockCode)
                            .blockName,
                      ),
                    // // LabelWithTextWidget(
                    // //   label: "Booths",
                    // //   text: model.boothsList
                    // //       .firstWhere((element) =>
                    // //           element.boothCode ==
                    // //           model.nominationMember.)
                    // //       .name,
                    // // ),
                    //

                    ///--------------
                    if (model.nominationMember.assemblyCode != null &&
                        model.nominationMember.assemblyCode!.isNotEmpty)
                      LabelWithTextWidget(
                        label: "Assembly/Zone",
                        text: model.assemblyList.any((element) =>
                                element.assemblyCode ==
                                model.nominationMember.assemblyCode)
                            ? model.assemblyList
                                .firstWhere((element) =>
                                    element.assemblyCode ==
                                    model.nominationMember.assemblyCode)
                                .name
                            : "Unknown Assembly/Block",
                      ),
                    if (model.nominationMember.mandalamCode != null &&
                        model.nominationMember.mandalamCode!.isNotEmpty &&
                        model.mandalamList != null)
                      LabelWithTextWidget(
                        label: "Mandalam",
                        text: model.mandalamList
                                ?.firstWhere((element) =>
                                    element.mandalamCode ==
                                    model.nominationMember.mandalamCode)
                                .mandalamName ??
                            "Unknown Mandalam",
                      ),
                    LabelWithTextWidget(
                      label: "BPL",
                      text: model.nominationMember.bplCard!,
                    ),
                    LabelWithTextWidget(
                      label: "Contesting For",
                      text: model.nominationMember.contestingFor!,
                    ),
                    LabelWithTextWidget(
                      label: "Amount",
                      text: model.nominationMember.amount!,
                    ),
                    LabelWithTextWidget(
                      label: "Payment Status",
                      text: model.nominationMember.paymentStatus!.isEmpty
                          ? "Not Paid"
                          : model.nominationMember.paymentStatus!,
                    ),
                    if (model.nominationMember.paymentStatus != "PAID")
                      URoundButton(
                          title: "Pay Nomination Phase 2",
                          onTap: () {
                            context
                                .read<ViewNominationVmPhase2>()
                                .getNominationAmount(context);
                          }),
                    if (model.nominationMember.paymentStatus == "PAID" 
                    // &&
                    //     [
                    //       "KL",
                    //       "TL",
                    //       "KA",
                    //       "DL",
                    //       "HP",
                    //       "CH",
                    //       "LA",
                    //       "ML",
                    //       "HR",
                    //       "TN",
                    //       "MB",
                    //       "MP",
                    //       "GJ","JH"
                    //     ].contains(model.nominationMember.stateCode)
                        )
                      URoundButton(
                          title: "Vote Now",
                          onTap: () async {
                            await toPage(
                                context,
                                ChangeNotifierProvider(
                                  create: (context) => UpdateCandidateVMPhase2(),
                                  child: UpdateCandidateNominationPhase2(
                                      nominationMember: model.nominationMember),
                                ));

                            context
                                .read<NominationsProviderPhase2>()
                                .initNominations(context);
                          })
                  ],
                ),
        ),
      ),
    );
  }
}
