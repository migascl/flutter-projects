// Library imports
import 'dart:io';
import '../../models/billing_types.dart';
import '../../models/entity.dart';
import '../../models/insurance_types.dart';
import '../../models/insurer.dart';
import '../../models/policy.dart';
import '../../util/exceptions.dart';

// Menu to view all data
// Requires an object type to determine which data type to list.
void list(Type type) {
  stdout.writeln("");
  switch(type) {
    case Entity:
      stdout.writeln("Entidades:");
      Map<int, Entity> entities = Entity.cache;
      // Iterate through every entity
      for(int i = 0; i < entities.length; i++){
        Entity entity = entities.entries.elementAt(i).value;
        stdout.writeln("\t$i. ${entity.name} (${entity.id})");
        stdout.writeln("\t\t└ Idade: ${entity.age}");
        stdout.writeln("\t\t└ Morada: ${entity.address}");
      }
      stdout.write("Digite o número do elemento da lista para selecionar uma entidade:");
      try {
        String? index = stdin.readLineSync();
        Entity entity = Entity.cache.entries.elementAt(int.parse(index!)).value;
        stdout.write("└ Editar (e) ou Remover (r) ${entity.name} (${entity.id}): ");
        String? option = stdin.readLineSync();
        switch(option) {
          // Edit Entity
          case 'e':
            stdout.writeln("\nEditar ${entity.name} (Caso não queira editar um campo em espcífico, prima enter)");
            stdout.write("\t └ Nome: ");
            String? name = stdin.readLineSync();
            stdout.write("\t └ Idade: ");
            String? age = stdin.readLineSync();
            stdout.write("\t └ Morada: ");
            String? address = stdin.readLineSync();
            // Check if entries are not empty
            if(name!.isNotEmpty) entity.name = name;
            if(age!.isNotEmpty) entity.age = int.parse(age);
            if(address!.isNotEmpty) entity.address = address;
            stdout.writeln("Entidade ${entity.name} alterada com successo");
            break;
          // Remove Entity
          case 'r':
            Entity.remove(entity);
            stdout.writeln("Entidade ${entity.name} apagada.");
            break;
          default:
            stdout.writeln("Opção inválida!");
        }
      } on DependencyException {
        stdout.writeln("Existem apólices associadas a esta entidade.");
      } on DuplicateException {
        stdout.writeln("Esta entidade já existe.");
      }
      catch (e) {
        stdout.writeln("Ocorreu um erro! $e");
      }
      break;

    case Insurer:
      stdout.writeln("Seguradoras:");
      Map<int, Insurer> insurers = Insurer.cache;
      // Iterate through every insurer
      for(int i = 0; i < insurers.length; i++){
        Insurer insurer = insurers.entries.elementAt(i).value;
        stdout.writeln("\t$i. ${insurer.name} (${insurer.id})");
      }
      stdout.write("Digite o número do elemento da lista para selecionar uma seguradora:");
      try {
        String? index = stdin.readLineSync();
        Insurer insurer = Insurer.cache.entries.elementAt(int.parse(index!)).value;
        stdout.write("└ Editar (e) ou Remover (r) ${insurer.name} (${insurer.id}): ");
        String? option = stdin.readLineSync();
        switch(option) {
          // Edit Insurer
          case 'e':
            stdout.writeln("\nEditar ${insurer.name} (Caso não queira editar um campo em espcífico, prima enter)");
            stdout.write("\t └ Nome: ");
            String? name = stdin.readLineSync();
            // Check if entries are not empty
            if(name!.isNotEmpty) insurer.name = name;
            stdout.writeln("Seguradora ${insurer.name} alterada com successo");
            break;
          // Remove Insurer
          case 'r':
            Insurer.remove(insurer);
            stdout.writeln("Seguradora ${insurer.name} apagada.");
            break;
          default:
            stdout.writeln("Opção inválida!");
        }
      } on DependencyException {
        stdout.writeln("Existem apólices associadas a esta entidade.");
      } on DuplicateException {
        stdout.writeln("Esta entidade já existe.");
      } catch (e) {
        stdout.writeln("Ocorreu um erro! $e");
      }
      break;


    case Policy:
      stdout.writeln("Apólices:");
      Map<int, Policy> policies = Policy.cache;
      // Iterate through every policy
      for(int i = 0; i < policies.length; i++){
        Policy policy = policies.entries.elementAt(i).value;
        stdout.writeln("\t$i. "
            "${policy.insuranceType.name} "
            "${policy.insurer.name} "
            "(${policy.id})");
        stdout.writeln("\t\t└ Tomador: ${policy.holder.name} (${policy.holder.id})");
        stdout.writeln("\t\t└ Segurado: ${policy.insured.name} (${policy.insured.id})");
        stdout.writeln("\t\t└ Valor segurado: ${policy.insuredAmount}");
        stdout.writeln("\t\t└ Valor Prémio: ${policy.billingCost} "
            "${(policy.billingType == BillingTypes.monthly) ? ("por mês") : ("por ano") }");
        stdout.writeln("\t\t└ Estado: ${(policy.active) ? "Ativo" : "Inativo"}");
      }
      stdout.write("Digite o número do elemento da lista para selecionar uma apólice:");
      try {
        String? index = stdin.readLineSync();
        Policy policy = Policy.cache.entries.elementAt(int.parse(index!)).value;
        stdout.write("└ Editar (e) ou Remover (r) "
            "${policy.insuranceType.name} "
            "${policy.insurer.name} "
            "(${policy.id}): ");
        String? option = stdin.readLineSync();
        switch(option) {
          case 'e':
            // Select Insurer
            stdout.writeln("\tSeguradora: ");
            Map<int, Insurer> insurers = Insurer.cache;
            for(int i = 0; i < insurers.length; i++){
              Insurer insurer = insurers.entries.elementAt(i).value;
              stdout.writeln("\t\t$i. ${insurer.name} (${insurer.id})");
            }
            stdout.write("\tDigite o número do elemento da lista para selecionar a seguradora: ");
            String? insurerIndex = stdin.readLineSync();
            if(insurerIndex!.isNotEmpty) policy.insurer = Insurer.cache.entries.elementAt(int.parse(insurerIndex)).value;
            // Select Entities
            Map<int, Entity> entities = Entity.cache;
            // Select holder Entity
            stdout.writeln("\tTomador: ");
            for(int i = 0; i < entities.length; i++){
              Entity entity = entities.entries.elementAt(i).value;
              stdout.writeln("\t\t$i. ${entity.name} (${entity.id})");
            }
            stdout.write("\tDigite o número do elemento da lista para selecionar o tomador: ");
            String? holderIndex = stdin.readLineSync();
            if(holderIndex!.isNotEmpty) policy.holder = Entity.cache.entries.elementAt(int.parse(holderIndex)).value;
            // Select insured Entity
            stdout.writeln("\tSegurado: ");
            for(int i = 0; i < entities.length; i++){
              Entity entity = entities.entries.elementAt(i).value;
              stdout.writeln("\t\t$i. ${entity.name} (${entity.id})");
            }
            stdout.write("\tDigite o número do elemento da lista para selecionar o tomador: ");
            String? insuredIndex = stdin.readLineSync();
            if(insuredIndex!.isNotEmpty) policy.insured = Entity.cache.entries.elementAt(int.parse(insuredIndex)).value;
            // Select Insurance Type
            stdout.writeln("\tTipo de Seguro: ");
            for(int i = 0; i < InsuranceTypes.values.length; i++){
              InsuranceTypes insuranceType = InsuranceTypes.values.elementAt(i);
              stdout.writeln("\t\t$i. ${insuranceType.name}");
            }
            stdout.write("\tDigite o número do elemento da lista para selecionar o tipo de seguro: ");
            String? insuranceTypeIndex = stdin.readLineSync();
            if(insuranceTypeIndex!.isNotEmpty) policy.insuranceType = InsuranceTypes.values.elementAt(int.parse(insuranceTypeIndex));
            // Insured Amount
            stdout.write("\tValor Segurado: ");
            String? insuredAmount = stdin.readLineSync();
            if(insuredAmount!.isNotEmpty) policy.insuredAmount = double.parse(insuredAmount);
            // Select Billing Type
            stdout.writeln("\tTipo de Prémio: ");
            for(int i = 0; i < BillingTypes.values.length; i++){
              stdout.writeln("\t\t$i. "
                  "${(BillingTypes.values.elementAt(i) == BillingTypes.monthly)
                  ? ("Mensal")
                  : ("Anual") }");
            }
            stdout.write("\tDigite o número do elemento da lista para selecionar o tipo de prémio: ");
            String? billingTypeIndex = stdin.readLineSync();// Billing Cost
            if(billingTypeIndex!.isNotEmpty) policy.billingType = BillingTypes.values.elementAt(int.parse(billingTypeIndex));
            // Billing Cost
            stdout.write("\tValor do Prémio a pagar: ");
            String? billingCost = stdin.readLineSync();
            if(billingCost!.isNotEmpty) policy.billingCost = double.parse(billingCost);
            // Select state
            stdout.writeln("\tEstado: ");
            stdout.writeln("\t\ta. Ativo: ");
            stdout.writeln("\t\tb. Inativo: ");
            stdout.write("\tDigite o caráter correspondente ao estado da apólice: ");
            String? stateIndex = stdin.readLineSync();
            bool? active;
            switch(stateIndex){
              case 'a':
                active = true;
                break;
              case 'b':
                active = false;
                break;
            }
            if(active != null) policy.active = active;
            stdout.writeln("Apólice "
                "${policy.insuranceType.name} "
                "${policy.insurer.name} "
                "(${policy.id}) alterada.");
            break;
          // Remove Policy
          case 'r':
            Policy.remove(policy);
            stdout.writeln("Apólice "
            "${policy.insuranceType.name} "
            "${policy.insurer.name} "
            "(${policy.id}) apagada.");
            break;
          default:
            stdout.writeln("Opção inválida!");
        }
      } catch (e) {
        stdout.writeln("Ocorreu um erro! $e");
      }
      break;
  }
}
