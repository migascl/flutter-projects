// Imports
import 'dart:io';
import '../models/insurance_types.dart';
import '../models/insurer.dart';
import '../models/policy.dart';

// Displays summed up version of the data
void dashboard() {
  if(Policy.cache.isNotEmpty) {
    stdout.writeln("\nQuantidade de Apólices:");
    // Query for total active insurance policies
    int totalActivePolicies = 0; // Number of active policies
    Policy.cache.forEach((key, value) {
      if (value.active) totalActivePolicies++;
    });
    stdout.writeln("\t├ Ativas: $totalActivePolicies");
    stdout.writeln(
        "\t└ Inativas: ${Policy.cache.length - totalActivePolicies}");


    // Query for active policies based on insurance type
    stdout.writeln("\tPor Categoria:");
    InsuranceTypes.values.forEach((type) {
      int _activePolicies = 0; // Number of active policies
      double _sumInsuredAmount = 0; // Sum of all policies insured amount
      // Query
      Policy.cache.entries.toList().where((e) =>
      e.value.active && e.value.insuranceType == type)
          .forEach((policy) {
        _activePolicies++;
        _sumInsuredAmount += policy.value.insuredAmount;
      });
      double _avgInsuredAmounts = _sumInsuredAmount /
          _activePolicies; // Calculate average insured amount
      // Only print result if found any policies
      if (_activePolicies > 0) {
        stdout.writeln("\t\t- ${type.name}: $_activePolicies");
        stdout.writeln("\t\t  └ Média: $_avgInsuredAmounts€");
      }
    });


    // Query for active insurance policies based on insurer
    stdout.writeln("\tPor Seguradora:");
    Insurer.cache.forEach((key, value) {
      int _activePolicies = 0; // Number of active policies
      double _sumInsuredAmount = 0; // Sum of all policies insured amount
      // Query
      Policy.cache.entries.toList().where((e) =>
      e.value.active && e.value.insurer == value)
          .forEach((element) {
        _activePolicies++;
        _sumInsuredAmount += element.value.insuredAmount;
      });
      double _avgInsuredAmounts = _sumInsuredAmount /
          _activePolicies; // Calculate average insured amount
      // Only print result if found any policies
      if (_activePolicies > 0) {
        stdout.writeln("\t\t- ${value.name}: $_activePolicies");
        stdout.writeln("\t\t  └ Média: $_avgInsuredAmounts€");
      }
    });
  } else {
    stdout.writeln("\nNão existem apólices.");
  }
}
