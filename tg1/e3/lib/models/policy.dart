// Imports
import 'dart:convert';
import '../util/generateid.dart';
import '../util/exceptions.dart';
import 'billing_types.dart';
import 'entity.dart';
import 'insurance_types.dart';
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
  // Before creating an object, it generates a unique ID with the parameters provided
  // This ID is used to check for duplicates, if no duplicates found, it creates the object and stores it in cache
  factory Policy({
    required Insurer insurer,
    required Entity holder,
    required Entity insured,
    required InsuranceTypes insuranceType,
    required double insuredAmount,
    required BillingTypes billingType,
    required var billingCost,
    required bool active
  })
  {
    int id = generateID([insurer, holder, insured, insuranceType]);
    if(_cache.containsKey(id)){
      throw DuplicateException();
    } else {
      return _cache.putIfAbsent(id, () =>
          Policy._internal(
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
    if(e == _insurer) return;
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
      throw DuplicateException();
    }
  }
  set holder(Entity e) {
    if(e == _holder) return;
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
      throw DuplicateException();
    }
  }
  set insured(Entity e) {
    if(e == _insured) return;
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
      throw DuplicateException();
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
      throw DuplicateException();
    }
  }
  set insuredAmount(double e) => _insuredAmount = e;
  set billingType(BillingTypes e) => _billingType = e;
  set billingCost(double e) => _billingCost = e;
  set active(bool e) => _active = e;

  // Remove reference to object in cache
  static void remove(Policy policy) {
    _cache.remove(policy.id);
  }
}
