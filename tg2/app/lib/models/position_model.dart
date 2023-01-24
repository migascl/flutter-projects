// Enumerator for Position entity
enum Position {
  goalkeeper(name: "Guarda-redes"),
  defender(name: "Defesa"),
  midfielder(name: "Médio"),
  forward(name: "Avançado");

  const Position({required this.name});

  final String name; // Position label name
}
