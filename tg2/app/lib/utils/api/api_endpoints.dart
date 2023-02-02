// Enumerator of all possible Api endpoints
enum ApiEndpoints {
  root(name: '/'),
  country(name: '/country'),
  stadium(name: '/stadium'),
  club(name: '/club'),
  player(name: '/player'),
  exam(name: '/exam'),
  contract(name: '/contract'),
  match(name: '/match');

  final String name;

  const ApiEndpoints({required this.name});
}
