import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static final rupeeSymbol = "\u20B9";

  ///Colors///
  static List<Color> themeGradients = [
    const Color.fromRGBO(25, 170, 237, 1),
    const Color.fromRGBO(255, 255, 255, 1),
    Colors.grey
  ];
  static List<Color> themeGradientsMain = [
    const Color.fromRGBO(25, 170, 237, 1),
  ];
  static List<Color> themeTextGradients = [
    Colors.black.withOpacity(0.7),
    const Color(0xff10436C),
    Colors.black.withOpacity(0.5),
  ];
  static List<Color> kitThemeGradients = [
    const Color(0xffBCBCBC),
    const Color(0xffFF7A39),
    const Color(0xff00A911),
    const Color(0xffF6F6F6),
    const Color(0xff909090),
  ];

  ///TextStyles///
  static TextStyle name =
      const TextStyle(fontSize: 14, color: Colors.white, fontFamily: "Montserrat");
  static TextStyle text =
      const TextStyle(fontSize: 12, color: Colors.black, fontFamily: "Montserrat");
  static TextStyle time =
      const TextStyle(fontSize: 10, color: Colors.black, fontFamily: "Montserrat");
  static TextStyle leaderBoardCardTile = GoogleFonts.actor(
    textStyle: TextStyle(color: Constants.themeTextGradients[1], fontSize: 20),
  );
  static TextStyle leaderBoardCardItemName = GoogleFonts.actor(
    textStyle: TextStyle(color: Constants.themeTextGradients[0], fontSize: 15),
  );
  static TextStyle leaderBoardCardItemValue = GoogleFonts.roboto(
    textStyle: TextStyle(
        color: Constants.themeTextGradients[1],
        fontSize: 18,
        fontWeight: FontWeight.w600),
  );
  static TextStyle formItemText = GoogleFonts.poppins(
    textStyle: TextStyle(color: Constants.themeTextGradients[1], fontSize: 14),
  );
  static TextStyle preLinkText = GoogleFonts.poppins(
    fontSize: 12,
    color: const Color(0xff8C8C8C),
  );
  static TextStyle linkText =
      GoogleFonts.poppins(fontSize: 12, color: Colors.blue);

  ///appbar
  static TextStyle appbarTitleTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(color: Constants.themeGradients[1], fontSize: 16),
  );

  ///membership page
  static TextStyle membershipStatusPending = TextStyle(
      color: Constants.kitThemeGradients[1], fontWeight: FontWeight.bold);
  static TextStyle membershipStatusComplete =
      const TextStyle(color: Colors.green, fontWeight: FontWeight.bold);

  ///survey page
  static TextStyle surveyQuestion =
      const TextStyle(fontWeight: FontWeight.w500, fontSize: 15);
  static TextStyle surveyToggleSelected =
      const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700);
  static TextStyle surveyToggleUnSelected = const TextStyle(
      color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500);

  ///feeds
  static TextStyle feedsTitle = GoogleFonts.laila(
    textStyle: TextStyle(
        color: Constants.themeGradientsMain[0],
        fontWeight: FontWeight.w400,
        fontSize: 14),
  );
  static TextStyle feedsPostTime = GoogleFonts.laila(
      textStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w300,
          color: Colors.black,
          fontFamily: "Montserrat"));
  static BoxDecoration feedsBox = BoxDecoration(
    border: Border.all(
      width: 1.0,
      color: Colors.grey,
    ),
    borderRadius: const BorderRadius.all(
        Radius.circular(15.0) //                 <--- border radius here
        ),
  );

  /// form items
  static BoxDecoration formItemDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(
      10,
    ),
    border: Border.all(color: Constants.themeGradients[0]),
  );

  ///nomination
  static TextStyle formFieldItemTextStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w300);
}
