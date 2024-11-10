// market_state.dart
import 'package:crypto_rca/features/market/data/market_symbol.dart';

abstract class MarketState {}

class MarketInitial extends MarketState {}

class MarketLoading extends MarketState {}

class MarketLoaded extends MarketState {
  final List<MarketSymbol> marketData;

  MarketLoaded(this.marketData);
}

class MarketError extends MarketState {
  final String error;

  MarketError(this.error);
}
