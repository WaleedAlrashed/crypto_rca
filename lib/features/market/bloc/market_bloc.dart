// market_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:crypto_rca/core/config/config.dart';
import 'package:crypto_rca/features/market/data/market_symbol.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'market_event.dart';
import 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  MarketBloc() : super(MarketInitial()) {
    on<FetchMarketData>((event, emit) async {
      emit(MarketLoading());
      final marketState = await _fetchMarketDataWithRetry(emit);
      if (marketState is MarketLoaded) {
        emit(marketState);
      } else if (marketState is MarketError) {
        emit(marketState);
      }
    });
  }

  final int maxRetries = 3;
  final int baseDelay = 2;

  Future<MarketState> _fetchMarketDataWithRetry(
      Emitter<MarketState> emit) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        final response = await http.get(Uri.parse(Config.apiUrl));

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          List<MarketSymbol> marketSymbols =
              data.map((json) => MarketSymbol.fromJson(json)).toList();
          return MarketLoaded(marketSymbols);
        } else {
          throw Exception('Failed to load market data');
        }
      } catch (error) {
        attempt++;
        if (attempt >= maxRetries) {
          return MarketError("Error fetching market data: $error");
        } else {
          await Future.delayed(Duration(seconds: baseDelay * attempt));
        }
      }
    }
    return MarketError("Max retries reached");
  }
}
