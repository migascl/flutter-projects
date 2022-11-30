// Imports
import 'dart:convert';
import 'package:e3/util/exceptions.dart';

import '../util/generateid.dart';
import 'package:e3/models/policy.dart';

class Insurer {
  // Class instances cache data
  static final _cache = <int, Insurer>{};

  // Variables
  late String _name;

  // Constructors
  // Before creating an object, it generates a unique ID with the parameters provided
  // This ID is used to check for duplicates, if no duplicates found, it creates the object and stores it in cache
  factory Insurer(String name) {
    int id = generateID([name]);
    if(_cache.containsKey(id)){
      throw DuplicateException();
    } else {
      return _cache.putIfAbsent(id, () => Insurer._internal(name));
    }
  }
  // Internal constructor (Isn't saved into cache)
  Insurer._internal(this._name);

  // Getters
  static Map<int, Insurer> get cache => _cache;
  String get name => _name;
  int get id => generateID([_name]);

  //Setters
  // Verify if insurer already exists
  set name(e){
    Insurer tempObj = Insurer._internal(e);
    if(!_cache.containsKey(tempObj.id)){
      _cache.remove(id);
      _name = e;
      _cache.putIfAbsent(id, () => this);
    } else {
      throw DuplicateException();
    }
  }

  // Remove reference to object in cache
  // Throwing an error if dependencies are found
  static void remove(Insurer insurer) {
    Policy.cache.forEach((key, value) {
      if (value.insurer == insurer) {
        throw DependencyException();
      }
    });
    _cache.remove(insurer.id);
  }
}
