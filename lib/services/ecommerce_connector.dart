class EcommerceConnector {
  Future<List<String>> fetchProducts() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () => ['Product A', 'Product B'],
    );
  }
}
