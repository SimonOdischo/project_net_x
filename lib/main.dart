import 'package:flutter/material.dart';
import 'package:testing/pages/history.dart';
import 'package:testing/pages/map.dart';
import 'package:testing/pages/settings.dart';

//Hauptklasse das Projekt
//startet die Applikation
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool connect = true;
  int _selectedScreenIndex = 0;
  final List _screens = [
    {"screen": const MyMap(), "title": "Karte"},
    {"screen": const History(), "title": "Messverlauf"},
    {"screen": const Settings(), "title": "Einstellungen"}
  ];

  @override
  initState() {
    super.initState();
  }

  Future<void> _selectScreen(int index) async {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_screens[_selectedScreenIndex]["title"]),
      ),
      body: _screens[_selectedScreenIndex]["screen"],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        onTap: _selectScreen,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Karte'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chrome_reader_mode_outlined),
              label: 'Messveraluf'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Einstellungen")
        ],
      ),
    );
  }
}
