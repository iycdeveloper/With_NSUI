import 'package:flutter/material.dart';

class EducationalDetails {
  String educationalDetails;

  EducationalDetails({required this.educationalDetails});

  EducationalDetails.fromJson(Map<String, dynamic> json)
      : educationalDetails = json['educational_details'];

  Map<String, dynamic> toJson() => {
    'educational_details': educationalDetails,
  };
}


class SingleItemModel {
  String name;
  SingleItemModel(this.name, );
}