import 'package:flutter/material.dart';
/// will pop scope false for not closing widget
void showNetworkLoadingDialog(BuildContext context, {bool willPopScope = true, String msg = ''}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(onWillPop: ()async=>willPopScope,
        child: Dialog(
          backgroundColor: Colors.white,
              child: SizedBox(
                height: 100,
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                    if(msg.isNotEmpty)...[
                      const SizedBox(height: 20,),
                      Text(msg, style: TextStyle(color: Colors.black),)
                    ],
                  ],
                ),
              ),
            ),
      ));
}
