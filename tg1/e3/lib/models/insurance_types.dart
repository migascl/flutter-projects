// Insurance types
enum InsuranceTypes {
  health(name: 'Seguro de Saúde'),
  life(name: 'Seguro de Vida'),
  home(name: 'Seguro de Habitação'),
  car(name: 'Seguro de Automóvel');

  // Variable
  final String name;

  // Constructor
  const InsuranceTypes({required this.name});
}
