import 'dart:convert';

import '../util/generateid.dart';
import '../util/globals.dart';
import 'entity.dart';
import 'insurer.dart';

class Policy {
  // Class instances cache data
  static final _cache = <int, Policy>{};

  // Variables
  late Insurer _insurer; // Insurer name (Seguradora)
  late Entity _holder; // Name of the policyholder (Tomador)
  late Entity _insured; // Name of the entity being insured (Segurado)
  late InsuranceTypes _insuranceType; // Insurance type
  late double _insuredAmount; // Amount insured (Valor segurado)
  late BillingTypes _billingType; // Billing type (monthly, anually)
  late double _billingCost; // Billing cost of the insurance (Valor do prémio a pagar)
  late bool _active; // Policy status

  // Constructors
  // It follows the Singleton Pattern by checking its cache for duplicates
  factory Policy(
      Insurer insurer,
      Entity holder,
      Entity insured,
      InsuranceTypes insuranceType,
      double insuredAmount,
      BillingTypes billingType,
      var billingCost,
      bool active
      )
  {
    int id = generateID([insurer, holder, insured, insuranceType]);
    return _cache.putIfAbsent(id, () => Policy._internal(
        insurer,
        holder,
        insured,
        insuranceType,
        insuredAmount,
        billingType,
        billingCost,
        active
    ));
  }
  // Internal constructor (Isn't saved into cache)
  Policy._internal(
      this._insurer,
      this._holder,
      this._insured,
      this._insuranceType,
      this._insuredAmount,
      this._billingType,
      this._billingCost,
      this._active);

  // Getters
  Insurer get insurer => _insurer;
  Entity get holder => _holder;
  Entity get insured => _insured;
  InsuranceTypes get insuranceType => _insuranceType;
  double get insuredAmount => _insuredAmount;
  BillingTypes get billingType => _billingType;
  double get billingCost => _billingCost;
  bool get active => _active;
  int get id => generateID([_insurer, _holder, _insured, _insuranceType]);
  static Map<int, Policy> get cache => _cache;

  // Setters
  set insurer(Insurer e) {
    Policy tempObj = Policy._internal(
        e,
        holder,
        insured,
        insuranceType,
        insuredAmount,
        billingType,
        billingCost,
        active
    );
    if(!_cache.containsKey(tempObj.id)){
      _cache.remove(id);
      _insurer = e;
      _cache.putIfAbsent(id, () => this);
    } else {
      throw 'Already exists!';
    }
  }
  set holder(Entity e) {
    Policy tempObj = Policy._internal(
        insurer,
        e,
        insured,
        insuranceType,
        insuredAmount,
        billingType,
        billingCost,
        active
    );
    if(!_cache.containsKey(tempObj.id)){
      _cache.remove(id);
      _holder = e;
      _cache.putIfAbsent(id, () => this);
    } else {
      throw 'Already exists!';
    }
  }
  set insured(Entity e) {
    Policy tempObj = Policy._internal(
        insurer,
        holder,
        e,
        insuranceType,
        insuredAmount,
        billingType,
        billingCost,
        active
    );
    if(!_cache.containsKey(tempObj.id)){
      _cache.remove(id);
      _insured = e;
      _cache.putIfAbsent(id, () => this);
    } else {
      throw 'Already exists!';
    }
  }
  set insuranceType(InsuranceTypes e) {
    Policy tempObj = Policy._internal(
        insurer,
        holder,
        insured,
        e,
        insuredAmount,
        billingType,
        billingCost,
        active
    );
    if(!_cache.containsKey(tempObj.id)){
      _cache.remove(id);
      _insuranceType = e;
      _cache.putIfAbsent(id, () => this);
    } else {
      throw 'Already exists!';
    }
  }
  set insuredAmount(e) => _insuredAmount = e;
  set billingType(BillingTypes e) {
    Policy tempObj = Policy._internal(
        insurer,
        holder,
        insured,
        insuranceType,
        insuredAmount,
        e,
        billingCost,
        active
    );
    if(!_cache.containsKey(tempObj.id)){
      _cache.remove(id);
      _billingType = e;
      _cache.putIfAbsent(id, () => this);
    } else {
      throw 'Already exists!';
    }
  }
  set billingCost(e) => _billingCost = e;
  set active(e) => _active = e;

  // Remove reference to object in cache
  static void remove(Policy policy) {
    _cache.remove(policy.id);
  }

  // Return object in JSON format
  String toJSON() {
    Map json = {
      'id' : id,
      'insurer': _insurer.toJSON(),
      'holder': _holder.toJSON(),
      'insured': _insured.toJSON(),
      'insuranceType': _insuranceType.name,
      'insuredAmount': _insuredAmount,
      'billingType': _billingType.name,
      'billingCost': _billingCost,
      'active': _active,
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
          'insurer': {
            'id' : value._insurer.id,
            'name' : value._insurer.name,
          },
          'holder': {
            'id' : value._holder.id,
            'name' : value._holder.name,
            'age':  value._holder.age,
            'address': value._holder.address
          },
          'insured': {
            'id' : value._insured.id,
            'name' : value._insured.name,
            'age':  value._insured.age,
            'address': value._insured.address
          },
          'insuranceType': value.insuranceType.name,
          'insuredAmount': value.insuredAmount,
          'billingType': value.billingType.name,
          'billingCost': value.billingCost,
          'active': value.active,
        }
      };
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      print(encoder.convert(json));
    });
  }
}
