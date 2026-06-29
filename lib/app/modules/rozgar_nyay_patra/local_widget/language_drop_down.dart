import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';

class LanguageDropDown extends StatelessWidget {
  const LanguageDropDown({
    Key? key,
    this.value,
    this.title,
    this.listValues,
    required this.onChanged,
    this.defaultMargin = true,
  });

  final String? title;
  final String? value;
  final List<DropdownItem>? listValues;
  final void Function(dynamic v) onChanged;
  final bool defaultMargin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          Get.dialog(
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  constraints: BoxConstraints(maxHeight: 326),
                  height: 47.0 * listValues!.length + 2,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color(0xFFC0D5F3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20.h,
                      top: 13.v,
                      bottom: 13.v,
                    ),
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                          listValues!.length,
                              (index) => GestureDetector(
                            onTap: () {
                              onChanged(listValues![index].value);
                              Get.back();
                            },
                            child: Container(
                              color: Colors.transparent,
                              margin: EdgeInsets.only(bottom: 3, top: 3),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        listValues![index].name,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      if (!(index ==
                                          (listValues!.length - 1)))
                                        SizedBox(height: 16.v),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
              ),
              barrierColor: Colors.transparent,
              barrierDismissible: true);
        },
        child: Center(
          child: Container(
            height: 28,
            width: 28,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Color(0xff2CC7E2),
                borderRadius: BorderRadius.circular(4)),
            child: Center(
              child: Text('$value'.toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),);
  }
}
