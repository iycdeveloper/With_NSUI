import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';
import '../remote/dio/dio_client.dart';
import '../remote/exception/api_error_handler.dart';
import '../services/local_storage_services.dart';
import '../urls.dart';

class VotersRepo {
  DioClient dioClient = sl();

  getVotersList(
    String searchKey,
    String searchMode,
    String? statecode, [
    String? assembyCode,
    String? prlimentCode,
    String? assemblyName,
    String? parliamentName,
    String? localLangAssemblyName,
    String? localLangParliament,
    String? language,
  ]) async {
    var data =
        '''[{"V":"${AppConstants.voterSearchVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude}",
        "SEARCH_TEXT":"$searchKey",
        "STATE_CODE":"$statecode",
        "PARLIAMENT_CODE":"${prlimentCode ?? ""}","ASSEMBLY_CODE":"${assembyCode ?? ""}",
        "ASSEMBLY_NAME":"$assemblyName","PARLIAMENT_NAME":"$parliamentName",
        "R_PARLIAMENT_NAME":"${localLangParliament ?? ""}","R_ASSEMBLY_NAME":"${localLangAssemblyName ?? ""}",
        "LANG_CODE":"${language ?? ""}","SEARCH_MODE":"$searchMode"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getVotersList,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  getFamilyVotersList(
      {String? searchKey,
      String? assembyCode,
      String? districtCode,
      String? assemblyName,
      String? parliamentId,
      String? localLangAssemblyName,
      String? localLangParliament,
      String? epicId,
      String? language}) async {
    var data =
        '''[{"V":"${AppConstants.voterSearchVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "SEARCH_TEXT":"$searchKey","STATE_CODE":"${await LocalStorageServices().getWorkStateCode()}",
        "PARLIAMENT_CODE":"${districtCode ?? ""}","ASSEMBLY_CODE":"${assembyCode ?? ""}",
        "PART_NO":"2","HOUSE_NO":"1","EPIC":"${epicId ?? ""}","LANG_CODE":"${language ?? ""}"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getFamilyVotersList,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
