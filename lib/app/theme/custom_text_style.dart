import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLargeABeeZeeBlack900 =>
      theme.textTheme.bodyLarge!.aBeeZee.copyWith(
        color: appTheme.black900,
      );
  static get bodyLargeBlue80001 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blue80001,
      );
  static get bodyLargeBluegray300 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blueGray300,
      );
  static get bodyLargeBluegray300_1 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blueGray300,
      );
  static get bodyLargeGraphikBluegray40001 =>
      theme.textTheme.bodyLarge!.graphik.copyWith(
        color: appTheme.blueGray40001,
      );
  static get bodyLargeIndigo100 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.indigo100,
      );
  static get bodyLargeIndigo800 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.indigo800,
      );
  static get bodyLargeOnPrimaryContainer => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get bodyLargePoppinsOnPrimaryContainer =>
      theme.textTheme.bodyLarge!.poppins.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get bodyLargePrimary => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get bodyLargePrimary_1 => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get bodyLargeRubikBluegray40001 =>
      theme.textTheme.bodyLarge!.rubik.copyWith(
        color: appTheme.blueGray40001,
      );
  static get bodyLargeRubikBluegray40001_1 =>
      theme.textTheme.bodyLarge!.rubik.copyWith(
        color: appTheme.blueGray40001,
      );
  static get bodyMediumABeeZeeBlack900 =>
      theme.textTheme.bodyMedium!.aBeeZee.copyWith(
        color: appTheme.black900,
      );
  static get bodyMediumABeeZeeBlack90015 =>
      theme.textTheme.bodyMedium!.aBeeZee.copyWith(
        color: appTheme.black900,
        fontSize: 15.fSize,
      );
  static get bodyMediumABeeZeeOnPrimaryContainer =>
      theme.textTheme.bodyMedium!.aBeeZee.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 15.fSize,
      );
  static get bodyMediumBlue80001 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blue80001,
      );
  static get bodyMediumBluegray300 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray300.withOpacity(0.56),
      );
  static get bodyMediumBluegray70001 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray70001,
      );
  static get labelLargeOnPrimaryContainer_1 =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get titleMediumPrimary18 => theme.textTheme.titleMedium!.copyWith(
    color: theme.colorScheme.primary,
    fontSize: 18.fSize,
  );
  static get bodyMediumBluegray70001_1 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray70001.withOpacity(0.56),
      );
  static get bodyMediumBluegray70001_2 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray70001,
      );
  static get bodyMediumDeeporangeA700 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.deepOrangeA700,
      );
  static get bodyMediumGray5001 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray5001,
      );
  static get bodyMediumGray700 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray700,
      );
  static get bodyMediumGray90001 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray90001,
      );
  static get bodyMediumIndigo100 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.indigo100,
      );
  static get bodyMediumIndigo500 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.indigo500,
      );
  static get bodyMediumIndigo800 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.indigo800,
      );
  static get bodyMediumOnPrimaryContainer =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get bodyMediumOrange400 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.orange400,
      );
  static get bodyMediumPoppinsBlack900 =>
      theme.textTheme.bodyMedium!.poppins.copyWith(
        color: appTheme.black900,
        fontSize: 13.fSize,
      );
  static get bodyMediumPoppinsOnPrimaryContainer =>
      theme.textTheme.bodyMedium!.poppins.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 13.fSize,
      );
  static get bodyMediumPoppinsOnPrimaryContainer_1 =>
      theme.textTheme.bodyMedium!.poppins.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get bodyMediumPrimary => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get titleLargeBlack900 => theme.textTheme.titleLarge!.copyWith(
    color: appTheme.black900,
  );
  static get titleMediumGray90002 => theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray90002,
    fontWeight: FontWeight.w500,
  );
  static get bodyMediumProximaNovaBluegray700 =>
      theme.textTheme.bodyMedium!.proximaNova.copyWith(
        color: appTheme.blueGray700,
      );
  static get bodyMediumProximaNovaGray600 =>
      theme.textTheme.bodyMedium!.proximaNova.copyWith(
        color: appTheme.gray600,
      );
  static get bodyMediumTeal400 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.teal400,
      );
  static get bodySmallABeeZeeBlack900 =>
      theme.textTheme.bodySmall!.aBeeZee.copyWith(
        color: appTheme.black900.withOpacity(0.4),
        fontSize: 10.fSize,
      );
  static get bodySmallABeeZeeBlack90010 =>
      theme.textTheme.bodySmall!.aBeeZee.copyWith(
        color: appTheme.black900.withOpacity(0.45),
        fontSize: 10.fSize,
      );
  static get bodySmallABeeZeeOnPrimaryContainer =>
      theme.textTheme.bodySmall!.aBeeZee.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 10.fSize,
      );
  static get bodySmallBlue80001 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blue80001,
      );
  static get bodySmallBlue80003 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blue80003,
      );
  static get bodySmallBluegray300 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray300,
      );
  static get bodySmallErrorContainer => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.errorContainer,
      );
  static get bodySmallGray700 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray700,
      );
  static get bodySmallGreen500 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.green500,
      );
  static get bodySmallIndigo800 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.indigo800,
      );
  static get bodySmallOnPrimaryContainer => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get bodySmallProximaNovaGray800 =>
      theme.textTheme.bodySmall!.proximaNova.copyWith(
        color: appTheme.gray800,
      );
  static get bodySmallRubikOnPrimaryContainer =>
      theme.textTheme.bodySmall!.rubik.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 10.fSize,
      );
  static get bodySmallTeal400 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.teal400,
      );
  // Headline text style
  static get headlineSmallBlue80001 => theme.textTheme.headlineSmall!.copyWith(
        color: appTheme.blue80001,
      );
  static get headlineSmallBlue80001_1 =>
      theme.textTheme.headlineSmall!.copyWith(
        color: appTheme.blue80001,
      );
  static get headlineSmallIndigo800 => theme.textTheme.headlineSmall!.copyWith(
        color: appTheme.indigo800,
      );
  static get headlineSmallRubikGray900 =>
      theme.textTheme.headlineSmall!.rubik.copyWith(
        color: appTheme.gray900,
        fontWeight: FontWeight.w500,
      );
  // Label text style
  static get labelLargeBeVietnamProBluegray300 =>
      theme.textTheme.labelLarge!.beVietnamPro.copyWith(
        color: appTheme.blueGray300,
        fontSize: 12.fSize,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeBeVietnamProBluegray70001 =>
      theme.textTheme.labelLarge!.beVietnamPro.copyWith(
        color: appTheme.blueGray70001,
        fontSize: 12.fSize,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeBeVietnamProOnPrimaryContainer =>
      theme.textTheme.labelLarge!.beVietnamPro.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 12.fSize,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeOnPrimaryContainer =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 12.fSize,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeOnPrimaryContainerMedium =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 12.fSize,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeOnPrimaryContainerMedium12 =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 12.fSize,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeOnPrimaryContainerMedium12_1 =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 12.fSize,
        fontWeight: FontWeight.w500,
      );
  // Title text style
  static get titleLargeABeeZeeBlack900 =>
      theme.textTheme.titleLarge!.aBeeZee.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w400,
      );
  static get titleLargeBlue80001 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.blue80001,
      );
  static get titleLargeNunitoOnPrimaryContainer =>
      theme.textTheme.titleLarge!.nunito.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 22.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleLargeOnPrimaryContainer =>
      theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get titleLargeProximaNovaOnPrimaryContainer =>
      theme.textTheme.titleLarge!.proximaNova.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontWeight: FontWeight.w400,
      );
  static get titleMedium18 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.fSize,
      );
  static get titleMediumBlue10001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blue10001,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumBlue80001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blue80001,
      );
  static get titleMediumBluegray300 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray300,
      );
  static get titleMediumBluegray70001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray70001,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumGraphikBluegray40001 =>
      theme.textTheme.titleMedium!.graphik.copyWith(
        color: appTheme.blueGray40001,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumGray90001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray90001,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumGray90001_1 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray90001,
      );
  static get titleMediumIndigo80001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.indigo80001,
      );
  static get titleMediumMedium => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleMediumOnPrimaryContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontWeight: FontWeight.w700,
      );
  static get titleMediumOnPrimaryContainer18 =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 18.fSize,
      );
  static get titleMediumOnPrimaryContainerBold =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontWeight: FontWeight.w700,
      );
  static get titleMediumOnPrimaryContainerMedium =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontWeight: FontWeight.w500,
      );
  static get titleMediumOnPrimaryContainer_1 =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get titleMediumOnPrimaryContainer_2 =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get titleMediumPoppinsBlack900 =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumPoppinsOnPrimaryContainer =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 18.fSize,
      );
  static get titleMediumPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 18.fSize,
      );
  static get titleMediumPrimaryMedium => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumPrimary_1 => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get titleMediumPrimary_2 => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get titleMediumProximaNovaBluegray900 =>
      theme.textTheme.titleMedium!.proximaNova.copyWith(
        color: appTheme.blueGray900,
      );
  static get titleMediumProximaNovaOnPrimary =>
      theme.textTheme.titleMedium!.proximaNova.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 18.fSize,
      );
  static get titleMediumRubikDeeppurple400 =>
      theme.textTheme.titleMedium!.rubik.copyWith(
        color: appTheme.deepPurple400,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumRubikDeeppurple400Medium =>
      theme.textTheme.titleMedium!.rubik.copyWith(
        color: appTheme.deepPurple400,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumRubikOnPrimaryContainer =>
      theme.textTheme.titleMedium!.rubik.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontWeight: FontWeight.w500,
      );
  static get titleMediumTeal400 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.teal400,
      );
  static get titleSmallProximaNovaOnPrimaryContainer =>
      theme.textTheme.titleSmall!.proximaNova.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
}

extension on TextStyle {
  TextStyle get graphik {
    return copyWith(
      fontFamily: 'Graphik',
    );
  }

  TextStyle get proximaNova {
    return copyWith(
      fontFamily: 'Proxima Nova',
    );
  }

  TextStyle get beVietnamPro {
    return copyWith(
      fontFamily: 'Be Vietnam Pro',
    );
  }

  TextStyle get rubik {
    return copyWith(
      fontFamily: 'Rubik',
    );
  }

  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }

  TextStyle get aBeeZee {
    return copyWith(
      fontFamily: 'ABeeZee',
    );
  }

  TextStyle get nunito {
    return copyWith(
      fontFamily: 'Nunito',
    );
  }
}
