import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tg2/models/exam_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/utils/exceptions.dart';

// Exam provider class
class ExamProvider extends ChangeNotifier {
  // VARIABLES
  late PlayerProvider _playerProvider; // Reference to parent provider Player
  ProviderState _state = ProviderState.empty; // Provider state
  Map<int, Exam> _items = {}; // Cached data

  ExamProvider(this._playerProvider) {
    print("Exam/P: Initialized");
  }

  // GETTERS
  ProviderState get state => _playerProvider.state == ProviderState.busy ? ProviderState.busy : _state;

  Map<int, Exam> get items => _items;

  // Get exams from given player (Uses player id to search)
  Map<int, Exam> getByPlayer(Player player) {
    return Map.fromEntries(_items.entries.where((element) => element.value.player.id == player.id));
  }

  // Get exams from a date range
  Map<int, Exam> getByDate(DateTimeRange date) {
    return Map.fromEntries(
        _items.entries.where((element) => element.value.date.isAfter(date.start) && element.value.date.isBefore(date.end)));
  }

  // METHODS
  // Called when ProviderProxy update is called
  update(PlayerProvider playerProvider) {
    print("Exam/P: Update");
    _playerProvider = playerProvider;
    notifyListeners();
    get();
  }

  // Get all exams from database.
  // Calls GET method from API service and converts them to objects to insert onto the provider cache.
  // Prevents multiple calls.
  Future get() async {
    try {
      if (state != ProviderState.busy && _playerProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Exam/P: Getting all...");
        final response = await ApiService().get(ApiEndpoints.exam);
        _items = {
          for (var json in response)
            json['id']: Exam(
              _playerProvider.items[json['player']]!,
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
    } finally {
      (_items.isEmpty) ? _state = ProviderState.empty : _state = ProviderState.ready;
      notifyListeners();
    }
  }

  // Delete specific exam from database.
  // Calls DELETE method from API service by sending a JSON parsed string of the given exam
  // Prevents multiple calls & always ends by refreshing its cache regardless of result
  Future delete(Exam exam) async {
    try {
      if (_state != ProviderState.busy && _playerProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Exam/P: Deleting exam ${exam.id}...");
        await ApiService().delete(ApiEndpoints.exam, exam.toJson());
        print("Exam/P: Deleted exam ${exam.id} successfully!");
      }
    } catch (e) {
      print("Exam/P: Error deleting exam ${exam.id}! $e");
      rethrow;
    } finally {
      (_items.isEmpty) ? _state = ProviderState.empty : _state = ProviderState.ready;
      await get();
    }
  }

  // Insert exam onto the database.
  // Calls POST method from API service by sending a JSON parsed string of the given exam
  // Prevents multiple calls & always ends by refreshing its cache regardless of result
  Future post(Exam exam) async {
    try {
      if (_state != ProviderState.busy && _playerProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Exam/P: Inserting new exam...");
        await ApiService().post(ApiEndpoints.exam, exam.toJson());
        print("Exam/P: Exam inserted successfully!");
      }
    } catch (e) {
      print("Exam/P: Error inserting! $e");
      rethrow;
    } finally {
      (_items.isEmpty) ? _state = ProviderState.empty : _state = ProviderState.ready;
      await get();
    }
  }

  // Update exam in the database.
  // Checks if provider cache contains object with same relevant values but from a different id before proceeding
  // Calls PATCH method from API service by sending a JSON parsed string of the given exam
  // Prevents multiple calls & always ends by refreshing its cache regardless of result
  Future patch(Exam exam) async {
    try {
      if (_state != ProviderState.busy && _playerProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Exam/P: Patching exam ${exam.id}...");
        if (_items.values.any((element) =>
            element.date.isAtSameMomentAs(exam.date) && element.player.id == exam.player.id && element.id != exam.id)) {
          throw DuplicateException("Player ${exam.player.id} already had an exam in ${exam.date}");
        } else {
          await ApiService().patch(ApiEndpoints.exam, exam.toJson());
          print("Exam/P: Patched exam ${exam.id} successfully!");
        }
      }
    } catch (e) {
      print("Exam/P: Error patching exam ${exam.id}! $e");
      rethrow;
    } finally {
      (_items.isEmpty) ? _state = ProviderState.empty : _state = ProviderState.ready;
      await get();
    }
  }
}
