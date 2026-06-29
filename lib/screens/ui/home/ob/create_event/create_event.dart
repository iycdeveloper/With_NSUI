import 'package:flutter/material.dart';
import 'package:iyc/screens/widgets/date_picker_widget.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/ob/create_event/create_event_vm.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Program"),
        centerTitle: true,
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: URoundButton(
            title: "Create New Program",
            onTap: () {
              context.read<CreateEventVM>().createEvent(context);
            }),
      ),
      body: Consumer<CreateEventVM>(
        builder: (_, model, __) => model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFieldWithLabel(
                        label: "Program Name",
                        hintText: "Program Name",
                        // focusNode: model.usernameFocus,
                        // nextFocus: model.lastNameFocus,

                        // readOnly: model.disableFields,
                        keyBoardType: TextInputType.name,
                        controller: model.titleController,
                        validation: (value) {
                          if (value.isEmpty) {
                            return 'Enter A Valid Program Name';
                          }
                          return null;
                        },
                      ),
                      DropDownPicker(
                        currentValue: model.selectedEventType,
                        listValues: model.eventTypeList,
                          onChanged: (value) {
                            model.onChangeEventType(value);
                          },
                        labelText: "Program Type",
                        hintText:"Program type"
                      ),
                      DropDownPicker(
                          currentValue: model.selectedEventLevel,
                          listValues: model.eventLevelList,
                          onChanged: (value) {
                            model.onChangeEventLevel(value);
                          },
                          labelText: "Program Level",
                          hintText:"Program level"
                      ),
                      DatePickerWidget(
                        selectedDate:
                            model.selectedDate ?? "Select a Program date",
                        labelText: "Date of Program",
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          final datePick = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate:
                                new DateTime.now().add(Duration(days: 30)),
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
                          if (datePick != null && datePick != model.eventDate) {
                            model.changeDate(datePick);
                          }
                        },
                      ),
                      DatePickerWidget(
                        selectedDate:
                            model.selectedTime ?? "Select a Program Time",
                        labelText: "Time of Program",
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          final timePick = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: 10, minute: 00),
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
                          print(timePick);
                          if (timePick != null) {
                            model.changeTime(timePick);
                          }
                        },
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text(
                          "Description",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 14),
                        ),
                      ),
                      Container(
                        height: 100,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: Constants.themeGradients[0])),
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration.collapsed(
                            hintText: "",
                          ),
                          maxLines: null,
                          controller: model.detailsController,
                        ),
                      ),
                      if (model.showAddress)
                        Container(
                          alignment: Alignment.centerLeft,
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Text(
                            "Address",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14),
                          ),
                        ),
                      model.showAddress
                          ? Container(
                              height: 75,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration.collapsed(
                                  hintText: "",
                                ),
                                maxLines: null,
                                controller: model.addressController,
                                readOnly: true,
                                onTap: () {
                                  model.onTapAddress(context);

                                  FocusScope.of(context).unfocus();
                                },
                              ),
                            )
                          : TextFieldWithLabel(
                              label: "Program Address",
                              hintText: "Program Address",
                              // focusNode: model.usernameFocus,
                              // nextFocus: model.lastNameFocus,

                              // readOnly: model.disableFields,
                              keyBoardType: TextInputType.streetAddress,
                              controller: model.addressController,
                              readOnly: false,
                              validation: (value) {
                                if (value.isEmpty) {
                                  return 'Enter A Valid Program Address';
                                }
                                return null;
                              },
                              onTap: () {
                                model.onTapAddress(context);

                                FocusScope.of(context).unfocus();
                              }),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerLeft,
                          child: Text("Invitees",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 14))),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        padding: EdgeInsets.only(top: 5),
                        constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height * 0.08),
                        decoration: Constants.formItemDecoration,
                        child: TextButton(
                          onPressed: () {
                            context
                                .read<CreateEventVM>()
                                .onTapChooseInvite(context);
                            FocusScope.of(context).unfocus();
                          },
                          child: Center(
                              child: Text(context
                                      .watch<CreateEventVM>()
                                      .selectedObUserList
                                      .isNotEmpty
                                  ? "${context.watch<CreateEventVM>().selectedObUserList.length} Invitees"
                                  : "Choose Invites")),
                        ),
                      ),
                      // DropDownPicker(
                      //     currentValue: model.selectedEvent,
                      //     listValues: model.eventList,
                      //     onChanged: (value) {
                      //       model.onChangeEventInvite(value);
                      //     },
                      //     labelText: "Invite All",
                      //     hintText:"Invite All"
                      // ),
                      Row(
                        children: [
                          Checkbox(value: model.selectAllUser, onChanged: (value){
                            model.onChangedSelectAllUser(value!);
                          }),
                          Text("Invite all Registered Users")
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
    ;
  }
}
