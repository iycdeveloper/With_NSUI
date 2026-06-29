import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iyc/model/data_model/address.dart';
import 'package:iyc/provider/global/location_provider.dart';

import '../../di_container.dart';

class LocationEditVM extends ChangeNotifier {
  String formattedAddress = "";
  Address? selectedAddress;

  TextEditingController unitController = TextEditingController();
  TextEditingController houseApartmentController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  Address? initialAddress;

  bool isLoading = false;

  bool isFirstTime = true;

  toggleFirstTime(value) {
    isFirstTime = value;
    notifyListeners();
  }

  getLocationFromCameraPosition(LatLng latLng) async {
    final result = await sl<LocationProvider>().getGoogleAddress(latLng);
    if (result is Address) {
      selectedAddress = result;
      selectedAddress?.latitude = latLng.latitude;
      selectedAddress?.longitude = latLng.longitude;
      landmarkController.clear();
      populateFieldSelectedAddress(selectedAddress!);
      notifyListeners();
    }
  }

  initAddress(
    Address address,
  ) {
    initialAddress = address;
    selectedAddress = address;

    populateFieldSelectedAddress(selectedAddress!);
  }

  populateFieldSelectedAddress(Address selectedAddress) {
    unitController.text = selectedAddress.unitNumber ?? "";
    houseApartmentController.text = selectedAddress.houseNumber ?? "";
    landmarkController.text = selectedAddress.landmark ?? "";
    formattedAddress = selectedAddress.formattedAddress ?? "";
    debugPrint(selectedAddress.formattedAddress);
  }

  Address? populateModelFromField() {
    selectedAddress!.unitNumber = unitController.text;
    selectedAddress!.houseNumber = houseApartmentController.text;
    selectedAddress!.landmark = landmarkController.text;
    return selectedAddress;
  }
}
