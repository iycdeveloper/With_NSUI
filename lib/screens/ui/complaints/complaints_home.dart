import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/size_utils.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/iyc/hand_icon_iyc.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/complaints/complaints_home_vm.dart';
import 'package:provider/provider.dart';

class ComplaintsHome extends StatefulWidget {
  const ComplaintsHome({Key? key}) : super(key: key);

  @override
  _ComplaintsHomeState createState() => _ComplaintsHomeState();
}

class _ComplaintsHomeState extends State<ComplaintsHome> {
  @override
  void initState() {
    context.read<ComplaintsHomeVM>().getMemberDetails(context);
    //getCandidatureLevel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leadingWidth: mediaQueryData.size.width * 0.12,
        // leadingWidth: 44.h,
        leading: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 10),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: theme.primaryColor),
          child: IconButton(
              padding: const EdgeInsets.only(left: 10),
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
        centerTitle: true,
        title: Text(
          'Complaints',
          style: theme.textTheme.titleLarge!
              .copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor),
        ),
      ),
      bottomNavigationBar: Container(
                padding: EdgeInsets.only(
                    left: 20.h, right: 20.h, bottom: 16.v, top: 16.v),
                // decoration: AppDecoration.outlineBlue100011,
                child: CustomElevatedButton(
                  rightIcon: const Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
                  text: 'Next  ',
                  onTap: () => context.read<ComplaintsHomeVM>()..submit(context),
                )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.05,
          // ),
          // HandIconIYC(),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.02,
          // ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                        ImageConstant.imagePathNew + '/images/bpycback.png'))),
            child: Text(
              "Create a new complaint after filling out the following details:",
              textAlign: TextAlign.start,
              style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold, color: theme.primaryColor),
            ),
          ),
          Consumer<ComplaintsHomeVM>(
            builder: (_, model, __) => model.loadingPage
                ? const NetworkLoading()
                : model.showError
                    ? const SizedBox(
                        height: 150,
                        child: Center(
                          child: Text("Complaints are not available now"),
                        ),
                      )
                    : 
                    Column(
                        children: [
                          CustomFloatingDropDown(
                            onChanged: (val) {
                              model.changeSelectedLevel(val, context);
                            },
                            listValues: model.candidatureLevelList,
                            title: "Level of Candidature",
                            hintText: "Select Level of Candidature",
                            hintstyle: theme.textTheme.bodyLarge,
                            border: Border.all(
                              color: theme.textTheme.bodyLarge!.color!,
                            ),
                            dropdownIconColor: theme.textTheme.bodyLarge!.color,
                            value: model.selectedLevel,
                          ),
                          CustomFloatingDropDown(
                            onChanged: (val) {
                              model.changeSelectedCandidate(val, context);
                            },
                            listValues: model.candidatesDropdownList,
                            title: "Candidate",
                            hintText: "Select a Candidate",
                            // hintstyle: theme.textTheme.bodyLarge,
                            // border: Border.all(
                            //   color: theme.textTheme.bodyLarge!.color!,
                            // ),
                            // dropdownIconColor: theme.textTheme.bodyLarge!.color,
                            value: model.selectedCandidate,
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
