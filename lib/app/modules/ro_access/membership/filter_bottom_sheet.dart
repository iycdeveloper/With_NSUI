import 'package:flutter/material.dart';
import 'package:iyc/app/modules/ro_access/membership/membership_ro_controller.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import '../../../core/app_export.dart';

void roFilterBottomSheet() {
  mediaQueryData = MediaQuery.of(Get.context!);
  MemberShipRoController logic = Get.find<MemberShipRoController>();
  Get.bottomSheet(FilterBottomSheet(), ignoreSafeArea: false);
}

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemberShipRoController>(builder: (logic) {
      return SafeArea(
        child: Scaffold(
          body: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
              width: double.maxFinite,
              // height: 500.v,
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.symmetric(horizontal: 20.adaptSize),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10.v,
                            ),
                            Text(
                              'Filter',
                              style: TextStyle(
                                  color: Color(0xff244974),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10.v,
                            ),
                            Text(
                              'Reason Filter',
                              style: TextStyle(
                                  color: Color(0xff869DB6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        IconButton(onPressed: Get.back, icon: Icon(Icons.cancel))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  Padding(
                      padding: EdgeInsets.only(left: 20.h, right: 20.h),
                      child: Column(
                        children: List.generate(
                            logic.reasonFilter.keys.toList().length,
                            (index) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${logic.reasonFilter.keys.toList()[index]}'),
                                    Checkbox(
                                        value: logic.valueInSelectedFilter('${logic.reasonFilter.values
                                                .toList()[index]}'),
                                        onChanged: (value) {
                                          Log.printILog(logic.selectedFilter);
                                          if (logic.selectedFilter.contains(
                                              logic.reasonFilter.values
                                                  .toList()[index])) {
                                            logic.removeFilter(
                                                '${logic.reasonFilter.values.toList()[index]}');
                                          } else {
                                            logic.addFilter(
                                                '${logic.reasonFilter.values.toList()[index]}');
                                          }
                                        })
                                  ],
                                )),
                      )),
              SizedBox(height: 20,),
                ElevatedButton(onPressed: logic.clearFilter, child: Padding(padding: EdgeInsets.all(8), child: Text('Clear'),),)
                ],
              )),
        ),
      );
    });
  }
}
