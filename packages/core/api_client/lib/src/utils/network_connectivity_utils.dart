import 'package:connectivity/connectivity.dart';

abstract class NetworkConnectivityUtils {
  Future<bool> isConnected();
}

class NetworkConnectivityUtilsImpl extends NetworkConnectivityUtils {
  @override
  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile;
  }
}
