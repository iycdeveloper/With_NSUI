import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationHelper {
  Future<bool> getServiceStatus() async {
    Location location = new Location();
    final _serviceEnabled = await location.serviceEnabled();
    return _serviceEnabled;
  }

  Future getPermission() async {
    Location location = new Location();
    final _serviceEnabled = await location.hasPermission();
    return _serviceEnabled;
  }

  Future reqService() async {
    Location location = new Location();
    final _serviceEnabled = await location.requestService();
    return _serviceEnabled;
  }

  Future<PermissionStatus> reqPermission() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionStatus;
    bool firstTime = false;

    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      try {
        _permissionStatus = await location.requestPermission();
      } on PlatformException catch (e) {
        print(e.message);
      }
      // if (_permissionStatus != PermissionStatus.granted) {
      //   //return;
      //   try {
      //     _permissionStatus = await location.requestPermission();
      //   } on Exception catch (e) {
      //     if (e is PlatformException) print(e.message);
      //   }
      // }
    }
    if (_permissionStatus == PermissionStatus.granted) {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          //return;
        }
      }
      if (_serviceEnabled) {
        if (kReleaseMode)
          await location.changeSettings(accuracy: LocationAccuracy.high);
      }
    }

    return _permissionStatus;
  }

  Future<LocationData?> getLocationData() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData? _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        //return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      try {
        _permissionGranted = await location.requestPermission();
      } on PlatformException catch (e) {
        if (kDebugMode) {
          print(e.message);
        }
      }
      if (_permissionGranted != PermissionStatus.granted) {
        //return;
        try {
          _permissionGranted = await location.requestPermission();
        } on Exception catch (e) {
          if (e is PlatformException) print(e.message);
        }
      }
    }
    if (_permissionGranted == PermissionStatus.granted) {
      // if (kReleaseMode)
      _locationData = await location.getLocation();
      if (kDebugMode) {
        print(_locationData.latitude);
      }
    }
    return _locationData;
  }
}
