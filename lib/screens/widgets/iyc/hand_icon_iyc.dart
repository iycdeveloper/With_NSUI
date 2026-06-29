import 'package:flutter/material.dart';
class HandIconIYC extends StatelessWidget {
  const HandIconIYC({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 55,
        height: 90,
        child: Image.asset(
          "assets/icons/hand_icon3x.png",
          fit: BoxFit.fill,
        ));
  }
}