import 'package:cafe_aux_donnees/Backend_bloc.dart';
import 'package:cafe_aux_donnees/bottom_nav_bar.dart';
import 'package:cafe_aux_donnees/daily_revenue.dart';
import 'package:cafe_aux_donnees/revenue_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cafe_aux_donnees/globals.dart' as globals;
import 'package:cafe_aux_donnees/settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

dynamic userObject;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BackendBloc>(
          create: (context) => BackendBloc()
        ),
      ],
      child: MyApp()
    )
  );

  // TODO: Remove comment lines when ready
  // dynamic db = FirebaseFirestore.instance;
  // await db.collection("users").get().then((event) {
  // for (var doc in event.docs) {
  //   if (doc.data()['initials'] == "AJ") {
  //     userObject = doc.data();
  //   }
  // }
  // });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Café aux Données',
      home: BlocProvider(create: (context) => BackendBloc(), child:  const MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

dynamic backendBloc;

List<Widget> pages = [
  RevenueList(),
  DailyRevenue(backendBloc: backendBloc),
  SettingsUI()
];

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      globals.userObject ??= userObject;
    });
  }

  @override
  Widget build(BuildContext context) {
    backendBloc = BlocProvider.of<BackendBloc>(context);

    return Scaffold(
      body: pages[selectedIndex],
      extendBody: true,
      bottomNavigationBar: BottomNavBar(selectedIndex: selectedIndex, onTap: _onItemTapped,),
    );
  }
}
