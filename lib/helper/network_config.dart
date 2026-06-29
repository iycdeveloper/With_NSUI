import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkConfig {
  // Checks the current status of internet connection
  Future<bool> get isConnected;
}

class NetworkConfigImpl extends NetworkConfig {
  final InternetConnectionChecker? dataConnectionChecker;

  NetworkConfigImpl({
    @required this.dataConnectionChecker,
  });

  @override
  Future<bool> get isConnected => dataConnectionChecker!.hasConnection;
}
