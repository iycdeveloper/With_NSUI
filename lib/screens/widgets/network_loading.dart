import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/utils/constants.dart';



class NetworkLoading extends StatelessWidget {
  const NetworkLoading({
  Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SpinKitFadingCube(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0XFF2CC7E2),
              ),
            );
          },
        ));
  }
}
