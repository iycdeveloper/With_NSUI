import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';
import 'package:iyc/app/data/resources/remote/dio/logging_interceptor.dart';
import 'package:iyc/app/data/resources/repository/auth_repo.dart';
import 'package:iyc/app/data/resources/services/analytics_service.dart';
import 'package:iyc/app/data/resources/services/iyc_db_services.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/db_provider/membership/primary_member_db.dart';
import 'package:iyc/app/data/resources/repository/campaign_repo.dart';
import 'package:iyc/app/data/resources/repository/complaints_repo.dart';
import 'package:iyc/app/data/resources/repository/legal_cell_repo.dart';
import 'package:iyc/app/data/resources/repository/payment_repo.dart';
import 'package:iyc/app/data/resources/repository/ro_repo.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'helper/api_config.dart';
import 'helper/network_config.dart';
import 'provider/activity/activity_provider.dart';
import 'provider/auth/auth_api_provider.dart';
import 'provider/auth/splash_provider.dart';
import 'provider/batch/batch_api_provider.dart';
import 'provider/batch/batch_list_provider.dart';
import 'provider/membership_register/membership_api_providers/membership_list_provider.dart';
import 'app/data/resources/db_provider/membership/batch_db_repo.dart';
import 'app/data/resources/db_provider/membership/membership_db_repo.dart';
import 'app/data/resources/db_provider/scrutiny/scrutiny_batch_db_repo.dart';
import 'app/data/resources/db_provider/scrutiny/scrutiny_members_db_repo.dart';
import 'app/data/resources/repository/activity_repo.dart';
import 'app/data/resources/repository/auth_repo.dart';
import 'app/data/resources/repository/batch_repo.dart';
import 'app/data/resources/repository/membership_repo.dart';
import 'app/data/resources/repository/scrutiny_repo.dart';
import 'app/data/resources/repository/unit_management_repo.dart';
import 'app/data/resources/urls.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => Dio());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DioClient(Urls.baseUrl, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker.instance);

  sl.registerLazySingleton<NetworkConfig>(
    () => NetworkConfigImpl(
      dataConnectionChecker: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => ApiConfig(
      client: sl(),
      networkConfig: sl(),
    ),
  );
  sl.registerLazySingleton(() => LocationProvider());
  sl.registerLazySingleton(() => FirebaseAnalyticsService());

  sl.registerLazySingleton(() => AuthRepo(dioClient: sl()));
  sl.registerLazySingleton(() => AuthApiProvider(authRepo: sl(), apiConfig: sl()));
}

Future<void> initIycScope() async {
  final Database database = await IycDbServices.db.database as Database;
  sl.registerFactory(() => database);
  sl.registerLazySingleton(() => MembershipRepo(dioClient: sl()));
  sl.registerLazySingleton(() => BatchRepo(dioClient: sl()));
  sl.registerLazySingleton(() => MembershipMemberDB(sl()));
  sl.registerLazySingleton(() => BatchDBRepo(sl()));
  sl.registerLazySingleton(() => PrimaryMemberDB(sl()));
  sl.registerLazySingleton(() => ActivityRepo(dioClient: sl()));
  sl.registerLazySingleton(() => PaymentRepo());
  sl.registerLazySingleton(() => ComplaintsRepo());
  sl.registerLazySingleton(() => RoRepo());
  sl.registerLazySingleton(() => LegalCellRepo());
  sl.registerLazySingleton(() => YuvaBoothRepo());
  sl.registerLazySingleton(() => CampaignRepo());
  sl.registerLazySingleton(() => UnitManagementRepo());
  sl.registerLazySingleton(() => BatchApiProvider(batchRepo: sl()));
  sl.registerLazySingleton(() => SplashProvider());
  sl.registerLazySingleton(() => ActivityApiProvider(activityRepo: sl()));
  sl.registerFactory(() => MembershipListProvider(
        membershipRepo: sl(),
      ));
  sl.registerLazySingleton(() => BatchListProvider(apiConfig: sl()));
  sl.registerLazySingleton(() => ScrutinyRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ScrutinyBatchDBRepo(database));
  sl.registerLazySingleton(() => ScrutinyMembershipDBRepo(database));
}
