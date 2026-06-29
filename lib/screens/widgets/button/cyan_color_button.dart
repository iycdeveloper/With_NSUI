import 'package:flutter/material.dart';

class UCyanButton extends StatelessWidget {
  const UCyanButton({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Container(
        margin: EdgeInsets.only(bottom: 20, top: 10),
        width: screenWidth * 0.85,
        height: screenHeight * 0.07,
        decoration: BoxDecoration(
          color: Color(0xff2cc7e2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0xffd6f9ff),
              offset: Offset(8, 8),
              blurRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
              height: 1,
              letterSpacing: 0.32,
              color: Color(0xffffffff),
            ),
          ),
        ),
      ),
    );
  }
}
