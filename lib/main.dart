import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'models/album.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  // 1. Avisa o Flutter que precisamos rodar código nativo antes de desenhar a tela
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa o banco de dados Hive no celular
  await Hive.initFlutter();

  // 3. Abre a caixa principal que vai guardar o nome de quem logou
  await Hive.openBox('sessionBox');

  // 4. Registrar os adaptadores do Hive
  Hive.registerAdapter(AlbumAdapter());

  // 5. Inicia o app envelopado no MultiProvider
  runApp(
    MultiProvider(
      providers: [
        // Vamos colocar nossos ViewModels aqui nos próximos passos
      ],
      child: const CisoundApp(),
    ),
  );
}

class CisoundApp extends StatelessWidget {
  const CisoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cisound',
      theme: ThemeData.dark(useMaterial3: true), // Dark mode minimalista!
      initialRoute: '/login',
      routes: {
        // Vamos mapear as telas aqui no Épico 4
      },
    );
  }
}
