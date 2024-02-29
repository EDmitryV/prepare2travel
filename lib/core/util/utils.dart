import 'package:connectivity_plus/connectivity_plus.dart';

class Utils{
   Future<bool> networkConnected() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none &&
        connectivityResult != ConnectivityResult.bluetooth) {
      return true;
    }

    return false;
  }
}