import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/nusi/widgets/field_label_nsui.dart';
import 'package:iyc/utils/constants.dart';

class TextFieldWithLabelNSUI extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final String label;
  final TextInputType? keyBoardType;
  final Function(String)? validation;
  final Function()? onTap;
  final double textFieldHeight;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final Function()? onSubmit;
  final TextInputAction? inputAction;
  final int? maxLength;
  final bool readOnly;
  final bool centerLabel;
  final TextStyle? textStyle;
  final int maxline;
  final Color? labelcolor;
  final List<TextInputFormatter>? inputFormatters;
  const TextFieldWithLabelNSUI(
      {Key? key,
      this.hintText,
      this.icon,
      this.textFieldHeight = 55,
      this.controller,
      required this.label,
      this.keyBoardType,
      this.onTap,
      this.validation,
      this.focusNode,
      this.maxLength,
      this.onSubmit,
      this.nextFocus,
      this.readOnly = false,
      this.inputAction,
      this.textStyle,
      this.centerLabel = false,
      this.inputFormatters,
      this.labelcolor,
      this.maxline = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        crossAxisAlignment:
            centerLabel ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          FieldLabelNSUI(icon: icon, label: label, color: labelcolor),
          // Container(
          //     height: textFieldHeight,
          //     margin: EdgeInsets.only(top: 7),
          //     decoration: Constants.formItemDecoration,
          //     // decoration: BoxDecoration(
          //     //     borderRadius: BorderRadius.circular(30),
          //     //     color: Colors.lightBlueAccent.withOpacity(0.15)),
          //     child:
          TextFormField(
            maxLines: maxline,
            focusNode: focusNode,
            maxLength: maxLength,
            onTap: onTap,
            textInputAction: inputAction,
            onFieldSubmitted: (v) => onSubmit,
            onEditingComplete: () {
              nextFocus != null
                  ? FocusScope.of(context).requestFocus(nextFocus)
                  : FocusScope.of(context).unfocus();
            },
            validator: validation != null ? (str) => validation!(str!) : null,
            controller: controller,
            keyboardType: keyBoardType,

            /// limited at only all alpha and few special text characters are to be tappable
            inputFormatters: inputFormatters ??
                (keyBoardType == null
                    ? null
                    : <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp(
                              r'[a-zA-Z0-9@._\-+ ]'), //new with undercode regx
                        )
                        // new FilteringTextInputFormatter.allow(
                        //     RegExp('[A-Za-z0-9\-@,\. ]')
                        // )//old
                      ]),
            readOnly: readOnly,

            // enabled: !readOnly,
            autocorrect: true,
            style: textStyle ??
                theme.textTheme.bodyLarge!.copyWith(
                    color: theme.textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w500),
            // GoogleFonts.poppins(
            //   textStyle: TextStyle(
            //       color: Constants.themeTextGradients[1], fontSize: 16),
            // ),
            decoration: InputDecoration(
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
                borderSide: BorderSide(color: Colors.grey[200]!, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey[200]!, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey[200]!, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey[200]!, width: 2),
              ),
            ),
            // decoration: InputDecoration(
            //   counterText: "",
            //   contentPadding: EdgeInsets.all(15),
            //   border: InputBorder.none,
            //   hintText: hintText,
            //   hintStyle: TextStyle(color: Colors.grey),
            //   //filled: true,
            //   //fillColor: Colors.grey.shade100,
            //   // enabledBorder: OutlineInputBorder(
            //   //   borderRadius: BorderRadius.all(Radius.circular(22.0)),
            //   //   borderSide: BorderSide(color: Colors.grey, width: 1),
            //   // ),
            //   // focusedBorder: OutlineInputBorder(
            //   //   borderRadius: BorderRadius.all(Radius.circular(20.0)),
            //   //   borderSide: BorderSide(color: Colors.grey),
            //   // ),
            // ),
          ),
        ],
      ),
    );
  }
}
