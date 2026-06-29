import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
// import 'package:google_place/google_place.dart' as p;
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/data_model/address.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/screens/ui/location/edit_location.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/location/edit_location_vm.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

//TODO
class SelectLocationVM extends ChangeNotifier {
  String? routeFrom;
  bool selectedCurrentLocation = false;

  Address? selectedLocation;
  Address? tempLocation;

  Address? userAddress;
  List<Address> recentAddressList = [];
  // List<p.AutocompletePrediction>? predictionList;

  bool isLoadingAddress = false;

  late StreamSubscription<Position> positionStream;

  SelectLocationVM() {
    getCurrentLocation();
  }

  bool isLoading = false;

  @override
  void dispose() {
    print(
        "dispose select location vm was called here............................./////////////////////");
  }

  final sl = GetIt.instance;
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  dynamic currentAddress = '';
  double latitude = 28.62626217414807;
  double longitude = 77.21232622567943;

  String? result = '';
  getCurrentLocation() async {
    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    latitude = position.latitude;
    longitude = position.longitude;
    currentAddress = await sl<LocationProvider>().convertToAddress(
        position.latitude,
        position.longitude,
        'AIzaSyBQaoLL-DePeRTz-CFxg6BSKL1Q2gf4SxE');
    if (currentAddress == null) {
      result = '';
    } else {
      result = currentAddress[0] ?? currentAddress.toString();
    }
    notifyListeners();
  }

