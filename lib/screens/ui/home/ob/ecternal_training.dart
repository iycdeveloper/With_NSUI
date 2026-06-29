import 'package:flutter/material.dart';
import 'package:iyc/screens/ui/home/ob/event_details.dart';
import 'package:iyc/screens/widgets/date_picker_widget.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/ob/external_training_vm.dart';
import 'package:provider/provider.dart';

class ExternalTraining extends StatefulWidget {
  const ExternalTraining();

  @override
  State<ExternalTraining> createState() => _ExternalTrainingState();
}
// userid_date_1
class _ExternalTrainingState extends State<ExternalTraining> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExternalTrainingVM>(
      builder: (_, model, __) => Scaffold(
        appBar: AppBar(
          title: Text('External Taining'),
        ),
        bottomNavigationBar: SizedBox(
          height: 90,
          child: URoundButton(
              title: "Submit",
              onTap: () {
                model.validateAndCreateExternalTraining(context);
                // context.read<CreateEventVM>().createEvent(context);
              }),
        ),
        body: model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  TextFieldWithLabel(
                    label: "Training Description",
                    hintText: "Training Description",
                    keyBoardType: TextInputType.name,
                    controller: model.externalTrainingDescription,
                    validation: (value) {
                      if (value.isEmpty) {
                        return 'Enter A Valid Program Name';
                      }
                      return null;
                    },
                  ),
                  DropDownPicker(
                      currentValue: model.selectedExternalTrainingType,
                      listValues: model.externalTrainingType,
                      onChanged: (value) {
                        model.onChangeTrainingType(value);
                      },
                      labelText: "External Training Type",
                      hintText: "External Training Type"),
                  DatePickerWidget(
                    selectedDate: model.selectedExternalTrainingDateFrom ??
                        "Select a external training date from",
                    labelText: "Select a external training date from",
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final datePick = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: new DateTime.now().add(Duration(days: 30)),
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
                      if (datePick != null &&
                          datePick != model.selectedExternalTrainingDateFrom) {
                        model.onChangeTrainingDateFrom(datePick);
                      }
                    },
                  ),
                  DatePickerWidget(
                    selectedDate: model.selectedExternalTrainingDateTo ??
                        "Select a external training date to",
                    labelText: "Select a external training date to",
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      model.showDatepickerTodate(context);
                    },
                  ),

                  UploadButtonImageLocal(
                      showImage: model.uploadedIndex.contains('1'),
                      onlyCamera: false,
                      buttonTextLabel: "Upload image 1",
                      onTap: (str)=> model.pickDocument(str, context, '1')
                  ),
                  UploadButtonImageLocal(
                      showImage: model.uploadedIndex.contains('2'),
                      onlyCamera: false,
                      buttonTextLabel: "Upload image 2",
                      onTap: (str)=> model.pickDocument(str, context, '2')
                  ),
                  UploadButtonImageLocal(
                      showImage: model.uploadedIndex.contains('3'),
                      onlyCamera: false,
                      buttonTextLabel: "Upload image 3",
                      onTap: (str)=> model.pickDocument(str, context, '3')
                  ),
                ],
              ),
      ),
    );
  }
}
