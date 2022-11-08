import 'dart:io';

import 'package:e3/util/globals.dart';

import '../models/insurer.dart';
import '../models/policy.dart';

void dashboard() {

  stdout.writeln("Dashboard:");


  // Query for total active insurance policies
  int totalActivePolicies = 0;
  Policy.cache.forEach((key, value) {
    if (value.active) totalActivePolicies++;
  });
  stdout.writeln("Apólices Ativas: $totalActivePolicies  |  "
      "Apólices Inativas: ${Policy.cache.length - totalActivePolicies}");


  // Query for active policies based on insurance type
  stdout.writeln("Quantidade de Apólices:");
  stdout.writeln("    Por Categoria:");
  // Query for active health insurance policies
  int activeHealthPolicies = 0;
  double sumHealthPolicies = 0;
  Policy.cache.entries.toList().where((e) => e.value.active && e.value.insuranceType == InsuranceTypes.health)
      .forEach((element) {
        activeHealthPolicies++;
        sumHealthPolicies += element.value.insuredAmount;
  });
  double avgHealthPolicies = sumHealthPolicies / activeHealthPolicies;

  // Query for active life insurance policies
  int activeLifePolicies = 0;
  double sumLifePolicies = 0;
  Policy.cache.entries.toList().where((e) => e.value.active && e.value.insuranceType == InsuranceTypes.life)
      .forEach((element) {
    activeLifePolicies++;
    sumLifePolicies += element.value.insuredAmount;
  });
  double avgLifePolicies = sumLifePolicies / activeLifePolicies;

  // Query for active home insurance policies
  int activeHomePolicies = 0;
  double sumHomePolicies = 0;
  Policy.cache.entries.toList().where((e) => e.value.active && e.value.insuranceType == InsuranceTypes.home)
      .forEach((element) {
    activeHomePolicies++;
    sumHomePolicies += element.value.insuredAmount;
  });
  double avgHomePolicies = sumHomePolicies / activeHomePolicies;

  // Query for active car insurance policies
  int activeCarPolicies = 0;
  double sumCarPolicies = 0;
  Policy.cache.entries.toList().where((e) => e.value.active && e.value.insuranceType == InsuranceTypes.car)
      .forEach((element) {
    activeCarPolicies++;
    sumCarPolicies += element.value.insuredAmount;
  });
  double avgCarPolicies = sumCarPolicies / activeCarPolicies;
  stdout.writeln("          Seguro de Saúde: $activeHealthPolicies");
  stdout.writeln("              Média: $avgHealthPolicies€");
  stdout.writeln("          Seguro de Vida: $activeLifePolicies");
  stdout.writeln("              Média: $avgLifePolicies€");
  stdout.writeln("          Seguro de Habitação: $activeHomePolicies");
  stdout.writeln("              Média: $avgHomePolicies€");
  stdout.writeln("          Seguro Automóvel: $activeCarPolicies");
  stdout.writeln("              Média: $avgCarPolicies€");


  // Query for active insurance policies based on insurer
  stdout.writeln("    Por Seguradora:");
  Insurer.cache.forEach((key, value) {
    int _activePolicies = 0;
    double _sumActivePolicies = 0;
    Policy.cache.entries.toList().where((e) => e.value.active && e.value.insurer == value)
        .forEach((element) {
      _activePolicies++;
      _sumActivePolicies += element.value.insuredAmount;
    });
    double _avgActivePolicies = _sumActivePolicies / _activePolicies;
    stdout.writeln("          ${value.name}: $_activePolicies");
    stdout.writeln("              Média: $_avgActivePolicies€");
  });
}
