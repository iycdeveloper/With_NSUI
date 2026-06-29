import 'package:flutter/material.dart';
import 'package:iyc/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String labelText;
  final Function onTap;

  const CustomButton({Key? key, required this.labelText, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.height * 1,
          color: Constants.themeGradients[0],
          alignment: Alignment.center,
          child: Text(
            labelText,
            style: TextStyle(color: Constants.themeGradients[1], fontSize: 20),
          ),
        ));
  }
}
