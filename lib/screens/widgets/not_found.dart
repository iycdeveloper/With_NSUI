import 'package:flutter/material.dart';


class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
           Text('Page Not Found',style: TextStyle(fontWeight: FontWeight.bold))
      ),
    );
  }
}
