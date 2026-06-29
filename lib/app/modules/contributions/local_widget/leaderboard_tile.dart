import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';

class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xffC0D5F3), width: 1),
          color: Colors.white),
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                image: DecorationImage(
                    image: AssetImage(ImageConstant.img360f297243815))),
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            'C R Patil',
            style: TextStyle(
              color: Color(0xff244974),
              fontSize: 16,
            ),
          ),
          Spacer(),
          Text('1344',
            style: TextStyle(
                color: Color(0xff244974),
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
