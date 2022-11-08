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
  InsuranceTypes.values.forEach((type) {
    int _activePolicies = 0;
    double _sumActivePolicies = 0;
    Policy.cache.entries.toList().where((e) => e.value.active && e.value.insuranceType == type)
        .forEach((policy) {
          _activePolicies++;
          _sumActivePolicies += policy.value.insuredAmount;
    });
    double _avgActivePolicies = _sumActivePolicies / _activePolicies;
    if(_activePolicies > 0){
      stdout.writeln("          ${Policy.insuranceTypeToString(type)}: $_activePolicies");
      stdout.writeln("              Média: $_avgActivePolicies€");
    }
  });


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
    if(_activePolicies > 0) {
      stdout.writeln("          ${value.name}: $_activePolicies");
      stdout.writeln("              Média: $_avgActivePolicies€");
    }
  });
}
