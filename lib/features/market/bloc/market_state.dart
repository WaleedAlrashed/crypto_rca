// market_state.dart
import 'package:crypto_rca/features/market/data/market_symbol.dart';

abstract class MarketState {}

class MarketInitial extends MarketState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MarketInitial;

  @override
  int get hashCode => runtimeType.hashCode;
}

class MarketLoading extends MarketState {}

class MarketLoaded extends MarketState {
  final List<MarketSymbol> marketData;

  MarketLoaded(this.marketData);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarketLoaded && marketData == other.marketData;

  @override
  int get hashCode => marketData.hashCode;
}

class MarketError extends MarketState {
  final String error;

  MarketError(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MarketError && error == other.error;

  @override
  int get hashCode => error.hashCode;
}
