import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:knowledge_base_flutter/src/knowledge_base_page.dart';
import 'package:knowledge_base_flutter/src/startup.dart';
import 'package:knowledge_base_flutter/src/models.dart';

final getIt = GetIt.instance;

void main() {
  initGetIt();
  runApp(const MyApp());
}

Widget waitForInit(Widget child) {
  return FutureBuilder(
    future: getIt.allReady(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        return child;
      } else {
        return CircularProgressIndicator();
      }
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 210, 217, 237),
          onPrimary: Color.fromARGB(255, 39, 47, 73),
          secondary: Colors.indigo[200]!,
          onSecondary: Colors.black,
          error: Colors.red[400]!,
          onError: Colors.black,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      home: waitForInit(
        Scaffold(
          body: const KnowledgeBasePage(),
        ),
      ),
    );
  }
}
