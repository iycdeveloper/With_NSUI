import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/yuva_user/yuva_user.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/screens/widgets/date_picker_widget.dart';
import 'package:iyc/screens/widgets/dropdown/assembly_picker_dropdown.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/yuva_booth/add_yuva_data_meeting_vm.dart';
import 'package:provider/provider.dart';

class AddYuvaData extends StatefulWidget {
  const AddYuvaData(
      {Key? key, required this.yuvaUser, required this.yuvaUsersList})
      : super(key: key);
  final YuvaUser yuvaUser;
  final List<YuvaUser> yuvaUsersList;

  @override
  State<AddYuvaData> createState() => _AddYuvaDataState();
}

class _AddYuvaDataState extends State<AddYuvaData> {
  @override
  void initState() {
    context
        .read<AddYuvaDataMeetingVM>()
        .initAddYuvaUser(context, widget.yuvaUser, widget.yuvaUsersList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Constants.themeGradients[0],
        title: Text("Add Meeting Feedback"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Consumer<AddYuvaDataMeetingVM>(
            builder: (_, model, __) => Column(
              children: [
                TextFieldWithLabel(
                  label: "Full Name",
                  hintText: "Full Name",
                  // focusNode: model.usernameFocus,
                  // nextFocus: model.lastNameFocus,

                  // readOnly: model.disableFields,
                  keyBoardType: TextInputType.name,
                  controller: model.nameController,
                  validation: (value) {
                    if (value.isEmpty) {
                      return 'Enter A Valid Name';
                    }
                    return null;
                  },
                ),
                TextFieldWithLabel(
                  label: "Designation",
                  hintText: "Designation",
                  keyBoardType: TextInputType.name,
                  controller: model.designationController,
                  validation: (value) {
                    if (value.isEmpty) {
                      return 'Enter A Valid Designation';
                    }
                    return null;
                  },
                ),
                TextFieldWithLabel(
                  label: "Phone Number",
                  hintText: "Phone Number",
                  keyBoardType: TextInputType.phone,
                  focusNode: model.mobileFocus,
                  controller: model.mobileController,
                  maxLength: 10,
                  validation: (value) {
                    if (value.isEmpty) {
                      return 'Enter A Valid Mobile';
                    }
                    return null;
                  },
                ),
                DatePickerWidget(
                  selectedDate: model.selectedDate ?? "Select a date of birth",
                  onTap: () async {
                    final datePick = await showDatePicker(
                      context: context,
                      initialDate: new DateTime.utc(
                        int.parse(await LocalStorageServices()
                            .getDobEndRange()),
                      ),
                      firstDate: DateTime(1950),
                      lastDate: new DateTime(
                        int.parse(await LocalStorageServices()
                            .getDobEndRange()),
                      ),
                      builder:
                          (BuildContext? context, Widget? child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: Constants.themeGradients[1],
                              onPrimary: Colors.black87,
                              surface: Constants.themeGradients[0],
                              onSurface: Constants.themeGradients[1],
                            ),
                            dialogBackgroundColor:
                            Constants.themeGradients[0],
                          ),
                          child: child!,
                        );
                      },
                    );
                    //await datePicker(context);
                    print(datePick);
                    if (datePick != null &&
                        datePick != model.eventDate) {
                      model.changeDate(datePick);
                    }
                  },
                ),

                if (["2", "3"].contains(model.currentYuvaUser.roleId))
                  AssemblyPickerDropDown(
                      currentAssembly: model.selectedAssembly,
                      assemblyList: model.assemblyList,
                      // viewOnly: !model.enableDistrictEdit&&model.disableFields,
                      selectedAssembly: model.selectedAssemblyName ??
                          "Select Assembly Constituency",
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        context
                            .read<AddYuvaDataMeetingVM>()
                            .changeSelectedAssembly(context
                                .read<AddYuvaDataMeetingVM>()
                                .assemblyList!
                                .singleWhere((element) =>
                                    element.assemblyCode == value));
                      }),
                DropDownPicker(
                  onChanged: (val) {
                    model.changeSelectedReception(val);
                  },
                  listValues: model.receptionList,
                  labelText: "Reception Type",
                  hintText: "Select a Feedback",
                  currentValue: model.selectedReception,
                ),
                DropDownPicker(
                  onChanged: (val) {
                    model.changeSelectedReportType(val);
                  },
                  listValues: model.reportTypeList,
                  labelText: "Report Type",
                  hintText: "Select a Report Type",
                  currentValue: model.selectedReportType,
                ),
                if (model.selectedReportType == "Party Office Bearers")
                  DropDownPicker(
                    onChanged: (val) {
                      model.changeSelectedFrontal(val);
                    },
                    listValues: model.frontalList,
                    labelText: "Frontal Type",
                    hintText: "Select a Frontal Type",
                    currentValue: model.selectedFrontal,
                  ),
                if (model.selectedReportType == "Party Office Bearers")
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    padding: EdgeInsets.only(top: 5),
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.08),
                    decoration: Constants.formItemDecoration,
                    child: Consumer<AddYuvaDataMeetingVM>(
                      builder: (_, model, __) => DropDownPicker(
                          currentValue: model.selectedBooth,
                          listValues: model.boothList,
                          onChanged: (value) {
                            context
                                .read<AddYuvaDataMeetingVM>()
                                .changeSelectedBooth(value);
                          },
                          labelText: "Booth",
                          hintText: "Select a booth"),
                    ),
                  ),
                if (model.selectedReportType == "Party Office Bearers")
                  TextFieldWithLabel(
                    label: "Ward Number",
                    hintText: "ward number",

                    // focusNode: model.emailFocus,
                    inputAction: TextInputAction.done,
                    keyBoardType: TextInputType.number,
                    controller: model.wardController,
                    focusNode: model.wardFocus,
                    validation: (value) {
                      if (value.isEmpty) {
                        return 'Enter A Valid Ward number';
                      }
                      return null;
                    },
                  ),
                Container(
                  height: 100,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all()),
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration.collapsed(
                      hintText: "Feedback of meeting....",
                    ),
                    maxLines: null,
                    controller: model.feedBackController,
                  ),
                ),
                URoundButton(
                  title: "Submit",
                  onTap: () async {
                    context.read<AddYuvaDataMeetingVM>().submit(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
