// Library imports
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/constants.dart';
import '../models/exam_model.dart';
import '../utils/api/api_endpoints.dart';
import '../utils/api/api_service.dart';

// Exam provider class
class ExamProvider extends ChangeNotifier {
  late PlayerProvider _playerProvider;
  Map<int, Exam> _items = {};
  ProviderState _state = ProviderState.empty;

  // Automatically fetch data when initialized
  ExamProvider(this._playerProvider) {
    print("Exam/P: Initialized");
    get();
  }

  PlayerProvider get playerProvider => _playerProvider;
  ProviderState get state => _state;
  Map<int, Exam> get items => _items;

  Future<void> get() async {
    try {
      if(_state == ProviderState.busy || playerProvider.state != ProviderState.ready) return;
      print("Exam/P: Getting all...");
      _state = ProviderState.busy;
      notifyListeners();
      final response = await ApiService().get(ApiEndpoints.exam);
      _items = { for (var item in response) item['id'] : Exam.fromJson(item) };
      print("Exam/P: Fetched successfully!");
      _state = ProviderState.ready;
      notifyListeners();
    } catch (e) {
      print("Exam/P: Error fetching! $e");
      _state = ProviderState.empty;
      notifyListeners();
    }
  }
}
