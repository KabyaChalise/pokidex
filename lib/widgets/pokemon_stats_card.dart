import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokidex/provider/pokemon_data_provider.dart';

class PokemonStatsCard extends ConsumerWidget {
  final String? pokemonUrl;
  const PokemonStatsCard({
    super.key,
    required this.pokemonUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(PokemonDataProvider(pokemonUrl!));
    return AlertDialog(
      title: const Text('Statistics'),
      content: pokemon.when(
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: data?.stats?.map(
              (stats) {
                return  Text("${stats.stat?.name!.toUpperCase()}: ${stats.baseStat}");
              },
            ).toList() ??
                [],
          );
        },
        error: (err, stack) {
          return Text('Error: ${err.toString()}');
        },
        loading: () {
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
