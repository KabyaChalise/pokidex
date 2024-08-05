import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokidex/models/home_page_data.dart';
import 'package:pokidex/models/pokemon.dart';
import 'package:pokidex/services/http_service.dart';

class HomePageController extends StateNotifier<HomePageData> {
  final GetIt _getIt = GetIt.instance;
  late HttpService _httpService;
  HomePageController(super._state) {
    _httpService = _getIt.get<HttpService>();
    _setup();
  }
  Future<void> _setup() async {
    loadData();
  }

  Future<void> loadData() async {
    if (state.data == null) {
      Response? response =
          await _httpService.get('https://pokeapi.co/api/v2/pokemon');
      if (response != null && response.data != null) {
        PokemonListData pokemonListData =
            PokemonListData.fromJson(response.data);
        state = state.copyWith(data: pokemonListData);
      }
    } else {
      if (state.data!.next != null) {
        Response? response = await _httpService.get(state.data!.next!);
        if (response != null && response.data != null) {
          PokemonListData pokemonListData =
              PokemonListData.fromJson(response.data);
          state = state.copyWith(
            data: state.data!.copyWith(
              results: [
                ...state.data!.results!,
                ...pokemonListData.results!,
              ],
            ),
          );
        }
      }
    }
  }
}
