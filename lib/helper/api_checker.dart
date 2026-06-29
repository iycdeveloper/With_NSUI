import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/twitter/twitter_provider.dart';
import 'package:provider/provider.dart';

class ApiChecker {
  static void checkApi(BuildContext context, ApiResponse apiResponse) {
    if (apiResponse.error is! String &&
        apiResponse.error.errors[0].message == 'Unauthenticated.') {
      // Provider.of<TwitterProvider>(context, listen: false).removeSharedData();
      // Navigator.pushNamedAndRemoveUntil(context, Routes.getLoginRoute(), (route) => false);
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_errorMessage, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red));
    }
  }
}
