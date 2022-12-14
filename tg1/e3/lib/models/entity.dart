// Imports
import 'dart:convert';
import 'package:e3/util/exceptions.dart';

import '../util/generateid.dart';
import 'package:e3/models/policy.dart';

class Entity {
  // Class instances cache data
  static final _cache = <int, Entity>{};

  // Variables
  late String _name;
  late int _age;
  late String _address;

  // Constructors
  // Before creating an object, it generates a unique ID with the parameters provided
  // This ID is used to check for duplicates, if no duplicates found, it creates the object and stores it in cache
  factory Entity({required String name, required int age, required String address}) {
    int id = generateID([name, age, address]);
    if(_cache.containsKey(id)){
      throw DuplicateException();
    } else {
      return _cache.putIfAbsent(id, () => Entity._internal(name, age, address));
    }
  }
  // Internal constructor (Isn't saved into cache)
  Entity._internal(this._name, this._age, this._address);

  // Getters
  static Map<int, Entity> get cache => _cache;
  String get name => _name;
  int get age => _age;
  String get address => _address;
  int get id => generateID([_name, _age, _address]);

  // Setters
  set name(String e){
    if(e.isEmpty) {
      throw FormatException();
    } else {
      Entity tempObj = Entity._internal(e, age, address);
      if(!_cache.containsKey(tempObj.id)){
        _cache.remove(id);
        _name = e;
        _cache.putIfAbsent(id, () => this);
      } else {
        throw DuplicateException();
      }
    }
  }
  set age(int e){
    if(e <= 0){
      throw FormatException();
    } else {
      Entity tempObj = Entity._internal(name, e, address);
      if(!_cache.containsKey(tempObj.id)){
        _cache.remove(id);
        _age = e;
        _cache.putIfAbsent(id, () => this);
      } else {
        throw DuplicateException();
      }
    }
  }
  set address(String e){
    if(e.isEmpty){
      throw FormatException();
    } else {
      Entity tempObj = Entity._internal(name, age, e);
      if(!_cache.containsKey(tempObj.id)){
        _cache.remove(id);
        _address = e;
        _cache.putIfAbsent(id, () => this);
      } else {
        throw DuplicateException();
      }
    }
  }

  // Remove reference to object in cache
  // Throwing an error if dependencies are found
  static void remove(Entity entity) {
    Policy.cache.forEach((key, value) {
      if (value.holder == entity || value.insured == entity ) {
        throw DependencyException();
      }
    });
    _cache.remove(entity.id);
  }
}
