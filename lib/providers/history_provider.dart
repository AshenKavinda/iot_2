import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/flow_record_model.dart';
import '../models/session_model.dart';
import '../services/firebase_rest_service.dart';

class HistoryProvider extends ChangeNotifier {
  List<SessionModel> _sessions = [];
  List<FlowRecordModel> _flowRecords = [];
  bool _sessionsError = false;
  bool _flowError = false;

  Timer? _sessionsTimer;
  Timer? _flowTimer;

  List<SessionModel> get sessions => _sessions;
  List<FlowRecordModel> get flowRecords => _flowRecords;
  bool get hasError => _sessionsError || _flowError;

  HistoryProvider() {
    _pollSessions();
    _pollFlow();
  }

  void _pollSessions() {
    _fetchSessions();
    _sessionsTimer =
        Timer.periodic(const Duration(seconds: 5), (_) => _fetchSessions());
  }

  void _pollFlow() {
    _fetchFlow();
    _flowTimer =
        Timer.periodic(const Duration(seconds: 5), (_) => _fetchFlow());
  }

  Future<void> _fetchSessions() async {
    try {
      final data = await FirebaseRestService.get('history/sessions');
      _sessionsError = false;
      if (data is Map) {
        _sessions = data.entries
            .where((e) => e.value is Map)
            .map((e) => SessionModel.fromMap(
                e.key.toString(), e.value as Map<dynamic, dynamic>))
            .toList()
          ..sort((a, b) => b.epochMs.compareTo(a.epochMs));
      } else {
        _sessions = [];
      }
      notifyListeners();
    } catch (_) {
      _sessionsError = true;
      notifyListeners();
    }
  }

  Future<void> _fetchFlow() async {
    try {
      final data = await FirebaseRestService.get('history/flow');
      _flowError = false;
      if (data is Map) {
        _flowRecords = data.entries
            .where((e) => e.value is Map)
            .map((e) => FlowRecordModel.fromMap(
                e.key.toString(), e.value as Map<dynamic, dynamic>))
            .toList()
          ..sort((a, b) => b.epochMs.compareTo(a.epochMs));
      } else {
        _flowRecords = [];
      }
      notifyListeners();
    } catch (_) {
      _flowError = true;
      notifyListeners();
    }
  }

  Future<void> clearHistory() async {
    await Future.wait([
      FirebaseRestService.delete('history/flow'),
      FirebaseRestService.delete('history/sessions'),
    ]);
  }

  @override
  void dispose() {
    _sessionsTimer?.cancel();
    _flowTimer?.cancel();
    super.dispose();
  }
}
