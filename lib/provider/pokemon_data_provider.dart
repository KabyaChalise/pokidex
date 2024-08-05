import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokidex/models/pokemon.dart';
import 'package:pokidex/services/database_services.dart';
import 'package:pokidex/services/http_service.dart';

final PokemonDataProvider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HttpService httpService = GetIt.instance.get<HttpService>();
  Response? response = await httpService.get(
    url,
  );
  if (response != null && response.data != null) {
    Pokemon pokemon = Pokemon.fromJson(response.data);
    return pokemon;
  }
  return null;
});
final favoritePokemonProvider =
    StateNotifierProvider<FavoritePokemonProvider, List<String>>((ref) {
  return FavoritePokemonProvider([]);
});

class FavoritePokemonProvider extends StateNotifier<List<String>> {
  final DatabaseServices _databaseServices =
      GetIt.instance.get<DatabaseServices>();

  String FAVORITE_POKEMON_KEY = 'FAVORITE_POKEMON_KEY';

  FavoritePokemonProvider(super._state) {
    _setup();
  }
  Future<void> _setup() async {
    List<String>? result = await _databaseServices.getList(
      FAVORITE_POKEMON_KEY,
    );
    state = result ?? [];
  }

  void addFavoritePokemon(String pokemonUrl) async {
    state = [...state, pokemonUrl];
    _databaseServices.saveList(FAVORITE_POKEMON_KEY, state);
  }

  void removeFavoritePokemon(String pokemonUrl) async {
    state = state.where((e) => e != pokemonUrl).toList();
    _databaseServices.saveList(FAVORITE_POKEMON_KEY, state);
  }
}
