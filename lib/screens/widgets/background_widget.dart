import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackGroundWidget extends StatelessWidget {
  final Widget child;

  const BackGroundWidget({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: child,
        decoration: BoxDecoration(
          color: Colors.white,
        ));
  }
}
