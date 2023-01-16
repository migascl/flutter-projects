import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tg2/models/exam_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import 'package:tg2/utils/constants.dart';

// Exam provider class
class ExamProvider extends ChangeNotifier {
  late PlayerProvider _playerProvider;
  ProviderState _state = ProviderState.empty;
  Map<int, Exam> _items = {};

  // Automatically fetch data when initialized
  ExamProvider(this._playerProvider) {
    print("Exam/P: Initialized");
  }

  // Getters
  ProviderState get state => _state;
  Map<int, Exam> get items => _items;
  Map<int, Exam> getByPlayer(Player player) {
    return Map.fromEntries(_items.entries
        .where((element) => element.value.player.id == player.id));
  }

  Map<int, Exam> getByDate(DateTimeRange date) {
    return Map.fromEntries(_items.entries.where((element) =>
        element.value.date.isAfter(date.start) &&
        element.value.date.isBefore(date.end)));
  }

  // Setters
  set playerProvider(PlayerProvider provider) {
    _playerProvider = provider;
    notifyListeners();
  }

  Future get() async {
    try {
      if (_state != ProviderState.busy &&
          _playerProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Exam/P: Getting all...");
        final response = await ApiService().get(ApiEndpoints.exam);
        _items = {
          for (var json in response)
            json['id']: Exam(
              _playerProvider.items[json['player_id']]!,
              DateTime.parse(json['date'].toString()),
              json['result'],
              json['id'],
            )
        };
        print("Exam/P: Fetched successfully!");
      }
    } catch (e) {
      print("Exam/P: Error fetching! $e");
      rethrow;
    }
    (_items.isEmpty)
        ? _state = ProviderState.empty
        : _state = ProviderState.ready;
    notifyListeners();
  }

  Future delete(Exam exam) async {
    try {
      if (_state != ProviderState.busy &&
          _playerProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Exam/P: Deleting exam ${exam.id}...");
        await ApiService().delete(ApiEndpoints.exam, exam.toJson());
        print("Exam/P: Deleted exam ${exam.id} successfully!");
      }
    } catch (e) {
      print("Exam/P: Error deleting exam ${exam.id}! $e");
      rethrow;
    }
    (_items.isEmpty)
        ? _state = ProviderState.empty
        : _state = ProviderState.ready;
    notifyListeners();
    await get();
  }

  Future post(Exam exam) async {
    try {
      if (_state != ProviderState.busy &&
          _playerProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Exam/P: Inserting new exam...");
        await ApiService().post(ApiEndpoints.exam, exam.toJson());
        print("Exam/P: Exam inserted successfully!");
      }
    } catch (e) {
      print("Exam/P: Error inserting! $e");
      rethrow;
    }
    (_items.isEmpty)
        ? _state = ProviderState.empty
        : _state = ProviderState.ready;
    notifyListeners();
    await get();
  }

  Future patch(Exam exam) async {
    try {
      if (_state != ProviderState.busy &&
          _playerProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Exam/P: Patching exam ${exam.id}...");
        await ApiService().patch(ApiEndpoints.exam, exam.toJson());
        print("Exam/P: Patched exam ${exam.id} successfully!");
      }
    } catch (e) {
      print("Exam/P: Error patching exam ${exam.id}! $e");
      rethrow;
    }
    (_items.isEmpty)
        ? _state = ProviderState.empty
        : _state = ProviderState.ready;
    notifyListeners();
    await get();
  }
}
