import 'package:flutter/material.dart';

class BottomPageSwitcher extends StatelessWidget {
  const BottomPageSwitcher(
      {Key? key,
      this.titlePrev,
      this.actionPrev,
      this.titleNext,
      this.actionNext})
      : super(key: key);
  final String? titlePrev;
  final Function()? actionPrev;

  final String? titleNext;
  final Function()? actionNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue.shade300,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: InkWell(
              child: Text(
                titlePrev ?? "Prev",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              onTap: actionPrev,
            ),
          ),
          Expanded(
            child: InkWell(
              child: Text(titleNext ?? "Next",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              onTap: actionNext,
            ),
          )
        ],
      ),
    );
  }
}
