import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_rca/features/market/data/market_symbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_rca/features/market/bloc/market_bloc.dart';
import 'package:crypto_rca/features/market/bloc/market_event.dart';
import 'package:crypto_rca/features/market/bloc/market_state.dart';
import 'package:crypto_rca/features/market/presentation/market_page.dart';
import 'package:mockito/mockito.dart';

class MockMarketBloc extends MockBloc<MarketEvent, MarketState>
    implements MarketBloc {}

void main() {
  group('MarketPage', () {
    late MarketBloc marketBloc;

    setUp(() {
      marketBloc = MockMarketBloc();
    });

    testWidgets('displays loading indicator when state is MarketLoading',
        (WidgetTester tester) async {
      // Arrange
      whenListen(marketBloc, Stream.fromIterable([MarketLoading()]));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MarketBloc>(
            create: (context) => marketBloc,
            child: const MarketPage(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays market data when state is MarketLoaded',
        (WidgetTester tester) async {
      // Arrange
      final marketData = [
        MarketSymbol(symbol: 'BTCUSD', price: 45000.0),
        MarketSymbol(symbol: 'ETHUSD', price: 3000.0),
        MarketSymbol(symbol: 'BTCUSD', price: 4000.0),
      ];
      whenListen(marketBloc, Stream.fromIterable([MarketLoaded(marketData)]));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MarketBloc>(
            create: (context) => marketBloc,
            child: const MarketPage(),
          ),
        ),
      );

      // Assert
      expect(find.text('BTCUSD'), findsOneWidget);
      expect(find.text('Price: \$45000.00'), findsOneWidget);
      expect(find.text('ETHUSD'), findsOneWidget);
      expect(find.text('Price: \$3000.00'), findsOneWidget);
    });

    testWidgets('displays error message when state is MarketError',
        (WidgetTester tester) async {
      // Arrange
      whenListen(marketBloc,
          Stream.fromIterable([MarketError('Failed to load data')]));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MarketBloc>(
            create: (context) => marketBloc,
            child: const MarketPage(),
          ),
        ),
      );

      // Assert
      expect(find.text('Error: Failed to load data'), findsOneWidget);
    });

    testWidgets('displays unexpected state message with retry button',
        (WidgetTester tester) async {
      // Arrange
      whenListen(marketBloc, Stream.fromIterable([MarketInitial()]));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MarketBloc>(
            create: (context) => marketBloc,
            child: const MarketPage(),
          ),
        ),
      );

      // Assert
      expect(find.text('Unexpected state'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);

      // Simulate button press
      await tester.tap(find.byType(TextButton));
      verify(marketBloc.add(FetchMarketData())).called(1);
    });
  });
}
