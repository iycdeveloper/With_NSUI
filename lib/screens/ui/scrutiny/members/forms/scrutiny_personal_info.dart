import 'package:flutter/material.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/screens/ui/membership/widgets/education_dropdown.dart';
import 'package:iyc/screens/widgets/date_picker_widget.dart';
import 'package:iyc/screens/widgets/dropdown/category_picker.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_personal_info_vm.dart';
import 'package:provider/provider.dart';

class ScrutinyPersonalInfoPage extends StatefulWidget {
  final String? memberId;
  const ScrutinyPersonalInfoPage({Key? key, this.memberId}) : super(key: key);

  @override
  State<ScrutinyPersonalInfoPage> createState() =>
      _ScrutinyPersonalInfoPageState();
}

class _ScrutinyPersonalInfoPageState extends State<ScrutinyPersonalInfoPage> {
  @override
  void initState() {
    context.read<ScrutinyPersonalInfoVM>().checkForPrefillData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Personal Information",
              style: Constants.appbarTitleTextStyle),
          backgroundColor: Constants.themeGradients[0],
          centerTitle: true,
        ),
        body: Consumer<ScrutinyPersonalInfoVM>(
            builder: (_, model, __) => model.isLoading
                ? NetworkLoading()
                : SingleChildScrollView(
                    child: Form(
                    key: model.secondFormKey,
                    child: Column(
                      children: [
                        DropDownPicker(
                          onChanged: (val) {
                            model.changeGender(val);
                          },
                          viewOnly: model.disableFields,
                          listValues: model.genders,
                          labelText: "Gender",
                          hintText: "Select a gender",
                          currentValue: model.selectedGender,
                        ),
                        DatePickerWidget(
                          selectedDate: model.selectedDate ?? "Select a date",
                          onTap: () async {
                            if (!model.enableDobEdit) {
                            } else {
                              final datePick = await showDatePicker(
                                context: context,
                                initialDate: new DateTime.utc(
                                  int.parse(await LocalStorageServices()
                                      .getDobEndRange()),
                                ),
                                firstDate: new DateTime(int.parse(
                                  await LocalStorageServices()
                                      .getDobStartRange(),
                                )),
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
                            }
                          },
                        ),
                        CategoryPickerWidget(
                          onChanged: (val) {
                            model.changeCategory(val);
                          },
                          viewOnly: model.disableFields,
                          listValues: model.categoryList!,
                          labelText: "Category",
                          hintText: "Select a category",
                          currentValue: model.selectedCategoryId,
                        ),
                        EducationDropdown(
                          labelText: "Education",
                          hintText: "Select highest Education",
                          viewOnly: model.disableFields,
                          currentValue: model.selectedEducation,
                          onChanged: (val) {
                            model.changeEducation(val);
                          },
                          listValues: model.educationalDetailsList,
                        ),
                      ],
                    ),
                  ))),
      ),
    );
  }
}
