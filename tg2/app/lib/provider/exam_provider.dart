import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tg2/provider/player_provider.dart';
import '../models/exam_model.dart';
import '../utils/api/api_endpoints.dart';
import '../utils/api/api_service.dart';
import '../utils/constants.dart';

// Exam provider class
class ExamProvider extends ChangeNotifier {
  late PlayerProvider _playerProvider;
  ProviderState _state = ProviderState.empty;
  Map<int, Exam> _items = {};

  // Automatically fetch data when initialized
  ExamProvider(this._playerProvider) {
    print("Exam/P: Initialized");
    get();
  }

  // Getters
  ProviderState get state => _state;
  Map<int, Exam> get items => _items;

  // Setters
  set playerProvider(PlayerProvider provider) {
    _playerProvider = provider;
    notifyListeners();
  }

  Future get() async {
    try {
      if(_state != ProviderState.busy) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Exam/P: Getting all...");
        final response = await ApiService().get(ApiEndpoints.exam);
        _items = { for (var json in response) json['id']: Exam(
          _playerProvider.items[json['player_id']]!,
          DateTime.parse(json['date'].toString()),
          json['result'],
          json['id'],
        )};
        print("Exam/P: Fetched successfully!");
      }
    } catch (e) {
      print("Exam/P: Error fetching! $e");
      rethrow;
    }
    _state = ProviderState.ready;
    notifyListeners();
  }
}
