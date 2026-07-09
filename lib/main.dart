import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
// Importe seus viewmodels aqui depois de criá-los!

void main() async {
  // 1. Avisa o Flutter que precisamos rodar código nativo antes de desenhar a tela
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa o banco de dados Hive no celular
  await Hive.initFlutter();

  // 3. Abre a caixa principal que vai guardar o nome de quem logou
  await Hive.openBox('sessionBox');

  // 4. (Faremos depois) Registrar os adaptadores do Hive

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
