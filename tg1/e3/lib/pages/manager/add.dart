// Imports
import 'dart:io';
import '../../models/billing_types.dart';
import '../../models/entity.dart';
import '../../models/insurance_types.dart';
import '../../models/insurer.dart';
import '../../models/policy.dart';
import '../../util/exceptions.dart';

void add(Type type) {
  stdout.write("\nAdicionar ");
  switch(type) {
    case Entity:
      stdout.writeln("Entidades:");
      try{
        stdout.write("\tNome: ");
        String? name = stdin.readLineSync();
        stdout.write("\tIdade: ");
        String? age = stdin.readLineSync();
        stdout.write("\tMorada: ");
        String? address = stdin.readLineSync();
        Entity entity = Entity(name: name!, age: int.parse(age!), address: address!);
        stdout.writeln("Entidade ${entity.name} (${entity.id}) criada.");
      } on DuplicateException {
        stdout.writeln("Entidade já existe!");
      } catch (e) {
        stdout.writeln("Formato inválido");
      }
      break;
    case Insurer:
      stdout.writeln("Seguradoras");
      try{
        stdout.write("\tNome: ");
        String? name = stdin.readLineSync();
        Insurer insurer = Insurer(name!);
        stdout.writeln("Seguradora ${insurer.name} (${insurer.id}) criada.");
      } on DuplicateException {
        stdout.writeln("Seguradora já existe!");
      } catch (e) {
        stdout.writeln("Formato inválido");
      }
      break;
    case Policy:
      stdout.writeln("Apólices");
      try{
        // Select Insurer
        stdout.writeln("\tSeguradora: ");
        Map<int, Insurer> insurers = Insurer.cache;
        for(int i = 0; i < insurers.length; i++){
          Insurer insurer = insurers.entries.elementAt(i).value;
          stdout.writeln("\t\t$i. ${insurer.name} (${insurer.id})");
        }
        stdout.write("\tDigite o número do elemento da lista para selecionar a seguradora: ");
        String? insurerIndex = stdin.readLineSync();
        Insurer insurer = Insurer.cache.entries.elementAt(int.parse(insurerIndex!)).value;
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
        Entity holder = Entity.cache.entries.elementAt(int.parse(holderIndex!)).value;
        // Select insured Entity
        stdout.writeln("\tSegurado: ");
        for(int i = 0; i < entities.length; i++){
          Entity entity = entities.entries.elementAt(i).value;
          stdout.writeln("\t\t$i. ${entity.name} (${entity.id})");
        }
        stdout.write("\tDigite o número do elemento da lista para selecionar o tomador: ");
        String? insuredIndex = stdin.readLineSync();
        Entity insured = Entity.cache.entries.elementAt(int.parse(insuredIndex!)).value;
        // Select Insurance Type
        stdout.writeln("\tTipo de Seguro: ");
        for(int i = 0; i < InsuranceTypes.values.length; i++){
          InsuranceTypes insuranceType = InsuranceTypes.values.elementAt(i);
          stdout.writeln("\t\t$i. ${insuranceType.name}");
        }
        stdout.write("\tDigite o número do elemento da lista para selecionar o tipo de seguro: ");
        String? insuranceTypeIndex = stdin.readLineSync();
        InsuranceTypes insuranceType = InsuranceTypes.values.elementAt(int.parse(insuranceTypeIndex!));
        // Insured Amount
        stdout.write("\tValor Segurado: ");
        double? insuredAmount = double.parse(stdin.readLineSync()!);
        // Select Billing Type
        stdout.writeln("\tTipo de Prémio: ");
        for(int i = 0; i < BillingTypes.values.length; i++){
          stdout.writeln("\t\t$i. "
              "${(BillingTypes.values.elementAt(i) == BillingTypes.monthly)
              ? ("Mensal")
              : ("Anual") }");
        }
        stdout.write("\tDigite o número do elemento da lista para selecionar o tipo de prémio: ");
        String? billingTypeIndex = stdin.readLineSync();
        BillingTypes billingType = BillingTypes.values.elementAt(int.parse(billingTypeIndex!));
        // Billing Cost
        stdout.write("\tValor do Prémio a pagar: ");
        double? billingCost = double.parse(stdin.readLineSync()!);
        // Select state
        stdout.writeln("\tEstado: ");
        stdout.writeln("\t\ta. Ativo: ");
        stdout.writeln("\t\tb. Inativo: ");
        stdout.write("\tDigite o caráter correspondente ao estado da apólice: ");
        String? stateIndex = stdin.readLineSync();
        bool active = false;
        switch(stateIndex){
          case 'a':
            active = true;
            break;
          case 'b':
            active = false;
            break;
        }
        Policy policy = Policy(
            insurer: insurer,
            holder: holder,
            insured: insured,
            insuranceType: insuranceType,
            insuredAmount: insuredAmount,
            billingType: billingType,
            billingCost: billingCost,
            active: active);
        stdout.writeln("Apólice "
            "${policy.insuranceType.name} ${policy.insurer.name} "
            "(${policy.id}) criada.");
      } on DuplicateException {
        stdout.writeln("Apólice já existe!");
      } catch (e) {
        stdout.writeln("Formato inválido!");
      }
      break;
  }
}
