import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/api_model/reports/booth_jodo_report_model.dart';

class AggregatorTile extends StatelessWidget {
  const AggregatorTile(this.data, this.showDetails);
  final BoothJodoReportModel data;
  final bool showDetails;
  @override
  Widget build(BuildContext context) {
    return showDetails
        ? Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xffC0D5F3), width: 1)),
      child: Column(
        children: [
          Container(
            height: 62,
            width: double.maxFinite,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                color: Color(0xff244974)),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${data.name}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Text('Name',
                        style: TextStyle(
                            color: Color(0xffB1C9E2),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 56.v,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                  Color(0xffC0D5F3), // Choose your border color here
                  width: 1.0, // Choose the width of the border
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  'District',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff869DB6),
                  ),
                ),
                Spacer(),
                Text(
                  data.districtName!,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff244974),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          Container(
            height: 56.v,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                  Color(0xffC0D5F3), // Choose your border color here
                  width: 1.0, // Choose the width of the border
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Assembly',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff869DB6),
                  ),
                ),
                Spacer(),
                Text(
                  data.assemblyName!,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff244974),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          Container(
            height: 56.v,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                  Color(0xffC0D5F3), // Choose your border color here
                  width: 1.0, // Choose the width of the border
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff869DB6),
                  ),
                ),
                Spacer(),
                Text(
                  data.total!,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff244974),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          Container(
            height: 56.v,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                  Color(0xffC0D5F3), // Choose your border color here
                  width: 1.0, // Choose the width of the border
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Verified Numbers',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff869DB6),
                  ),
                ),
                Spacer(),
                Text(
                  '${data.verifiedNumbers}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff244974),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          Container(
            height: 56.v,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                  Color(0xffC0D5F3), // Choose your border color here
                  width: 1.0, // Choose the width of the border
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Booth Count',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff869DB6),
                  ),
                ),
                Spacer(),
                Text('${data.verifiedBooth}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff244974),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    )
        : Container(
      height: 64.v,
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xffC0D5F3), width: 1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200.h,
                  height: 20.v,
                  child: Text(
                    '${data.name}',
                    style: TextStyle(
                        color: Color(0xff244974),
                        fontSize: 16,
                        overflow: TextOverflow.fade,
                        fontWeight: FontWeight.w500),

                  ),
                ),
                Text('Name',
                  style: TextStyle(
                      color: Color(0xff1356BF),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xff244974),
            )
          ],
        ),
      ),
    );
  }
}
