import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class URoundCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  const URoundCard({Key? key, required this.child, this.color, this.padding})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}
