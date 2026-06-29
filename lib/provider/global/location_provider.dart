import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/model/data_model/address.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../helper/location_helper.dart';

class LocationProvider {
  Position? _locationData;

  Position? get currentLocation => _locationData;
  Position defaultPositionIos = Position(
      longitude: 0.0000,
      latitude: 0.0000,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    headingAccuracy: 0.0,
    altitudeAccuracy: 0.0
  );
  Position defaultPositionAndroid = Position(
      longitude: 0.0001,
      latitude: 0.0001,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      headingAccuracy: 0.0,
      altitudeAccuracy: 0.0);

  setInitialLocationOnLogin(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _locationData = defaultPositionIos;
        if (Platform.isIOS) {
          _locationData = defaultPositionIos;
        } else
          _locationData = defaultPositionAndroid;
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      //TODO: may need to implement user to navigate to setting with a message
      _locationData = defaultPositionIos;
      if (Platform.isIOS) {
        _locationData = defaultPositionIos;

        /// default location if ios
      } else
        _locationData = defaultPositionAndroid;
      return false;
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
                  _locationData = defaultPositionAndroid;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      
      if (!serviceEnabled) {
        await LocationHelper().reqService();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      }
      if (serviceEnabled) {
        _locationData = await Geolocator.getCurrentPosition();
      } else {
        ///allowing continue with default location
        _locationData = defaultPositionAndroid;
      }
    }
  }

  Future determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      try {
        await LocationHelper().reqService();
      } on Exception catch (e) {
        return 'Location Services disabled , kindly enable';
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return 'Location permissions are permanently denied, we cannot request permissions.';
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      final position = await Geolocator.getCurrentPosition();
      _locationData = position;
      return _locationData;
    } else {
      return 'Location Services disabled , kindly enable';
    }
  }

  Future getCurrentAddress() async {
    final position = await determinePosition();

    if (position is Position) {
      return Address(
          latitude: position.latitude,
          longitude: position.longitude,
          addressType: '',
          city: '',
          country: '',
          formattedAddress: '',
          houseNumber: '',
          landmark: '',
          locality: '',
          placeId: '',
          postCode: '',
          state: '',
          streetName: '',
          unitNumber: '',
          id: '');
    } else {
      print("here error");
      return position; // close execution
    }
  }

  openAppSettings(BuildContext context) async {
    final navResult = await Alert(
      context: context,
      title: "Location Permission Disabled",
      content: Text(
          "App will be navigating to app settings, kindly enable the location permission"),
      buttons: [
        DialogButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              "okay",
            ))
      ],
    ).show();

    if (navResult != null && navResult) {
      //  await pHandler.openAppSettings();
      await AppSettings.openAppSettings();
      return true;
    } else {
      return false;
    }
  }

  //TODO
  getGoogleAddress(LatLng currentLocation) async {
    // {
    //   // final testLocation = LatLon(52.351249, 4.79866);
    //   //LatLon(currentLocation.latitude!, currentLocation.longitude!)
    //   late result;
    //   //     await GoogleGeocoding(AppConstants.googleAPIKey).geocoding.getReverse(
    //   //           LatLon(currentLocation.latitude, currentLocation.longitude),
    //   //           // resultType: ["street_address", "route"]
    //   //         ); //"premise" commented,
    //   // List<GeocodingResult> geoCodeList = result!.results!;
    //   // GeocodingResult geocodingResult = GeocodingResult();
    //   String? postalCode;
    //   String? formattedAddress;
    //   String? streetNumber;
    //
    //   String? streetName;
    //   String? premise;
    //   String? locality;
    //   String? areaLevel1;
    //   String? areaLevel2;
    //   String? country;
    //
    //   for (GeocodingResult element in geoCodeList) {
    //     // if (element.types!.contains("premise")) {
    //     //   formattedAddress = element.formattedAddress;
    //     //   geocodingResult = element;
    //     //   break;
    //     // }
    //     if (element.types!.contains("street_address")) {
    //       formattedAddress = element.formattedAddress;
    //       geocodingResult = element;
    //       break;
    //     } else if (element.types!.contains("route")
    //         // ||
    //         // element.types!.contains("postal_code")
    //         ) {
    //       formattedAddress = element.formattedAddress;
    //       geocodingResult = element;
    //       break;
    //     } else if (element.types!.contains("sublocality") ||
    //         element.types!.contains("sublocality_level_2") ||
    //         element.types!.contains("neighborhood")) {
    //       //   formattedAddress = element.formattedAddress;
    //       geocodingResult = element;
    //       break;
    //     } else if (element.types!.contains("political") ||
    //         element.types!.contains("locality") ||
    //         element.types!.contains("sublocality_level_1")) {
    //       formattedAddress = element.formattedAddress;
    //       geocodingResult = element;
    //       break;
    //     }
    //   }
    //
    //   formattedAddress = '';
    //   geocodingResult.addressComponents!.map((e) {
    //     if (!(e.types!.contains('plus_code'))) {
    //       formattedAddress = formattedAddress! + ' ' + e.longName!;
    //     }
    //   }).toList();
    //
    //   if (geocodingResult.addressComponents != null) {
    //     for (var element in geocodingResult.addressComponents!) {
    //       if (element.types!.contains("postal_code")) {
    //         postalCode = element.shortName;
    //       }
    //       if (element.types!.contains("street_number")) {
    //         streetNumber = element.shortName;
    //       }
    //       if (element.types!.contains("premise")) {
    //         premise = element.shortName;
    //       }
    //       if (element.types!.contains("route")) {
    //         streetName = element.longName;
    //       }
    //       if (element.types!.contains("administrative_area_level_1")) {
    //         areaLevel1 = element.longName;
    //       }
    //       if (element.types!.contains("administrative_area_level_2")) {
    //         areaLevel2 = element.longName;
    //       }
    //       if (element.types!.contains("locality")) {
    //         locality = element.longName;
    //       }
    //       if (element.types!.contains("country")) {
    //         country = element.longName;
    //       }
    //     }
    //   }
    //
    //   streetName ??= premise ?? locality ?? areaLevel2 ?? areaLevel1;
    //
    //   if (streetName!.toLowerCase() == 'unnamed road') {
    //     streetName = premise ?? locality ?? areaLevel2 ?? areaLevel1;
    //   }
    //
    //   Address googleAddress = Address(
    //       placeId: geocodingResult.placeId,
    //       longitude: geocodingResult.geometry?.location?.lng,
    //       latitude: geocodingResult.geometry?.location?.lat,
    //       formattedAddress: formattedAddress,
    //       postCode: postalCode,
    //       houseNumber: streetNumber,
    //       locality: locality ?? areaLevel2 ?? areaLevel1,
    //       country: country,
    //       streetName: streetName,
    //       state: areaLevel1);
    //   return googleAddress;
    // }
  }

    convertToAddress(double lat, double long, String apikey) async {
      String? address;
      String? city;
      String? state;
      Dio dio = Dio(); //initilize dio package
      String apiurl =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apikey";

      Response response = await dio.get(apiurl); //send get request to API URL

      if (response.statusCode == 200) {
        Map data = response.data; //get response data
        if (data["status"] == "OK") {
          if (data["results"].length > 0) {
            Map firstResult = data["results"][0]; //select the first address
            Log.printILog(firstResult);
            address = firstResult["formatted_address"]; //get the address

            var test = firstResult["address_components"];

            (test as List).forEach((e) {
              if (e["types"].contains("locality")) city = e["short_name"];
              if (e["types"].contains("administrative_area_level_1"))
                state = e["long_name"];
            });
            //you can use the JSON data to get address in your own format

            return [address, city, state];
          }
        } else {
          return null;
        }
      } else {
        Log.printELog("error while fetching geocoding data");
        return null;
      }
    }

}
