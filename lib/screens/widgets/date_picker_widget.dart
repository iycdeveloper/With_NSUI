import 'package:flutter/material.dart';
import 'package:iyc/utils/constants.dart';

class DatePickerWidget extends StatelessWidget {
  final String? selectedDate;
  final Function onTap;
  final String labelText;

  const DatePickerWidget({
    Key? key,
    this.selectedDate,
    required this.onTap,
    this.labelText = "DOB",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            labelText,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          GestureDetector(
              child: Container(
                margin: EdgeInsets.only(top: 7),
                padding: EdgeInsets.all(15),
                decoration: Constants.formItemDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        selectedDate ?? "Select a Date",
                        style: Constants.formFieldItemTextStyle
                            .copyWith(color: Colors.grey),
                      ),
                    ),
                    // Icon(Icons.calendar_today_rounded)
                  ],
                ),
              ),
              onTap: () => onTap()),
        ]));
  }
}
