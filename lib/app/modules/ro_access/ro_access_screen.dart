import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/ro_access/ro_access_controller.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';
import 'package:iyc/app/widgets/drop_down/state_picker_drop_down.dart';
import 'package:iyc/screens/widgets/custom_button.dart';
import 'package:iyc/utils/constants.dart';

class ROAccessScreen extends StatelessWidget {
  const ROAccessScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<ROAccessController>(builder: (logic) {
        return Scaffold(
            appBar: CustomAppBar(
                leadingWidth: 44.h,
                leading: AppbarImage(
                    onTap: Get.back,
                    svgPath: ImageConstant.imgBiarrowleftIndigo800,
                    margin:
                        EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
                title: AppbarSubtitle1(
                    text: 'RO Access Home',
                    margin: EdgeInsets.only(left: 12.h)),
                styleType: Style.standard),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // CustomFloatingTextField(
                  //     margin: EdgeInsets.only(
                  //         left: 20.h, top: 20.v, right: 20.h),
                  //     controller: logic.mobileId,
                  //     labelText: "Mobile Number",
                  //     labelStyle: theme.textTheme.bodyLarge!,
                  //     hintText: "Search eg: 9999900000",
                  //     hintStyle: theme.textTheme.bodyLarge!,),
                  CustomFloatingDropDown(
                      title: 'Select Ballot',
                      defaultMargin: false,
                      value: logic.selectedCandidature,
                      listValues: logic.candidateLevelList,
                      onChanged: (value) {
                        logic.changeCandidature(value);
                      }),
                  SizedBox(
                    height: 5,
                  ),
                  if (logic.selectedCandidature != null)
                    StateDropDrown(
                        margin:
                            EdgeInsets.only(left: 0.h, top: 0.v, right: 0.h),
                        title: 'State',
                        value: logic.selectedState,
                        listValues: logic.stateList,
                        onChanged: (value) {
                          logic.onChangeState(value);
                        }),
                  SizedBox(
                    height: 5,
                  ),
                  if ([
                    "DISTRICT PRESIDENT",
                    "DISTRICT GENERAL SECRETARY",
                    "ASSEMBLY",
                    "MANDALAM"
                  ].contains(logic.selectedCandidature))
                    CustomFloatingDropDown(
                        title: 'District',
                        defaultMargin: false,
                        value: logic.selectedDistrict,
                        listValues: logic.districtDropdownItems,
                        onChanged: (value) {
                          logic.changeDistrict(value);
                        }),
                  SizedBox(
                    height: 5,
                  ),
                  if (["ASSEMBLY", "MANDALAM"]
                      .contains(logic.selectedCandidature))
                    CustomFloatingDropDown(
                        title: 'Assembly',
                        defaultMargin: false,
                        value: logic.selectedAssembly,
                        listValues: logic.assemblyDropdownItems,
                        onChanged: (value) {
                          logic.changeAssembly(value);
                        }),
                  SizedBox(
                    height: 5,
                  ),
                  if (logic.selectedCandidature == "MANDALAM")
                    CustomFloatingDropDown(
                        title: 'Mandalam/Block/Ward',
                        defaultMargin: false,
                        value: logic.selectedMandalamBlockWard,
                        listValues: logic.mandalamDropdownItems,
                        onChanged: (value) {
                          logic.changeMandalam(value);
                        }),
                  SizedBox(
                    height: 10,
                  ),
                  if (logic.selectedCandidature != null)
                    SizedBox(
                      height: 40,
                      child: CustomButton(
                          labelText: 'Submit',
                          onTap: () {
                            logic.getNomination();
                          }),
                    ),
                  if (logic.nominationDetails.isNotEmpty) ...[
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Nomination list'),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        shrinkWrap:
                            true, // Set to true to avoid infinite height issues
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: logic.nominationDetails.length,
                        itemBuilder: (context, index) => InkWell(
                              onTap: () =>
                                  RoutesManagement.goToNominationDetailScreen(
                                      logic.nominationDetails[index]),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.lightBlue
                                              .withOpacity(0.1)),
                                      borderRadius: BorderRadius.circular(12)),
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${logic.nominationDetails[index]['first_name']} ${logic.nominationDetails[index]['last_name']}',
                                              style: theme.textTheme.bodyLarge,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '${logic.nominationDetails[index]['mobile']}'),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${logic.nominationDetails[index]['nomination_status']}',
                                              style: TextStyle(
                                                  color: logic.getStatusColor(
                                                      '${logic.nominationDetails[index]['nomination_status']}')),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // IconButton(
                                      //     onPressed: () {},
                                      //     icon: Icon(Icons.edit)),
                                      CustomImageView(
                                          svgPath: ImageConstant.imgEditing1,
                                          height: 24.adaptSize,
                                          width: 24.adaptSize,
                                          color: Colors.black,
                                          // margin: EdgeInsets.only(bottom: 56.v),
                                          onTap: () {
                                            RoutesManagement
                                                .goToRoNominationEditScreen(
                                                    logic.nominationDetails[
                                                        index]);
                                          }),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                ),
                              ),
                            )),
                    if (logic.nominationDetails.isEmpty)
                      Center(child: Text("NO RO Access List"))
                  ],
                ],
              ),
            ));
      }),
    );
  }

  Padding buildLabelAndContent(String label, String content) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(label,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Constants.themeTextGradients[1],
                        fontSize: 14))),
          ),
          Text(":"),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.center,
              child: Text(content,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 14),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
