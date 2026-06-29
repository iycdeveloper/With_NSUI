import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iyc/view_model/ob/checkin_page_vm.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../../di_container.dart';
import '../../../../model/api_model/base/api_response.dart';
import '../../../widgets/button/next_prev_button.dart';
import '../../../widgets/custom_snack_bar.dart';
import '../../../widgets/network_loading_dialog_box.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({Key? key}) : super(key: key);

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  String description = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Check In History"),
      ),
      body: Consumer<CheckInPageVM>(
        builder: (_, model, __) => model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : model.eventList.isNotEmpty
                ? ListView.builder(
                    itemCount: model.eventList.length,
                    itemBuilder: (_, index) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.eventList[index].eventDescription,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            model.eventList[index].eventLocation,
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Text(
                            DateFormat().format(DateTime.parse(
                                model.eventList[index].dateTime)),
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.only(bottom: 70),
                  )
                : Center(child: Text("No Events Available for Check In")),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: NextPrevButton(
            width: 150,
            onTap: () {
              Alert(
                  context: context,
                  title: "Purpose of Visit",
                  content: Column(
                    children: [
                      Container(
                        height: 150,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all()),
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          maxLength: 100,
                          onChanged: (val) {
                            description = val;
                          },
                          autofocus: true,
                          decoration: InputDecoration.collapsed(
                            hintText: "purpose is....",
                          ),
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                  buttons: [
                    DialogButton(
                      onPressed: () async {
                        // Navigator.of(context).pop(); // alert dialog close
                        // showNetworkLoadingDialog(context, willPopScope: false);
                        // ApiResponse apiResponse = await sl<YuvaBoothRepo>()
                        //     .checkInYuvaBooth(description);
                        // if (apiResponse.response != null &&
                        //     apiResponse.response!.statusCode == 200) {
                        //   Navigator.of(context).pop(); // loading
                        //   Alert(
                        //     context: context,
                        //     type: AlertType.success,
                        //     title: "Check In Success",
                        //     buttons: [
                        //       DialogButton(
                        //         child: Text(
                        //           "OKAY",
                        //           style: TextStyle(
                        //               color: Colors.white, fontSize: 20),
                        //         ),
                        //         onPressed: () async {
                        //           Navigator.pop(context);
                        //           context
                        //               .read<CheckInPageVM>()
                        //               .getCheckInData(context, true);
                        //         },
                        //         width: 120,
                        //       )
                        //     ],
                        //   ).show();
                        // } else {
                        //   Navigator.of(context).pop(); // loading
                        //   showCustomSnackBar("${apiResponse.error}", context);
                        // }
                      },
                      child: Text(
                        "Submit",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      width: 100,
                    )
                  ]).show();
            },
            title: "Add Check In"),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<CheckInPageVM>().getCheckInData(context);
  }
}
