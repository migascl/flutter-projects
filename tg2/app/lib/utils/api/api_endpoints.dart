// Enumerator of all possible Api endpoints
enum ApiEndpoints {
  root(endpoint: '/'),
  country(endpoint: '/country');

  final String endpoint;

  const ApiEndpoints({required this.endpoint});
}