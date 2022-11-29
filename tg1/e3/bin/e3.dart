// Imports
import 'package:e3/models/billing_types.dart';
import 'package:e3/models/entity.dart';
import 'package:e3/models/insurance_types.dart';
import 'package:e3/models/insurer.dart';
import 'package:e3/models/policy.dart';
import 'package:e3/pages/menu.dart';

void main(List<String> arguments) {
  // Default data
  var entity1 = Entity(name: "João", age: 56, address: "R Alferes Veiga Pestana 15, Nogueira");
  var entity2 = Entity(name: "Maria", age: 34, address: "Estrada Nacional 12, Aveiro");
  var entity3 = Entity(name: "Ana", age: 48, address: "R Florbela Espanca 106, Amora");
  var entity4 = Entity(name: "Pedro", age: 61, address: "Avenida Forças Armadas 74, Lisboa");
  var insurer1 = Insurer("Tranquilidade");
  var insurer2 = Insurer("OK! teleseguros");
  var insurer3 = Insurer("Seguro Máximo");
  var insurer4 = Insurer("Companherio");
  var policy1 = Policy(
      insurer: insurer1,
      holder: entity2,
      insured: entity1,
      insuranceType: InsuranceTypes.health,
      insuredAmount: 2341.00,
      billingType: BillingTypes.monthly,
      billingCost: 24.49,
      active: true
  );

  var policy2 = Policy(
      insurer: insurer2,
      holder: entity2,
      insured: entity4,
      insuranceType: InsuranceTypes.home,
      insuredAmount: 38923.21,
      billingType: BillingTypes.annually,
      billingCost: 416.6,
      active: true
  );
  var policy3 = Policy(
      insurer: insurer3,
      holder: entity1,
      insured: entity2,
      insuranceType: InsuranceTypes.life,
      insuredAmount: 85902,
      billingType: BillingTypes.annually,
      billingCost: 130.9,
      active: true
  );
  var policy4 = Policy(
      insurer: insurer3,
      holder: entity3,
      insured: entity3,
      insuranceType: InsuranceTypes.car,
      insuredAmount: 39021.20,
      billingType: BillingTypes.monthly,
      billingCost: 60.2,
      active: false
  );

  menu();
}
