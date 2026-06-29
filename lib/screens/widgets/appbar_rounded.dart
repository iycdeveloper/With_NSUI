import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iyc/utils/constants.dart';

class AppbarRounded extends StatelessWidget {
  const AppbarRounded({
    Key? key,
    required this.child,
    required this.title,
  }) : super(key: key);
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.themeGradients[0],
          title: Text(
            title,
            style: GoogleFonts.jacquesFrancois(
              textStyle:
                  TextStyle(color: Constants.themeGradients[1], fontSize: 25),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: child,
          ),
          //     child: Stack(children: [
          //   Container(
          //     color: Constants.themeGradients[0],
          //     height: 60,
          //   ),
          //   ClipRRect(
          //       borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          //       child:SingleChildScrollView(
          //           child: Container(
          //             color: Colors.white,
          //             child:child,
          //       ))),
          // ])
        ));
  }
}
