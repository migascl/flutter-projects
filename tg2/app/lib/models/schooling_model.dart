// Enumerator for Position entity
enum Schooling {
  preSchool(name: "Ensino Básico - 1º Ciclo"),
  elementarySchool(name: "Ensino Básico - 2º Ciclo"),
  middleSchool(name: "Ensino Básico - 3º Ciclo"),
  highSchool(name: "Ensino Secundário"),
  college(name: "Ensino Superior");

  const Schooling({required this.name});

  final String name; // Position label name
}
