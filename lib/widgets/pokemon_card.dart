import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokidex/models/pokemon.dart';
import 'package:pokidex/provider/pokemon_data_provider.dart';
import 'package:pokidex/widgets/pokemon_stats_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ignore: must_be_immutable
class PokemonCard extends ConsumerWidget {
  final String? pokemonUrl;
  late FavoritePokemonProvider _favoritePokemonProvider;
  PokemonCard({
    super.key,
    required this.pokemonUrl,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonProvider = ref.watch(favoritePokemonProvider.notifier);
    final pokemon = ref.watch(PokemonDataProvider(pokemonUrl!));
    return pokemon.when(
      data: (data) {
        return _card(
          context,
          false,
          data!,
        );
      },
      error: (err, stack) {
        return Text('Error: ${err.toString()}');
      },
      loading: () {
        return _card(
          context,
          true,
          null,
        );
      },
    );
  }

  Widget _card(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      ignoreContainers: true,
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
              context: context,
              builder: (_) {
                return PokemonStatsCard(
                  pokemonUrl: pokemonUrl,
                );
              },
            );
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
            vertical: MediaQuery.of(context).size.width * 0.02,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.width * 0.01,
          ),
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon?.name?.toUpperCase() ?? 'Pokemon',
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '#${pokemon?.id?.toString() ?? 0}',
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Material(
                elevation: 5,
                child: Image.network(
                  pokemon?.sprites?.frontDefault ??
                      'https://via.placeholder.com/0',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${pokemon?.moves?.length} Moves',
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      _favoritePokemonProvider
                          .removeFavoritePokemon(pokemonUrl!);
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
