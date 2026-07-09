import 'package:flutter/material.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/nusi/widgets/field_label_nsui.dart';
import 'package:iyc/utils/constants.dart';

class DatePickerWidgetNSUI extends StatelessWidget {
  final String? selectedDate;
  final Function onTap;
  final String labelText;
  final Color? labelcolor;
  final IconData? icon;
  final String? errorText;

  const DatePickerWidgetNSUI({
    Key? key,
    this.selectedDate,
    this.labelcolor,
    this.icon,
    required this.onTap,
    this.errorText,
    this.labelText = "DOB",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        alignment: Alignment.center,
        // padding: const EdgeInsets.only(top: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FieldLabelNSUI(icon: icon, label: labelText, color: labelcolor),
          GestureDetector(
              child: Container(
                margin: const EdgeInsets.only(top: 7),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE7EDF9)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4)),
                    ]),
                //Constants.formItemDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    selectedDate != null
                        ? Text(
                            selectedDate!,
                            style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.textTheme.bodyLarge!.color,
                                fontWeight: FontWeight.w500),
                          )
                        : Text(
                            "DD/MM/YYYY",
                            style:  Constants.formFieldItemTextStyle
                                    .copyWith(color: Colors.grey),
                          ),
                    // Icon(Icons.calendar_today_rounded)
                  ],
                ),
              ),
              onTap: () => onTap()),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                errorText!,
                style: const TextStyle(
                    color: Color(0xFFD32F2F),
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
        ]));
  }
}
