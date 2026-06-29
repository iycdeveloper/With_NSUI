class ValidationProvider {
  String? validateEmail(String value) {
    String emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(emailPattern);
    if (!regex.hasMatch(value) || value.isEmpty) {
      return 'Please Enter a Valid Email ID';
    } else {
      return null;
    }
  }

  String? validateEmailHasValue(String value) {
    String emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(emailPattern);
    if (value.isNotEmpty && !regex.hasMatch(value)) {
      return 'Please Enter a Valid Email ID';
    } else {
      return null;
    }
  }

  String? validateEmptyField(String value, String errorText) {
    if (value.trim().isEmpty) {
      return errorText;
    } else {
      return null;
    }
  }

  String? validateEmptyAndAlphaField(String value, String errorText) {
    RegExp validStr = RegExp(r'^[a-zA-Z\s]+$');

    if (value.trim().isEmpty || !validStr.hasMatch(value)) {
      return errorText;
    } else {
      return null;
    }
  }

  String? validateAlphaField(String value, String errorText) {
    RegExp validStr = RegExp(r'^[a-zA-Z\s]+$');
    if (value.trim().isNotEmpty && !validStr.hasMatch(value)) {
      return errorText;
    } else {
      return null;
    }
  }

  String? validateEmptyAndNumericField(String value, String errorText) {
    RegExp validStr = RegExp(r'^[0-9]+$');

    if (value.trim().isEmpty || !validStr.hasMatch(value)) {
      return errorText;
    } else {
      return null;
    }
  }

  String? validateEmptyAndDecimalField(String value, String errorText) {
    RegExp validStr = RegExp(r'^[1-9]\d*(\.\d+)?$');

    if (value.trim().isEmpty || !validStr.hasMatch(value)) {
      return errorText;
    } else {
      return null;
    }
  }

  String? validateNumericField(String value, String errorText) {
    RegExp validStr = RegExp(r'^[0-9]+$');
    if (value.trim().isNotEmpty && !validStr.hasMatch(value)) {
      return errorText;
    } else {
      return null;
    }
  }

  String? validateEmptyAndAlphaNumericField(String value, String errorText) {
    RegExp validStr = RegExp(r'^[a-zA-Z0-9\s]+$');

    if (value.trim().isEmpty || !validStr.hasMatch(value)) {
      return errorText;
    } else {
      return null;
    }
  }

  String? validateAlphaNumericField(String value, String errorText) {
    RegExp validStr = RegExp(r'^[a-zA-Z0-9\s]+$');
    if (value.trim().isNotEmpty && !validStr.hasMatch(value)) {
      return errorText;
    } else {
      return null;
    }
  }

  String? validatePostalCodeNL(String value, String errorText) {
    bool isZipValid =
        RegExp(r'(\d{4}[ ]?[A-Z]{2})+$', caseSensitive: false).hasMatch(value);
    if (isZipValid) {
      return null;
    } else {
      return errorText;
    }
  }

  String? validateStreetName(String value, String errorText) {
    bool isZipValid =
        RegExp(r'^[#.0-9a-zA-Z\s,-]+$', caseSensitive: false).hasMatch(value);
    if (isZipValid) {
      return null;
    } else {
      return errorText;
    }
  }

  String? validateStreetNameField(String value, String errorText) {
    RegExp isZipValid = RegExp(r'^[#.0-9a-zA-Z\s,-]+$');
    print("isZipValid:$isZipValid");
    if (value.trim().isNotEmpty && !isZipValid.hasMatch(value)) {
      return errorText;
    } else {
      return null;
    }
  }

  validateNameField(String value, String errorText) {
    RegExp validStr = RegExp(r'^[a-zA-Z0-9\s]+$');

    if (value.trim().isEmpty || !validStr.hasMatch(value)) {
      return errorText;
    } else {
      return null;
    }
  }
}
