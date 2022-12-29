// Enumerator of all possible Api endpoints
enum ApiEndpoints {
  root(endpoint: '/'),
  country(endpoint: '/country'),
  stadium(endpoint: '/stadium');

  final String endpoint;

  const ApiEndpoints({required this.endpoint});
}