import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkManager extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  NetworkManager() {
    _initialize();
  }

  void _initialize() async {
    try {
      final results = await Connectivity().checkConnectivity();
      final status = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateStatus(status);
    } catch (e) {
      _updateStatus(ConnectivityResult.none);
    }

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final status = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateStatus(status);
    });
  }

  void _updateStatus(ConnectivityResult result) {
    final wasOnline = _isOnline;
    _isOnline = result != ConnectivityResult.none;

    if (_isOnline != wasOnline) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
