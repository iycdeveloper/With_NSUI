import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iyc/utils/constants.dart';

class DrawerItemSvg extends StatelessWidget {
  final String labelName;
  final String iconData;
  final Function onTap;
  final bool isPng;

  const DrawerItemSvg(
      {Key? key,
      required this.onTap,
      required this.iconData,
      required this.labelName,
      this.isPng = false})
      : super(key: key);
  const DrawerItemSvg.png(
      {Key? key,
      required this.onTap,
      required this.iconData,
      required this.labelName,
      this.isPng = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: this.isPng
            ? Image.asset(
                iconData,
                height: 30,
                width: 30,
              )
            : SvgPicture.asset(
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
