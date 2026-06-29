import 'package:flutter/material.dart';

class URoundEdgeContainer extends StatelessWidget {
  final Widget child;
  final List<double> marginLTRB;
  final double? width;
  URoundEdgeContainer({
    required this.child,
    this.marginLTRB = const [0, 0, 0, 0],
    this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(
            marginLTRB[0], marginLTRB[1], marginLTRB[2], marginLTRB[3]),
        padding: const EdgeInsets.all(10),
        color: Colors.transparent,
        child: Container(
            width: width ?? MediaQuery.of(context).size.width/2.4,

            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.white, // Set border color
                    width: 3.0), // Set border width
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0)), // Set rounded corner radius
                boxShadow: [
                  BoxShadow(
                      blurRadius: 2,
                      color: Colors.black54,
                      offset: Offset(1, 1))
                ] // Make rounded corner of border
                ),
            child: Center(child: child)));
  }
}
