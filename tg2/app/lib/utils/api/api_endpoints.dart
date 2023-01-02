// Enumerator of all possible Api endpoints
enum ApiEndpoints {
  root(endpoint: '/'),
  country(endpoint: '/country'),
  stadium(endpoint: '/stadium'),
  club(endpoint: '/club'),
  player(endpoint: '/player'),
  exam(endpoint: '/exam');

  final String endpoint;

  const ApiEndpoints({required this.endpoint});
}