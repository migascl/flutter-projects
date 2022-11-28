// Imports
import 'dart:convert';
import 'package:e3/util/globals.dart';

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
  factory Entity(String name, int age, String address) {
    int id = generateID([name]);
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
  int get id => generateID([_name]);

  // Setters
  // Verify if entity already exists
  set name(String e){
    if(e.isEmpty){
      throw FormatException();
    }
    Entity tempObj = Entity._internal(e, age, address);
    if(!_cache.containsKey(tempObj.id)){
      _cache.remove(id);
      _name = e;
      _cache.putIfAbsent(id, () => this);
    } else {
      throw DuplicateException();
    }
  }
  set age(int e){
    if(e <= 0){
      throw FormatException();
    } else {
      _age = e;
    }
  }
  set address(String e){
    if(e.isEmpty){
      throw FormatException();
    } else {
      _address = e;
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

  // Return object in JSON format
  String toJSON() {
    Map json = {
      'id' : id,
      'name' : _name,
      'age':  _age,
      'address': _address
    };
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  // Print cache data
  static printCache(){
    _cache.forEach((key, value) {
      Map json = {
        'key' : key,
        'value':  {
          'id' : value.id,
          'name' : value.name,
          'age':  value.age,
          'address': value.address
        }
      };
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      print(encoder.convert(json));
    });
  }
}
