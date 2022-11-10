// Libary imports
import 'dart:io';
import 'package:e3/util/globals.dart';
import '../../models/entity.dart';
import '../../models/insurer.dart';
import '../../models/policy.dart';

// Menu to view all data
// Requires an object type to determine which data type to list.
void list(Type obj) {
  switch(obj) {
    case Entity:
      stdout.writeln("Entidades:");
      Map<int, Entity> entities = Entity.cache;
      // Iterate through every entity
      for(int i = 0; i < entities.length; i++){
        Entity entity = entities.entries.elementAt(i).value;
        stdout.writeln("$i. ${entity.name} (${entity.id})");
        stdout.writeln("\t└ Idade: ${entity.age}");
        stdout.writeln("\t└ Morada: ${entity.address}");
      }
      break;
    case Insurer:
      stdout.writeln("Seguradoras");
      Map<int, Insurer> insurers = Insurer.cache;
      // Iterate through every insurer
      for(int i = 0; i < insurers.length; i++){
        Insurer insurer = insurers.entries.elementAt(i).value;
        stdout.writeln("$i. ${insurer.name} (${insurer.id})");
      }
      break;
    case Policy:
      stdout.writeln("Apólices");
      Map<int, Policy> policies = Policy.cache;
      // Iterate through every policy
      for(int i = 0; i < policies.length; i++){
        Policy policy = policies.entries.elementAt(i).value;
        stdout.writeln("$i. "
            "${insuranceTypeToString(policy.insuranceType)} "
            "${policy.insurer.name} "
            "(${policy.id})");
        stdout.writeln("\t└ Tomador: ${policy.holder.name} (${policy.holder.id})");
        stdout.writeln("\t└ Segurado: ${policy.insured.name} (${policy.insured.id})");
        stdout.writeln("\t└ Valor segurado: ${policy.insuredAmount}");
        stdout.writeln("\t└ Valor Prémio: ${policy.billingCost} "
            "${(policy.insuranceType == BillingTypes.monthly) ? ("por mês") : ("por ano") }");
        stdout.writeln("\t└ Estado: ${(policy.active) ? "Ativo" : "Inativo"}");
      }
      break;
  }
}
