class MarketSymbol {
  final String symbol;
  final double price;

  MarketSymbol({
    required this.symbol,
    required this.price,
  });

  factory MarketSymbol.fromJson(Map<String, dynamic> json) {
    return MarketSymbol(
      symbol: json['symbol'],
      price: json['price'].toDouble() ?? 0.00,
    );
  }
}
