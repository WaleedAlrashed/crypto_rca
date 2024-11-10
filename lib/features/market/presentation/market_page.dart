import 'package:crypto_rca/core/config/config.dart';
import 'package:crypto_rca/features/market/bloc/market_bloc.dart';
import 'package:crypto_rca/features/market/bloc/market_event.dart';
import 'package:crypto_rca/features/market/bloc/market_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Config.appTitle),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<MarketBloc, MarketState>(
        builder: (context, state) {
          if (state is MarketLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MarketLoaded) {
            return ListView.builder(
              addAutomaticKeepAlives: true,
              itemCount: state.marketData.length,
              itemBuilder: (context, index) {
                final marketSymbol = state.marketData[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 3,
                  child: RepaintBoundary(
                    child: ListTile(
                      key: ValueKey("${marketSymbol.symbol} $index"),
                      contentPadding: const EdgeInsets.all(8),
                      title: Text(
                        marketSymbol.symbol,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price: \$${marketSymbol.price.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is MarketError) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else {
            return Center(
              child: Column(
                children: [
                  const Text('Unexpected state'),
                  TextButton(
                    onPressed: () {
                      context.read<MarketBloc>().add(FetchMarketData());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
