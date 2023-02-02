// Enumerator for Schooling entity
enum Schooling {
  preschool(name: "Ensino Básico - 1º Ciclo"),
  elementary(name: "Ensino Básico - 2º Ciclo"),
  middleschool(name: "Ensino Básico - 3º Ciclo"),
  highschool(name: "Ensino Secundário"),
  college(name: "Ensino Superior");

  const Schooling({required this.name});

  final String name; // Schooling label name
}
