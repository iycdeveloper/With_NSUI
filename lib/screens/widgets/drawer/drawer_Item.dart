import 'package:flutter/material.dart';
import 'package:iyc/utils/constants.dart';

class DrawerItem extends StatelessWidget {
  final String labelName;
  final IconData iconData;
  final Function onTap;

  const DrawerItem(
      {Key? key,
      required this.onTap,
      required this.iconData,
      required this.labelName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          iconData,
          color: Constants.themeGradientsMain[0],
        ),
        title: Text(
          labelName,
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
