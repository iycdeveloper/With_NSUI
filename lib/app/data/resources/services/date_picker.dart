import 'package:flutter/material.dart';
import 'package:iyc/utils/constants.dart';

 datePicker(BuildContext context){
  showDatePicker(
    context: context,
    initialDate: new DateTime.now(),
    firstDate: new DateTime(1950),
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
          dialogBackgroundColor: Constants.themeGradients[0],
        ),
        child: child!,
      );
    },
  );
}