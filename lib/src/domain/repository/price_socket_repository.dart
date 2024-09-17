abstract class PriceSocketRepository {
  Stream<dynamic>? subscribe({
    required String? symbol,
  });

  void disconnect();

  Future<void> connect();
}