  changeAddress(String formatadd)async {
     Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    latitude = position.latitude;
    longitude = position.longitude;
    result = formatadd;
    notifyListeners();
  }
  // onTapCurrentLocation(BuildContext context) async {
  //   if (selectedCurrentLocation) {
  //     /// read location provider here
  //     return;
  //   }
  //
  //   //notifyListeners();
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) => const Dialog(
  //           child: SizedBox(
  //             height: 100,
  //             child: Center(
  //               child: CircularProgressIndicator(),
  //             ),
  //           )));
  //   LocationPermission permission = await LocationHelper().reqPermission();
  //   print(permission);
  //   if (permission == LocationPermission.deniedForever) {
  //     final navResult = await showDialog(
  //         context: context,
  //         builder: (_) => KXAlert(
  //             title: "Location permission disabled",
  //             alertMessage:
  //             "App will be navigating to app settings, kindly enable the location permission",
  //             buttonTitle: "Okay",
  //             buttonAction: () => Navigator.of(context).pop(true)));
  //     if (navResult != null && navResult) {
  //       //  await pHandler.openAppSettings();
  //       AppSettings.openAppSettings();
  //       permission = await LocationHelper().reqPermission();
  //       print(permission);
  //     }
  //   }
  //   if ([LocationPermission.always, LocationPermission.whileInUse]
  //       .contains(permission)) {
  //     try {
  //       final service = await LocationHelper().getServiceStatus();
  //       bool _serviceEnabled;
  //       lo.Location location = lo.Location();
  //
  //       _serviceEnabled = await location.serviceEnabled();
  //       if (!_serviceEnabled) {
  //         _serviceEnabled = await location.requestService();
  //         if (!_serviceEnabled) {
  //           throw Exception("service not enabled");
  //         }
  //       }
  //
  //       Geolocator.getCurrentPosition();
  //
  //       /// dummy call
  //
  //       print(service);
  //       var accuracy = await Geolocator.getLocationAccuracy();
  //       showCustomSnackBar(accuracy.name.toString(), context);
  //
  //       if (accuracy == LocationAccuracyStatus.precise) {
  //         positionStream = Geolocator.getPositionStream(
  //             locationSettings: Platform.isIOS
  //                 ? AppleSettings(
  //               timeLimit: const Duration(seconds: 20),
  //             )
  //                 : AndroidSettings(
  //               timeLimit: const Duration(seconds: 20),
  //             ))
  //             .listen(
  //               (Position? position) {},
  //         );
  //
  //         positionStream.onError((e) {
  //           print("on errror");
  //           showCustomSnackBar("on error : $e", context);
  //
  //           print(e);
  //           if (e is TimeoutException) {
  //             showCustomSnackBar(
  //                 "Unable to fetch your current location! Please try again or type your address in the searchbox",
  //                 context);
  //           }
  //           positionStream.cancel();
  //           Navigator.of(context).pop();
  //         });
  //         positionStream.onData((data) {
  //           print("data recieveied : ${data.accuracy}");
  //           showCustomSnackBar(
  //               "gps data received with accuracy : ${data.accuracy}", context);
  //           if (data.accuracy < 30.00) {
  //             final currentLocation = data;
  //             positionStream.cancel();
  //             handlePosition(context, currentLocation);
  //           }
  //         });
  //       } else {
  //         showCustomSnackBar("gps data accuracy not precise ", context);
  //         final position = await Geolocator.getCurrentPosition();
  //         showCustomSnackBar(
  //             "gps data accuracy not precise  received  data with accuracy ${position.accuracy}",
  //             context);
  //         handlePosition(context, position);
  //       }
  //     } on Exception catch (e) {
  //       print(e);
  //       print("exception");
  //       showCustomSnackBar("permission exception : $e", context);
  //       Navigator.of(context).pop(); // loading pop
  //     }
  //   } else {
  //     Navigator.of(context).pop(); // loading pop
  //   }
  // }

  // handlePosition(BuildContext context, Position currentLocation) async {
  //   final Address googleAddress = await sl<LocationProvider>().getGoogleAddress(
  //       LatLng(currentLocation.latitude, currentLocation.longitude));
  //   tempLocation = googleAddress;
  //   tempLocation!.latitude = currentLocation.latitude;
  //   tempLocation!.longitude = currentLocation.longitude;
  //
  //   final addressEditResult = await Navigator.of(context)
  //       .pushNamed(Routes.getEditLocationRoute(), arguments: {
  //     "from": " from the select location vm",
  //     "address": tempLocation
  //   });
  //   Navigator.of(context).pop();
  //   if (addressEditResult != null && addressEditResult is Address) {
  //     print(addressEditResult.landmark);
  //     notifyListeners();
  //     if (routeFrom == "/home") {
  //       context.read<LocationProvider>().setLocation(addressEditResult);
  //       locationRepo.saveLocation(addressEditResult);
  //       Navigator.of(context).pop(true);
  //     } else {
  //       Navigator.of(context).pop(addressEditResult);
  //     }
  //   }
  // }

  // searchLocation(FloatingSearchBarController controller, BuildContext context,
  //     String pattern) async {
  //   if (pattern.length <= 3) return {};
  //
  //   //TODo: add more specific search options
  //   // return p.GooglePlace(AppConstants.googleAPIKey)
  //   //     .autocomplete.get(pattern,).then((value) async {
  //   //   Log.printILog(value);
  //   //   predictionList = value!.predictions!.toList();
  //   //   notifyListeners();
  //   //   if (predictionList!.isNotEmpty) controller.show();
  //   //   Log.printILog(value.predictions!.toList());
  //   // });
  // }

  onSelectedSuggestion(BuildContext context, selected) async {
    // selected = selected as p.AutocompletePrediction;
    //
    // //TODO: replace google details by modeling autocomplete
    // Log.printILog("selected place id .................: ${selected.placeId}");
    // await p.GooglePlace(AppConstants.googleAPIKey)
    //     .details
    //     .get(selected.placeId!,
    //         fields: "name,formatted_address,geometry,address_component")
    //     .then((result) async {
    //   Log.printILog(
    //       "geo result place id ...............: ${result?.result?.placeId} ");
    //   final p.AutocompletePrediction selectedAddress =
    //       selected as p.AutocompletePrediction;

    // Log.printILog(
    //     "selected address inner nest place id ...........: ${selectedAddress.placeId}");
    String? postalCode;
    String? streetNumber;
    String? streetName;
    String? formattedAddress;

    String? premise;
    String? locality;
    String? areaLevel1;
    String? areaLevel2;
    String? country;

    // result!.result!.addressComponents!
    //     .map((e) => e)
    //     .toList()
    //     .forEach((element) {
    //   if (element.types!.contains("postal_code")) {
    //     debugPrint(element.shortName!);
    //     postalCode = element.shortName!;
    //   }
    //   if (element.types!.contains("street_number")) {
    //     streetNumber = element.shortName;
    //   }
    //   if (element.types!.contains("route")) {
    //     streetName = element.longName;
    //   }
    //   if (element.types!.contains("administrative_area_level_1")) {
    //     areaLevel1 = element.longName;
    //   }
    //   if (element.types!.contains("premise")) {
    //     premise = element.shortName;
    //   }
    //   if (element.types!.contains("administrative_area_level_2")) {
    //     areaLevel2 = element.longName;
    //   }
    //   if (element.types!.contains("locality")) {
    //     locality = element.longName;
    //   }
    //   if (element.types!.contains("country")) {
    //     country = element.longName;
    //   }
    // });
    //
    // streetName ??= premise ?? locality ?? areaLevel2 ?? areaLevel1;
    // if (streetName!.toLowerCase() == 'unnamed road') {
    //   streetName = premise ?? locality ?? areaLevel2 ?? areaLevel1;
    // }
    //
    // print(result.result!.geometry!.location!.lat!);
    // print(result.result!.geometry!.location!.lng!);
    // Address googleAddress = Address(
    //     formattedAddress: selectedAddress.description!,
    //     latitude: result.result!.geometry!.location!.lat!,
    //     longitude: result.result!.geometry!.location!.lng!,
    //     postCode: postalCode,
    //     streetName: streetName,
    //     houseNumber: streetNumber,
    //     locality: locality ?? areaLevel2 ?? areaLevel1,
    //     country: country,
    //     placeId: selectedAddress.placeId!);

    //   tempLocation = googleAddress;
    //   // sl<SelectLocationVM>().tempLocation = googleAddress;
    //   // print(sl<SelectLocationVM>().tempLocation?.formattedAddress);
    //   final addressEditedResult = await toPage(
    //       context,
    //       ChangeNotifierProvider(
    //         create: (context) => LocationEditVM(),
    //         child: LocationEditPage(
    //           initialAddress: googleAddress,
    //         ),
    //       ));
    //
    //   Navigator.of(context).pop(addressEditedResult);
    // });
  }

  void clearPredictions() {
    // predictionList = null;
    notifyListeners();
  }

  void setRouteFrom(String? routeFrom) {
    this.routeFrom = routeFrom;
    print(routeFrom);
  }
}
