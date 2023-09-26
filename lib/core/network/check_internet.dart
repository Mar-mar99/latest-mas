// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/features/auth/accounts/data/data%20sources/user_remote_data_source.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker internetConnectionChecker;
  NetworkInfoImpl({
    required this.internetConnectionChecker, 
  });
  @override
  Future<bool> get isConnected async {
    return await internetConnectionChecker.hasConnection;
  }
}
