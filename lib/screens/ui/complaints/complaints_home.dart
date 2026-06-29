import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        elevation: 0,
        centerTitle: true,
        backgroundColor: Constants.themeGradients[0],
        title: Text(
          "Complaints",
          style: Constants.appbarTitleTextStyle,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          HandIconIYC(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              "Indian Youth Congress",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ),
          Consumer<ComplaintsHomeVM>(
            builder: (_, model, __) => model.loadingPage
                ? NetworkLoading()
                : model.showError
                    ? SizedBox(
                        height: 150,
                        child: Center(
                          child: Text("Complaints are not available now"),
                        ),
                      )
                    : Column(
                        children: [
                          DropDownPicker(
                            onChanged: (val) {
                              model.changeSelectedLevel(val, context);
                            },
                            listValues: model.candidatureLevelList,
                            labelText: "Level of Candidature",
                            hintText: "Select Level of Candidature",
                            currentValue: model.selectedLevel,
                          ),
                          DropDownPicker(
                            onChanged: (val) {
                              model.changeSelectedCandidate(val, context);
                            },
                            listValues: model.candidatesDropdownList,
                            labelText: "Candidate",
                            hintText: "Select a Candidate",
                            currentValue: model.selectedCandidate,
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
