enum ApiMethods {
  post(name: 'POST'),
  get(name: 'GET'),
  patch(name: 'PATCH'),
  delete(name: 'DELETE');

  final String name;

  const ApiMethods({required this.name});
}
