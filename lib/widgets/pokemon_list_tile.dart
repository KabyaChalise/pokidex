import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokidex/models/pokemon.dart';
import 'package:pokidex/provider/pokemon_data_provider.dart';
import 'package:pokidex/widgets/pokemon_stats_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ignore: must_be_immutable
class PokemonListTile extends ConsumerWidget {
  final String? pokemonUrl;
  late FavoritePokemonProvider _favoritePokemonProvider;
  late List<String> _favoritePokemonList;
  PokemonListTile({super.key, required this.pokemonUrl});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    _favoritePokemonProvider = ref.watch(favoritePokemonProvider.notifier);
    _favoritePokemonList = ref.watch(favoritePokemonProvider);
    final pokemon = ref.watch(PokemonDataProvider(pokemonUrl!));

    return pokemon.when(
      data: (data) {
        return _tile(
          context,
          false,
          data!,
        );
      },
      error: (err, stack) {
        return Text('Error: ${err.toString()}');
      },
      loading: () {
        return _tile(
          context,
          true,
          null,
        );
      },
    );
  }

  Widget _tile(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
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
        child: ListTile(
          leading: pokemon != null
              ? CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.lightGreen,
                  child: Image.network(pokemon.sprites!.frontDefault!,))
              : const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.lightGreen,
                ),
          title: Text(
            pokemon != null
                ? pokemon.name!.toUpperCase()
                : 'Currently Loading name for Pokemon',
          ),
          subtitle: Text('Has ${pokemon?.moves!.length.toString() ?? 0} moves'),
          trailing: IconButton(
            onPressed: () {
              if (_favoritePokemonList.contains(pokemonUrl!)) {
                _favoritePokemonProvider.removeFavoritePokemon(pokemonUrl!);
              } else {
                _favoritePokemonProvider.addFavoritePokemon(pokemonUrl!);
              }
            },
            icon:  Icon(
              _favoritePokemonList.contains(pokemonUrl!)
                  ? Icons.favorite
                  : Icons.favorite_border,
                  color: Colors.lightGreen,
            ),
          ),
        ),
      ),
    );
  }
}
