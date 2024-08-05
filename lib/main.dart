import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokidex/pages/home_page.dart';
import 'package:pokidex/services/database_services.dart';
import 'package:pokidex/services/http_service.dart';

void main() async {
  await _setupServices();
  runApp(const MyApp());
}

Future<void> _setupServices() async {
  GetIt.instance.registerSingleton<HttpService>(
    HttpService(),
  );
  GetIt.instance.registerSingleton<DatabaseServices>(
    DatabaseServices(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pokédex',
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
          ),
          textTheme: GoogleFonts.quattrocentoSansTextTheme(),
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
