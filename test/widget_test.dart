import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_rca/core/config/config.dart';
import 'package:crypto_rca/features/market/bloc/market_bloc.dart';
import 'package:crypto_rca/features/market/bloc/market_event.dart';
import 'package:crypto_rca/features/market/bloc/market_state.dart';
import 'package:crypto_rca/features/market/data/market_symbol.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'dart:convert';

// Mock class for http.Client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('MarketBloc', () {
    late MarketBloc marketBloc;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      marketBloc = MarketBloc();
    });

    tearDown(() {
      marketBloc.close();
    });

    test('initial state is MarketInitial', () {
      expect(marketBloc.state, MarketInitial());
    });

    blocTest<MarketBloc, MarketState>(
      'emits [MarketLoading, MarketLoaded] when FetchMarketData is added and data is fetched successfully',
      build: () {
        when(mockHttpClient.get(Uri.parse(Config.apiUrl)))
            .thenAnswer((_) async => http.Response(
                  json.encode([
                    {'symbol': 'BTCUSD', 'price': 45000.0},
                    {'symbol': 'ETHUSD', 'price': 3000.0},
                  ]),
                  200,
                ));
        return marketBloc;
      },
      act: (bloc) => bloc.add(FetchMarketData()),
      expect: () => [
        MarketLoading(),
        MarketLoaded([
          MarketSymbol(symbol: 'BTCUSD', price: 45000.0),
          MarketSymbol(symbol: 'ETHUSD', price: 3000.0),
        ]),
      ],
    );

    blocTest<MarketBloc, MarketState>(
      'emits [MarketLoading, MarketError] when FetchMarketData is added and an error occurs',
      build: () {
        when(mockHttpClient.get(Uri.parse(Config.apiUrl)))
            .thenThrow(Exception('Failed to load market data'));
        return marketBloc;
      },
      act: (bloc) => bloc.add(FetchMarketData()),
      expect: () => [
        MarketLoading(),
        isA<MarketError>(),
      ],
    );
  });
}
