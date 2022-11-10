// Library Imports
import 'dart:io';
import 'package:e3/models/entity.dart';
import '../models/insurer.dart';
import '../models/policy.dart';
import '../util/globals.dart';

// Reports menu
void reports(){
  stdout.writeln("Relatórios");
  stdout.writeln("\tRelatório de apólices ativas:");
  stdout.writeln("\t\t1. Por tipo de seguro");
  stdout.writeln("\t\t2. Por seguradora");
  stdout.writeln("\ta. Relatório de entidades");
  stdout.writeln("Escreva o caráter da opção desejada: ");
  // Receives input from the user, and catches any type error
  try {
    String? option = stdin.readLineSync();
    switch(option) {
      case '1':
        insuranceTypeReport();
        break;
      case '2':
        insurerReport();
        break;
      case 'a':
        entityReport();
        break;
      default:
        stdout.writeln("Opção inválida!");
    }
  } catch (e) {
    stdout.writeln("Opção inválida!");
  }
  // User prompt to go back to menu
  stdout.writeln("\nPrima Enter para voltar ao menu.");
  stdin.readLineSync();
}

// Policy report based on insurance type
void insuranceTypeReport(){
  double _totalBillingCost = 0; // Total billing cost of all active policies
  // Iterate through every insurance Type
  InsuranceTypes.values.forEach((type) {
    double _insuranceTypeBillingCost = 0; // Total billing of cost active policies of a certain type
    int _activePolicies = 0;
    // Query all active policies of a certain insurance type
    Policy.cache.entries.toList()
        .where((e) => e.value.active && e.value.insuranceType == type)
        .forEach((policy) {
          // Convert monthly billing to annually
          (policy.value.billingType == BillingTypes.monthly)
              ? _insuranceTypeBillingCost += policy.value.billingCost * 12
              : _insuranceTypeBillingCost += policy.value.billingCost;
          _activePolicies++;
        });
    // Print result if finds any active policies
    if(_activePolicies > 0){
      stdout.writeln("-${insuranceTypeToString(type)} -> Total: $_insuranceTypeBillingCost€");
    }
    _totalBillingCost += _insuranceTypeBillingCost; // Add sub query result to main query
  });
  stdout.writeln("─────────────────────────────────────────");
  stdout.writeln("Total: $_totalBillingCost€ por ano");
}


// Policy report based on insurer
void insurerReport(){
  double _totalBillingCost = 0; // Total billing cost of all active policies
  // Iterate through every insurer
  Insurer.cache.values.forEach((insurer) {
    double _insurerBillingCost = 0; // Total billing of cost active policies based on insurer
    int _activePolicies = 0;
    // Query all active policies of a certain insurer
    Policy.cache.entries.toList()
        .where((e) => e.value.active && e.value.insurer == insurer)
        .forEach((policy) {
      // Convert monthly billing to annually
      (policy.value.billingType == BillingTypes.monthly)
          ? _insurerBillingCost += policy.value.billingCost * 12
          : _insurerBillingCost += policy.value.billingCost;
      _activePolicies++;
    });
    // Print result if finds any active policies
    if(_activePolicies > 0){
      stdout.writeln("-${insurer.name} -> Total: $_insurerBillingCost€");
    }
    _totalBillingCost += _insurerBillingCost; // Add sub query result to main query
  });
  stdout.writeln("─────────────────────────────────────────");
  stdout.writeln("Total: $_totalBillingCost€ por ano");
}

// Entity report
void entityReport(){
  // Iterate through every entity
  Entity.cache.values.forEach((entity) {
    int _activePolicies = 0;
    // Query all active policies that are connected to the entity
    Policy.cache.entries.toList()
        .where((e) => e.value.active && (e.value.holder == entity || e.value.insured == entity))
        .forEach((policy) {
      _activePolicies++;
    });
    // Print result if finds any active policies
    if(_activePolicies > 0){
      stdout.writeln("-Entidade: ${entity.name}");
      stdout.writeln("\t├Idade: ${entity.age}");
      stdout.writeln("\t└Morada: ${entity.address}");
    }
  });
}