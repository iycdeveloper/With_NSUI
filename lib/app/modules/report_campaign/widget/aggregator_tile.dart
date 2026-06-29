import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/api_model/reports/booth_jodo_report_model.dart';

class CampaignAggregatorTile extends StatelessWidget {
  const CampaignAggregatorTile(this.data, this.showDetails);
  final BoothJodoReportModel data;
  final bool showDetails;
  @override
  Widget build(BuildContext context) {
    return showDetails
        ? Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffC0D5F3), width: 1)),
      child: Column(
        children: [
          Container(
            height: 62,
            width: double.maxFinite,
            decoration: const BoxDecoration(
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
                      ///1356BF
                      Text('${data.name}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      const Text('Name',
                        style: TextStyle(
                            color: Color(0xffB1C9E2),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 56.v,
            decoration: const BoxDecoration(
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
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'District',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff869DB6),
                  ),
                ),
                const Spacer(),
                Text(
                  data.districtName!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff244974),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          Container(
            height: 56.v,
            decoration: const BoxDecoration(
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
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'State',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff869DB6),
                  ),
                ),
                const Spacer(),
                Text('${data.stateCode}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff244974),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          Container(
            height: 56.v,
            decoration: const BoxDecoration(
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
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'Assembly',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff869DB6),
                  ),
                ),
                const Spacer(),
                Text(
                  data.assemblyName!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff244974),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          Container(
            height: 56.v,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff869DB6),
                  ),
                ),
                const Spacer(),
                Text(
                  data.total!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff244974),
                  ),
                ),
                const SizedBox(
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
          border: Border.all(color: const Color(0xffC0D5F3), width: 1)),
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
                    style: const TextStyle(
                        color: Color(0xff244974),
                        fontSize: 16,
                        overflow: TextOverflow.fade,
                        fontWeight: FontWeight.w500),

                  ),
                ),
                const Text('Name',
                  style: TextStyle(
                      color: Color(0xff1356BF),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xff244974),
            )
          ],
        ),
      ),
    );
  }
}
