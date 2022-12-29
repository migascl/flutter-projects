// Enumerator of all possible Api endpoints
enum ApiEndpoints {
  root(endpoint: '/'),
  country(endpoint: '/country'),
  stadium(endpoint: '/stadium'),
  club(endpoint: '/club'),
  player(endpoint: '/player');

  final String endpoint;

  const ApiEndpoints({required this.endpoint});
}