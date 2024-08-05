import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokidex/controllers/home_page_controller.dart';
import 'package:pokidex/models/home_page_data.dart';
import 'package:pokidex/models/pokemon.dart';
import 'package:pokidex/provider/pokemon_data_provider.dart';
import 'package:pokidex/widgets/pokemon_card.dart';
import 'package:pokidex/widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(HomePageData.initial());
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _allPokemonListScrollController = ScrollController();
  late HomePageController _homePageController;
  late HomePageData _homePageData;
  late List<String> _favoritePokemon;

  @override
  void initState() {
    super.initState();
    _allPokemonListScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _allPokemonListScrollController.removeListener(_scrollListener);
    _allPokemonListScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_allPokemonListScrollController.offset >=
            _allPokemonListScrollController.position.maxScrollExtent * .5 &&
        !_allPokemonListScrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(
      homePageControllerProvider,
    );
    _favoritePokemon = ref.watch(favoritePokemonProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex',),
        centerTitle: true,
      ),
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
          child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _favoritePokemonList(context),
            _allPokemonList(context),
          ],
        ),
      )),
    );
  }

  Widget _favoritePokemonList(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Favorite Pokémons',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.50,
              width: MediaQuery.sizeOf(context).width * 0.95,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_favoritePokemon.isEmpty)
                    const Text('No Favorite Pokémons yet 🤷‍♂️',style: TextStyle(fontSize: 25)),
                  if (_favoritePokemon.isNotEmpty)
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.48,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _favoritePokemon.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          String pokemonUrl = _favoritePokemon[index];
                          return PokemonCard(
                            pokemonUrl: pokemonUrl,
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _allPokemonList(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All Pokémons',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.60,
              child: ListView.builder(
                controller: _allPokemonListScrollController,
                itemCount: _homePageData.data?.results?.length ?? 0,
                itemBuilder: (context, index) {
                  PokemonListResult pokemon =
                      _homePageData.data!.results![index];
                  String? pokemonUrl = pokemon.url;
                  return PokemonListTile(
                    pokemonUrl: pokemonUrl!,
                  );
                },
              ),
            ),
          ],
        ));
  }
}
