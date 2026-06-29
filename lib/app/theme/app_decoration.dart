import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillAmber => BoxDecoration(
    color: appTheme.amber600,
  );
  static BoxDecoration get fillBlack => BoxDecoration(
    color: appTheme.black900.withOpacity(0.11),
  );
  static BoxDecoration get fillBlue => BoxDecoration(
    color: appTheme.blue80001,
  );
  static BoxDecoration get fillDeepOrange => BoxDecoration(
    color: appTheme.deepOrange400,
  );
  static BoxDecoration get fillDeepPurple => BoxDecoration(
    color: appTheme.deepPurple40001,
  );
  static BoxDecoration get fillDeeppurple400 => BoxDecoration(
    color: appTheme.deepPurple400,
  );
  static BoxDecoration get fillGray => BoxDecoration(
    color: appTheme.gray5001,
  );
  static BoxDecoration get fillGray50 => BoxDecoration(
    color: appTheme.gray50,
  );
  static BoxDecoration get fillGreen => BoxDecoration(
    color: appTheme.green300,
  );
  static BoxDecoration get fillIndigo => BoxDecoration(
    color: appTheme.indigo700,
  );
  static BoxDecoration get fillOnPrimary => BoxDecoration(
    color: theme.colorScheme.onPrimary,
  );
  static BoxDecoration get fillPink => BoxDecoration(
    color: appTheme.pink50,
  );
  static BoxDecoration get fillPrimary => BoxDecoration(
    color: theme.colorScheme.primary,
  );
  static BoxDecoration get fillPrimary1 => BoxDecoration(
    color: theme.colorScheme.primary.withOpacity(0.42),
  );
  static BoxDecoration get fillRed => BoxDecoration(
    color: appTheme.red200,
  );
  static BoxDecoration get fillTeal => BoxDecoration(
    color: appTheme.teal5001,
  );

  // Gradient decorations

  static BoxDecoration get gradientCyanToIndigo => BoxDecoration(
    gradient: LinearGradient(
      begin: const Alignment(0.37, 0.24),
      end: const Alignment(0.95, 2.1),
      colors: [
        appTheme.cyanA400,
        appTheme.indigo700,
      ],
    ),
  );

  static BoxDecoration get outlineBlue5001 => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border.all(
      color: appTheme.blue5001,
      width: 1.h,
    ),
  );
  static BoxDecoration get gradientDeepPurpleToOnErrorContainer =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0, 0.5),
          end: const Alignment(1, 0.5),
          colors: [
            appTheme.deepPurple60001,
            theme.colorScheme.onErrorContainer,
          ],
        ),
      );
  static BoxDecoration get gradientGrayToGray => BoxDecoration(
    gradient: LinearGradient(
      begin: const Alignment(0.5, 0.5),
      end: const Alignment(0.5, 1.07),
      colors: [
        appTheme.gray20001,
        appTheme.gray30000,
      ],
    ),
  );
  static BoxDecoration get gradientPrimaryToIndigo => BoxDecoration(
    gradient: LinearGradient(
      begin: const Alignment(0.5, 0),
      end: const Alignment(0.5, 1),
      colors: [
        theme.colorScheme.primary,
        appTheme.indigo700,
      ],
    ),
  );
  static BoxDecoration get gradientPrimaryToIndigo700 => BoxDecoration(
    gradient: LinearGradient(
      begin: const Alignment(0.37, 0.24),
      end: const Alignment(0.95, 2.1),
      colors: [
        theme.colorScheme.primary,
        appTheme.indigo700,
      ],
    ),
  );

  // Heading decorations
  static BoxDecoration get heading => BoxDecoration(
    color: appTheme.indigo800,
  );

  // Outline decorations
  static BoxDecoration get outline => const BoxDecoration();
  static BoxDecoration get outlineBlack => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withOpacity(0.25),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: const Offset(
          0,
          4,
        ),
      ),
    ],
  );
  static BoxDecoration get outlineBlack900 => BoxDecoration(
    border: Border.all(
      color: appTheme.black900.withOpacity(0.07),
      width: 1.h,
      // strokeAlign: strokeAlignCenter,
    ),
  );
  static BoxDecoration get outlineBlack9001 => BoxDecoration(
    border: Border.all(
      color: appTheme.black900.withOpacity(0.03),
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineBlack9002 => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withOpacity(0.5),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: const Offset(
          0,
          0,
        ),
      ),
    ],
  );
  static BoxDecoration get outlineBlue => BoxDecoration(
    border: Border(
      top: BorderSide(
        color: appTheme.blue10001,
        width: 1.h,
      ),
    ),
  );
  static BoxDecoration get outlineBlue10001 => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border(
      top: BorderSide(
        color: appTheme.blue10001,
        width: 1.h,
      ),
    ),
  );
  static BoxDecoration get outlineBlue100011 => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border.all(
      color: appTheme.blue10001,
      width: 1.h,
    ),
    boxShadow: [
      BoxShadow(
        color: appTheme.blue700.withOpacity(0.05),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: const Offset(
          0,
          0,
        ),
      ),
    ],
  );
  static BoxDecoration get outlineBlue100012 => BoxDecoration(
    border: Border.all(
      color: appTheme.blue10001,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineBlue100013 => BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: appTheme.blue10001,
        width: 1.h,
      ),
    ),
  );
  static BoxDecoration get outlineBlue100014 => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border(
      top: BorderSide(
        color: appTheme.blue10001,
        width: 1.h,
      ),
    ),
  );
  static BoxDecoration get outlineBlue100015 => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border(
      left: BorderSide(
        color: appTheme.blue10001,
        width: 1.h,
      ),
      bottom: BorderSide(
        color: appTheme.blue10001,
        width: 1.h,
      ),
      right: BorderSide(
        color: appTheme.blue10001,
        width: 1.h,
      ),
    ),
  );
  static BoxDecoration get outlineBlue5002 => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border.all(
      color: appTheme.blue5002,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineBlue50021 => BoxDecoration(
    border: Border.all(
      color: appTheme.blue5002,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineBlue50022 => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border.all(
      color: appTheme.blue5002,
      width: 1.h,
    ),
    boxShadow: [
      BoxShadow(
        color: appTheme.blue700.withOpacity(0.05),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: const Offset(
          0,
          0,
        ),
      ),
    ],
  );
  static BoxDecoration get outlineBlue50023 => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border.all(
      color: appTheme.blue5002,
      width: 1.h,
    ),
    boxShadow: [
      BoxShadow(
        color: appTheme.blue700.withOpacity(0.1),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: const Offset(
          0,
          0,
        ),
      ),
    ],
  );
  static BoxDecoration get outlineBlue700 => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    boxShadow: [
      BoxShadow(
        color: appTheme.blue700.withOpacity(0.05),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: const Offset(
          0,
          0,
        ),
      ),
    ],
  );
  static BoxDecoration get outlineBlueGray => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border.all(
      color: appTheme.blueGray70001,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineGray => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    boxShadow: [
      BoxShadow(
        color: appTheme.gray200,
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: const Offset(
          0,
          1,
        ),
      ),
    ],
  );
  static BoxDecoration get outlineGray200 => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border(
      top: BorderSide(
        color: appTheme.gray200,
        width: 1.h,
      ),
    ),
  );
  static BoxDecoration get outlineIndigo => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border.all(
      color: appTheme.indigo5002,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineIndigo50 => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border.all(
      color: appTheme.indigo50,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineIndigo5001 => BoxDecoration(
    color: appTheme.gray10001,
    border: Border.all(
      color: appTheme.indigo5001,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineLime => BoxDecoration(
    color: appTheme.yellow50,
    border: Border.all(
      color: appTheme.lime100,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineOnPrimaryContainer => BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        width: 1.h,
      ),
    ),
  );
  static BoxDecoration get outlineOrange => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border.all(
      color: appTheme.orange50,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineOrange50 => BoxDecoration(
    color: appTheme.yellow50,
    border: Border.all(
      color: appTheme.orange50,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlinePink => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border.all(
      color: appTheme.pink100,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlinePrimary => BoxDecoration(
    color: appTheme.gray5001,
    border: Border(
      bottom: BorderSide(
        color: theme.colorScheme.primary,
        width: 1.h,
      ),
    ),
  );
  static BoxDecoration get outlinePrimary1 => BoxDecoration(
    color: theme.colorScheme.primary,
    boxShadow: [
      BoxShadow(
        color: theme.colorScheme.primary.withOpacity(0.4),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: const Offset(
          0,
          4,
        ),
      ),
    ],
  );
  static BoxDecoration get outlinePrimary2 => BoxDecoration(
    color: theme.colorScheme.primary,
    border: Border.all(
      color: theme.colorScheme.primary,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineRed => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border.all(
      color: appTheme.red10001,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineRed100 => BoxDecoration(
    color: appTheme.red50,
    border: Border.all(
      color: appTheme.red100,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineSecondaryContainer => BoxDecoration(
    color: appTheme.indigo800,
    boxShadow: [
      BoxShadow(
        color: theme.colorScheme.secondaryContainer,
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: const Offset(
          0,
          0,
        ),
      ),
    ],
  );
  static BoxDecoration get outlineTeal => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border.all(
      color: appTheme.teal50,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineTeal5002 => BoxDecoration(
    color: appTheme.gray100,
    border: Border.all(
      color: appTheme.teal5002,
      width: 1.h,
    ),
  );
  static BoxDecoration get outline1 => const BoxDecoration();

  // Stroke decorations
  static BoxDecoration get stroke => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border.all(
      color: appTheme.blue10001,
      width: 1.h,
    ),
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withOpacity(0.1),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: const Offset(
          0,
          10,
        ),
      ),
    ],
  );
  static BoxDecoration get strokeHeading => BoxDecoration(
    color: appTheme.indigo800,
    border: Border(
      bottom: BorderSide(
        color: appTheme.blue10001,
        width: 1.h,
      ),
    ),
  );
  static BoxDecoration get strokeWhite => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    border: Border.all(
      color: appTheme.blue10001,
      width: 1.h,
    ),
  );

  // White decorations
  static BoxDecoration get white => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
  );
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder30 => BorderRadius.circular(
    30.h,
  );
  static BorderRadius get circleBorder36 => BorderRadius.circular(
    36.h,
  );

  // Custom borders
  static BorderRadius get customBorderBL12 => BorderRadius.vertical(
    bottom: Radius.circular(12.h),
  );
  static BorderRadius get customBorderBL16 => BorderRadius.vertical(
    bottom: Radius.circular(16.h),
  );
  static BorderRadius get customBorderBL20 => BorderRadius.vertical(
    bottom: Radius.circular(20.h),
  );
  static BorderRadius get customBorderLR8 => BorderRadius.horizontal(
    right: Radius.circular(8.h),
  );
  static BorderRadius get customBorderTL12 => BorderRadius.vertical(
    top: Radius.circular(12.h),
  );
  static BorderRadius get customBorderTL16 => BorderRadius.vertical(
    top: Radius.circular(16.h),
  );
  static BorderRadius get customBorderTL32 => BorderRadius.vertical(
    top: Radius.circular(32.h),
  );
  static BorderRadius get customBorderTL40 => BorderRadius.vertical(
    top: Radius.circular(40.h),
  );
  static BorderRadius get customBorderTL8 => BorderRadius.vertical(
    top: Radius.circular(8.h),
  );

  // Rounded borders
  static BorderRadius get roundedBorder12 => BorderRadius.circular(
    12.h,
  );
  static BorderRadius get roundedBorder16 => BorderRadius.circular(
    16.h,
  );
  static BorderRadius get roundedBorder2 => BorderRadius.circular(
    2.h,
  );
  static BorderRadius get roundedBorder20 => BorderRadius.circular(
    20.h,
  );
  static BorderRadius get roundedBorder24 => BorderRadius.circular(
    24.h,
  );
  static BorderRadius get roundedBorder8 => BorderRadius.circular(
    8.h,
  );
}

