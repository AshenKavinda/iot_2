import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/status_model.dart';
import '../services/firebase_rest_service.dart';

class StatusProvider extends ChangeNotifier {
  StatusModel _status = StatusModel.defaultValue;
  bool _hasError = false;
  bool _isLoading = true;
  DateTime? _lastUpdated;
  Timer? _timer;

  StatusModel get status => _status;
  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  DateTime? get lastUpdated => _lastUpdated;

  StatusProvider() {
    _poll();
  }

  void _poll() {
    _fetch();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _fetch());
  }

  Future<void> _fetch() async {
    try {
      final data = await FirebaseRestService.get('status');
      _isLoading = false;
      _hasError = false;
      if (data is Map) {
        _status = StatusModel.fromMap(data);
        _lastUpdated = DateTime.now();
      }
      notifyListeners();
    } catch (_) {
      _isLoading = false;
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> setManualOverride(bool value) async {
    await FirebaseRestService.put('pump/manualOverride', value);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
