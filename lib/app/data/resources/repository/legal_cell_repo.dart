import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';

import '../urls.dart';

class LegalCellRepo {
  DioClient dioClient = sl();

  getLegalCellAvailability() async {
    var data =
        '''[{"V":"${AppConstants.legalCellVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result =
          await dioClient.post(Urls.checkLegalCell, data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  getLegalCellList() async {
    var data =
        '''[{"V":"${AppConstants.legalCellVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result =
          await dioClient.post(Urls.getMembersLegalCell, data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  addLegalCell(BatchMember member) async {
    var data =
        '''[{"V":"${AppConstants.legalCellVersion}","ORG":"LC","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "FIRST_NAME":"${member.firstName}","LAST_NAME":"${member.lastName}","MOBILE":"${member.mobile}",
        "EMAIL":"${member.email}","STATE_CODE":"${member.stateCode}","ASSEMBLY_CODE":"${member.assemblyCode}",
        "DISTRICT_CODE":"${member.districtCode}","BLOCK_CODE":"${member.blockCode ?? 0}","BOOTH_CODE":"${member.boothCode}","SEX_CODE":"${member.gender}",
        "CATEGORY_CODE":"${member.category}","DATE_OF_BIRTH":"${member.dob}","ID_VALUE":"${member.idValue}",
        "BAR_COUNCIL_ID":"${member.barCouncilId}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result =
          await dioClient.post(Urls.addMemberLegalCell, data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
