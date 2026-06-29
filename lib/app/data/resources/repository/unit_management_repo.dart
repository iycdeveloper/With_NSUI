import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/events/event.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';
import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';

import '../urls.dart';

class UnitManagementRepo {
  DioClient dioClient = sl();

  checkOBAccess() async {
    var data =
        '''[{"V":"${AppConstants.unitManagementVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? 0.0}","LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? 0.0}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.checkOBAccess,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  getStateOBUsers() async {
    var data =
        '''[{"V":"${AppConstants.unitManagementVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getStateOBUsers,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  getVerifyEvent() async {
    var data =
        '''[{"V":"${AppConstants.unitManagementVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getVerifyEvent,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  verifyEvent(String eventId, String rating) async {
    var data =
        '''[{"V":"1.0","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}","DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}","LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}","EVENT_ID":"${eventId}","EVENT_RATING":"${rating}"}]''';
    // '''[{"V":"${AppConstants.unitManagementVersion}",
    //      "ORG":"${AppConstants.orgName}",
    //      "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    //     "DEVICE_ID":"${await getDeviceIdentifier()}",
    //     "USER_ID":"${await LocalStorageServices().getUserId()}",
    //     "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
    //     "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
    //     "EVENT_ID":"$eventId",
    //     "EVENT_RATING":"$rating"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.verifyEvent,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  createExternalTraining(
      String type,
      String dateFrom,
      String dateTo,
      String desc,
      String comment,
      String rating,
      String days,
      String file1,
      String file2,
      String file3,
      String mobile) async {

    var data =
        '''[{"V":"${AppConstants.unitManagementVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "EXTERNAL_TRAINING_TYPE":"${type}",
        "EXTERNAL_TRAINING_FROM":"${dateFrom}",
        "EXTERNAL_TRAINING_TO":"${dateTo}",
        "COMMENT":"$comment",
        "RATING": "$rating",
        "DAYS": "$days",
        "FILE1":"${file1.split("/").last}",
        "FILE2":"${file2.split("/").last}",
        "FILE3":"${file3.split("/").last}",
        "EXTERNAL_TRAINING_DESCRIPTION":"${desc}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.externalTraining,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  getDistrictOBUsers() async {
    var data =
        '''[{"V":"${AppConstants.unitManagementVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getDistrictOBUsers,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  getAssemblyOBUsers() async {
    var data =
        '''[{"V":"${AppConstants.unitManagementVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getAssemblyOBUsers,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  getDailyEvent(DateTime dateTime) async {
    var data =
        '''[{"V":"${AppConstants.unitManagementVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "EVENT_DATE":"${DateFormat('dd-MM-yyyy').format(dateTime)}"}]''';
    //DateFormat("dd-MM-yyyy").format(dateTime)
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getDailyEvent,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  setRSVPEvent(String rsvp, Event event, {String? reason = ""}) async {
    var data =
        '''[{"V":"${AppConstants.unitManagementVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "RSVP":"$rsvp","RSVP_REASON":"$reason","EVENT_ID":"${event.eventId}"}]''';
    //DateFormat("dd-MM-yyyy").format(dateTime)
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.setRSVPEvent,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  createEvent(Event event, String superShaktiMember) async {
    var data = '''[{
    "V":"${AppConstants.unitManagementVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "LATITUDE":"${event.address!.latitude.toString()}",
    "LONGITUDE":"${event.address!.longitude.toString()}",
    "EVENT_NAME":"${event.eventName}",
    "EVENT_DATE":"${event.eventDateTime}",
    "EVENT_LOCATION":"${event.eventLocation}",
    "EVENT_DESCRIPTION":"${event.eventDescription}",
    "EVENT_INVITEES":"${event.inviteesList}",
    "EVENT_TYPE":"${event.eventType}",
    "EVENT_LEVEL":"${event.eventLevel}",
    "CLUB":"$superShaktiMember",
    "EVENT_INVITE_ALL":"${event.inviteAll}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.createEvent,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  checkInEvent(String eventID, String comment, int rating) async {
    String address = "";
    var city = "";
    var state = "";
    convertToAddress(double lat, double long, String apikey) async {
      Dio dio = Dio(); //initilize dio package
      String apiurl =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apikey";

      Response response = await dio.get(apiurl); //send get request to API URL
      print("hereb ttooo");

      if (response.statusCode == 200) {
        //if connection is successful
        Map data = response.data; //get response data
        if (data["status"] == "OK") {
          print("hereb ok");

          //if status is "OK" returned from REST API
          if (data["results"].length > 0) {
            //if there is atleast one address
            Map firstResult = data["results"][0]; //select the first address

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
        print("error while fetching geocoding data");
        return null;
      }
    }

    final position = await sl<LocationProvider>().determinePosition();

    if (position is Position) {
      await convertToAddress(position.latitude, position.longitude,
          "AIzaSyBQaoLL-DePeRTz-CFxg6BSKL1Q2gf4SxE");
    } else {
      print("here error");

      return ApiResponse.withError(position); // close execution
    }

    var data =
        '''[{"V":"${AppConstants.unitManagementVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${position.latitude}","LONGITUDE":"${position.longitude}","CHECKIN_ADDRESS":"$address",
        "CHECKIN_STATE":"$state",
        "CHECKIN_CITY":"$city",
        "EVENT_ID":"$eventID",
        "COMMENT":"$comment",
        "RATING": "$rating"
        }]''';

    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.checkInEvent,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  electionReport() async {
    var data = '''[{"V":"${AppConstants.unitManagementVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
    "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.electionReport,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  electionUnitReport(String stateCode, String stateName, String year,
      String month, String monthNumber) async {
    var data = '''[{"V":"${AppConstants.unitManagementVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
    "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
    "STATE_CODE": "$stateCode",
    "STATE_NAME":"$stateName",
    "MONTH":"$monthNumber",
    "MONTH_NAME":"$month",
    "YEAR":"$year"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.electionUnitReport,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
