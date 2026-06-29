import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/screens/ui/membership/widgets/education_dropdown.dart';
import 'package:iyc/screens/ui/membership_ui/bottom_page_switcher.dart';
import 'package:iyc/screens/widgets/date_picker_widget.dart';
import 'package:iyc/screens/widgets/dropdown/category_picker.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/membership/membership_vm.dart';
import 'package:iyc/view_model/membership/personal_info_vm.dart';
import 'package:provider/provider.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({Key? key, this.memberId}) : super(key: key);
  final String? memberId;

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  void initState() {
    context.read<PersonalInfoVM>().checkForPrefillData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomPageSwitcher(
          actionNext: () {
            context.read<MembershipVM>().oneNext(1, context);
          },
          actionPrev: () {
            context.read<MembershipVM>().activeStepPrevious();
          },
        ),
        body: Consumer<PersonalInfoVM>(
            builder: (_, model, __) => model.isLoading
                ? NetworkLoading()
                : SingleChildScrollView(
                    child: Form(
                    key: model.secondFormKey,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Personal Information",
                            style: GoogleFonts.poppins(
                              textStyle:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ),
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
                            if (!model.enableDOBEdit && model.disableFields) {
                            } else {
                              final datePick = await showDatePicker(
                                context: context,
                                initialDate: new DateTime.utc(
                                  int.parse(await LocalStorageServices()
                                      .getDobEndRange()),
                                ),
                                firstDate:
                                    context.read<MembershipVM>().isLegalCellReg
                                        ? DateTime.now().subtract(Duration(
                                            days: 34500)) // about 90yrs age
                                        : new DateTime(int.parse(
                                            await LocalStorageServices()
                                                .getDobStartRange(),
                                          )),
                                lastDate: new DateTime(
                                    int.parse(
                                      await LocalStorageServices()
                                          .getDobEndRange(),
                                    ),
                                    12,
                                    31),
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
                          currentValue: model.selectedCategory,
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
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ))),
      ),
    );
  }
}
