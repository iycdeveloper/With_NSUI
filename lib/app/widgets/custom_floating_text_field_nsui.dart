import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/utils/constants.dart';

class CustomFloatingTextFieldNSUI extends StatelessWidget {
  CustomFloatingTextFieldNSUI(
      {Key? key,
      this.readOnly = false,
      this.alignment,
      this.width,
      this.margin,
      this.controller,
      this.focusNode,
      this.autofocus = true,
      this.textStyle,
      this.obscureText = false,
      this.textInputAction = TextInputAction.done,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.hintStyle,
      this.labelText,
      this.labelStyle,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = true,
      this.validator,
      this.inputFormatters,
      this.labelcolor,
      this.onTap})
      : super(
          key: key,
        );

  final List<TextInputFormatter>? inputFormatters;
  final Alignment? alignment;

  final double? width;

  final EdgeInsetsGeometry? margin;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;
  final bool readOnly;
  final TextStyle? textStyle;

  final bool? obscureText;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final String? labelText;

  final TextStyle? labelStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;
  final Color? labelcolor;

  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: floatingTextFieldWidget,
          )
        : floatingTextFieldWidget;
  }

  Widget get floatingTextFieldWidget => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),

        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              labelText!,
              style: TextStyle(
                  color: labelcolor ?? Colors.blueAccent, fontSize: 14),
            ),
            Container(
              width: width ?? double.maxFinite,
              margin: margin,
              child: TextFormField(
                onTap: onTap ?? () {},
                readOnly: readOnly,
                controller: controller,
                style: textStyle ?? theme.textTheme.bodyLarge!.copyWith(
                    color: theme.textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w500),
                // CustomTextStyles.bodyMediumBluegray70001,
                obscureText: obscureText!,
                textInputAction: textInputAction,
                keyboardType: textInputType,
                maxLines: maxLines ?? 1,
                decoration: decorationNew,
                validator: validator,
                inputFormatters: inputFormatters ?? [],
              ),
            ),
          ],
        ),
      );


     InputDecoration get decorationNew => InputDecoration(
              // hoverColor: Colors.white,
              errorStyle: TextStyle(color: Colors.redAccent[100]),
              contentPadding: const EdgeInsets.all(15),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle:
                  theme.textTheme.bodyMedium!.copyWith(color: Colors.grey),
              // hintStyle: TextStyle(color: Constants.themeGradientsMain[0],fontWeight: FontWeight.w400),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey[100]!, width: 3),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey[100]!, width: 3),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey[100]!, width: 3),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey[100]!, width: 3),
              ),
            );
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? Constants.formFieldItemTextStyle,
        // labelText: labelText ?? "",
        labelStyle: theme.textTheme.bodyLarge,
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        contentPadding:
            contentPadding ?? EdgeInsets.fromLTRB(15.h, 20.v, 11.h, 11.v),
        fillColor:
            fillColor ?? theme.colorScheme.onPrimaryContainer.withOpacity(1),
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.h),
              borderSide: BorderSide(
                color: Colors.blueAccent,
                width: 1,
              ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.h),
              borderSide: BorderSide(
                color: Colors.blueAccent,
                width: 1,
              ),
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.h),
              borderSide: BorderSide(
                color: Colors.blueAccent,
                // width: 2,
              ),
            ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.h),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.h),
          borderSide: BorderSide(
            color: appTheme.deepOrange800,
            width: 1,
          ),
        ),
      );
}

/// Extension on [CustomFloatingTextField] to facilitate inclusion of all types of border style etc
extension FloatingTextFormFieldStyleHelper on CustomFloatingTextFieldNSUI {
  static OutlineInputBorder get custom => OutlineInputBorder(
        borderSide: BorderSide.none,
      );
  static OutlineInputBorder get outlineBlueTL8 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.h),
        borderSide: BorderSide(
          color: appTheme.blue10001,
          width: 1,
        ),
      );
}
