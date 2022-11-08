import 'dart:convert';

import '../util/generateid.dart';

class Insurer {
  // Class instances cache data
  static final _cache = <int, Insurer>{};

  // Variables
  late String _name;

  // Constructors
  // It follows the Singleton Pattern by checking its cache for duplicates
  factory Insurer(String name) {
    int id = generateID([name]);
    return _cache.putIfAbsent(id, () => Insurer._internal(name));
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
      throw 'Already exists!';
    }
  }

  // Return object in JSON format
  String toJSON() {
    Map json = {
      'id' : id,
      'name' : _name,
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
        }
      };
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      print(encoder.convert(json));
    });
  }
}
