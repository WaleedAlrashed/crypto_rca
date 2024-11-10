import 'package:crypto_rca/features/market/bloc/market_bloc.dart';
import 'package:crypto_rca/features/market/bloc/market_event.dart';
import 'package:crypto_rca/features/market/presentation/market_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TradingApp extends StatelessWidget {
  const TradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => MarketBloc()..add(FetchMarketData()),
        child: const MarketPage(),
      ),
    );
  }
}
