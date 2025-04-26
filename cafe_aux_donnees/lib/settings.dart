import 'package:flutter/material.dart';
import 'package:cafe_aux_donnees/globals.dart' as globals;

class SettingsUI extends StatefulWidget {
  const SettingsUI({ super.key });

  @override
  State<SettingsUI> createState() => _SettingsUIState();
}

class _SettingsUIState extends State<SettingsUI> {
  String getUserName() {
    if (globals.userObject != null) {
      return globals.userObject['name'];
    }
    return "ZZ";
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: Text(getUserName())
      );
  }
}