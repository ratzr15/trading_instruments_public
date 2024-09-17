abstract class TradeSymbolsDataSource {
  Future<List<dynamic>> call({
    required String exchange,
  });
}
