import 'package:cafe_aux_donnees/bottom_nav_bar.dart';
import 'package:cafe_aux_donnees/daily_revenue.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Café aux Données',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Widget> pages = [
  Container(color: Colors.red,),
  DailyRevenue(),
  Container(color: Colors.blue,),
];

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[selectedIndex],
      extendBody: true,
      bottomNavigationBar: BottomNavBar(selectedIndex: selectedIndex, onTap: _onItemTapped,),
    );
  }
}
