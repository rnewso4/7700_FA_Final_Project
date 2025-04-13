import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatefulWidget {
  int selectedIndex;
  Function(int) onTap;
  BottomNavBar({ super.key, required this.selectedIndex, required this.onTap });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  double getSize(index) {
    if (widget.selectedIndex == index) {
      return 35;
    } else {
      return 20;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(                                                
        borderRadius: BorderRadius.only(                                           
        topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        boxShadow: [                                                               
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),       
        ],                                                                         
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(                                           
        topLeft: Radius.circular(30.0),                                            
        topRight: Radius.circular(30.0),
        ),        
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.dashboard, size: getSize(0)), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: getSize(1), fill: 1,), label: 'Business'),
            BottomNavigationBarItem(icon: Icon(Icons.settings, size: getSize(2)), label: 'School'),
          ],
          currentIndex: widget.selectedIndex,
          selectedItemColor: Color(0xFF9D5624),
          onTap: widget.onTap,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}