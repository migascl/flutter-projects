// Imports
import 'dart:io';
import 'package:e3/util/globals.dart';
import '../models/insurer.dart';
import '../models/policy.dart';

// Displays summed up version of the data
void dashboard() {

  stdout.writeln("Dashboard:");
  stdout.writeln("Quantidade de Apólices:");
  // Query for total active insurance policies
  int totalActivePolicies = 0;
  Policy.cache.forEach((key, value) {
    if (value.active) totalActivePolicies++;
  });
  stdout.writeln("\t├ Ativas: $totalActivePolicies");
  stdout.writeln("\t└ Inativas: ${Policy.cache.length - totalActivePolicies}");


  // Query for active policies based on insurance type
  stdout.writeln("\tPor Categoria:");
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
      stdout.writeln("\t\t- ${insuranceTypeToString(type)}: $_activePolicies");
      stdout.writeln("\t\t  └ Média: $_avgActivePolicies€");
    }
  });


  // Query for active insurance policies based on insurer
  stdout.writeln("\tPor Seguradora:");
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
      stdout.writeln("\t\t- ${value.name}: $_activePolicies");
      stdout.writeln("\t\t  └ Média: $_avgActivePolicies€");
    }
  });
}
