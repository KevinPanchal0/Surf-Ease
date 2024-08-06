import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:surf_ease/model/connectivity_modal.dart';

class ConnectivityProvider with ChangeNotifier {
  ConnectivityModal connectivityModal =
      ConnectivityModal(isNetworkAvailable: false);

  void checkConnectivity() {
    Connectivity connectivity = Connectivity();

    Stream<List<ConnectivityResult>> stream =
        connectivity.onConnectivityChanged;

    stream.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        connectivityModal.isNetworkAvailable = true;
      } else {
        connectivityModal.isNetworkAvailable = false;
      }
      notifyListeners();
    });
  }
}
