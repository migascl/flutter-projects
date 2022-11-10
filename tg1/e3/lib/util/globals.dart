enum InsuranceTypes { health, life, home, car }

String insuranceTypeToString(InsuranceTypes type){
  switch(type) {
    case InsuranceTypes.health:
      return 'Seguro de Saúde';
    case InsuranceTypes.life:
      return 'Seguro de Vida';
    case InsuranceTypes.home:
      return 'Seguro de Habitação';
    case InsuranceTypes.car:
      return 'Seguro Automóvel';
    default:
      return 'NaN';
  }
}

enum BillingTypes { monthly, annually }
