import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/screens/widgets/date_picker_widget.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/dropdown/state_picker_dropdown.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/profile/inbox/task_create_vm.dart';
import 'package:provider/provider.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  @override
  void initState() {
    context.read<TaskCreateVM>().populatePoints();
    context.read<TaskCreateVM>().getStatesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
        centerTitle: true,
      ),
      bottomNavigationBar: URoundButton(
        title: "Add",
        onTap: () async {
          bool valid = context.read<TaskCreateVM>().validateForm(context);
          if (valid) {
            context.read<TaskCreateVM>().createTask(context);
          }
        },
      ),
      body: Consumer<TaskCreateVM>(
        builder: (_, logic, __) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: logic.formKey,
            child: ListView(
              children: [
                StatePickerDropDown(
                  currentState: logic.selectedState,
                  selectedState: "Select State",
                  viewOnly: logic.isEditMode,
                  stateList: logic.stateList,
                  onTap: () {
                    logic.refresh();
                  },
                  onChanged: (value) {
                    logic.changeSelectedState(logic.stateList!
                        .singleWhere((element) => element.stateCode == value));
                  },
                  isRegistrationPage: true,
                ),
                if (!logic.isEditMode)
                  DropDownPicker(
                    onChanged: (val) {
                      logic.changeType(val);
                    },
                    listValues: logic.type,
                    labelText: "Task Type",
                    hintText: "Select a task type",
                    currentValue: logic.selectedType,
                  ),
                if (!logic.isEditMode)
                  DropDownPicker(
                    onChanged: (val) {
                      logic.changeCategory(val);
                    },
                    listValues: logic.category,
                    labelText: "Task Category",
                    hintText: "Select a task category",
                    currentValue: logic.selectedCategory,
                  ),
                if (!logic.isEditMode)
                  DropDownPicker(
                    onChanged: (val) {
                      logic.changePriority(val);
                    },
                    listValues: logic.priority,
                    labelText: "Task Priority",
                    hintText: "Select a task priority",
                    currentValue: logic.selectedPriority,
                  ),
                if (!logic.isEditMode)
                  DatePickerWidget(
                    labelText: "Start date",
                    selectedDate: logic.showStartDate ?? "Select a start date",
                    onTap: () async {
                      final datePick = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: new DateTime(2025),
                        builder: (BuildContext? context, Widget? child) {
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
                      if (datePick != null) {
                        logic.changeStartDate(datePick);
                      }
                    },
                  ),
                if (!logic.isEditMode)
                  DatePickerWidget(
                    labelText: "End date",
                    selectedDate: logic.showEndDate ?? "Select a end date",
                    onTap: () async {
                      final datePick = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: new DateTime(2025),
                        builder: (BuildContext? context, Widget? child) {
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
                      if (datePick != null) {
                        logic.changeEndDate(datePick);
                      }
                    },
                  ),
                TextFieldWithLabel(
                  maxline: 5,
                  label: "Description",
                  hintText: "Description",
                  inputAction: TextInputAction.done,
                  focusNode: logic.descFocus,
                  maxLength: 200,
                  keyBoardType: TextInputType.name,
                  controller: logic.descController,
                  readOnly: logic.isEditMode,
                  validation: (value) {
                    if (value.isEmpty) {
                      return 'Enter A Valid Description';
                    }
                    return null;
                  },
                ),
                TextFieldWithLabel(
                  label: "Add Url",
                  hintText: "Add Url",
                  inputAction: TextInputAction.done,
                  focusNode: logic.urlFocus,
                  maxLength: 200,
                  // keyBoardType: TextInputType.name,
                  controller: logic.urlController,
                  readOnly: logic.isEditMode,
                  // validation: (value) {
                  //   if (value.isEmpty) {
                  //     return 'Enter A Valid Url';
                  //   }
                  //   return null;
                  // },
                ),
                if (logic.selectedType == 'D2D')
                  TextFieldWithLabel(
                    label: "D2D COUNT",
                    hintText: "D2D COUNT",
                    inputAction: TextInputAction.done,
                    focusNode: logic.d2dFocus,
                    keyBoardType: TextInputType.number,
                    controller: logic.d2dController,
                    readOnly: logic.isEditMode,
                  ),
                if (logic.selectedType == 'BJ')
                  TextFieldWithLabel(
                    label: "BJ COUNT",
                    hintText: "BJ COUNT",
                    inputAction: TextInputAction.done,
                    focusNode: logic.bjFocus,
                    maxLength: 2,
                    keyBoardType: TextInputType.number,
                    controller: logic.bjController,
                    readOnly: logic.isEditMode,
                  ),
                TextFieldWithLabel(
                  label: "Task Point",
                  keyBoardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  hintText: "Task Point",
                  inputAction: TextInputAction.done,
                  focusNode: logic.pointFocus,
                  maxLength: 2,
                  // keyBoardType: TextInputType.number,
                  controller: logic.pointController,
                  readOnly: logic.isEditMode,
                  validation: (value) {
                    if (value.isEmpty) {
                      return 'Enter A Valid point';
                    }
                    if (int.parse(value) > 50) {
                      return 'Task point must be less then 50';
                    }
                    return null;
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
