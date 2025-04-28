import 'package:flutter/material.dart';
import 'package:cafe_aux_donnees/globals.dart' as globals;

// ignore: must_be_immutable
class YellowBird extends StatefulWidget {
  String message;
  bool error;
  dynamic onPressed = () {};
  YellowBird({super.key, required this.message, this.error = false, this.onPressed, });

  @override
  State<YellowBird> createState() => _YellowBirdState();
}

class _YellowBirdState extends State<YellowBird> {

  Column errorColumn() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          child: const Icon(Icons.error_outline, color: Colors.white, size: 30),
        ),
        Text(
          widget.message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        Spacer(),
        Align(
          alignment: Alignment.bottomCenter,
          child: TextButton(
            onPressed: () {
              setState(() {
                globals.showPopup = false;
              });
            },
            child: const Text("Close"),
          ),
        ),
      ],
    );
  }

  Column saveColumn() {
     return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
          child: const Icon(Icons.check, color: Colors.white, size: 30),
        ),
        Text(
          widget.message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        Spacer(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.onPressed();
                    globals.showPopup = false;
                  });
                },
                child: const Text("Save"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    globals.showPopup = false;
                  });
                },
                child: const Text("Close"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return globals.showPopup && globals.pageLoaded > 0
        ? Container(
          color: const Color(0xB33d3d3d),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                color: Colors.white,
                height: 220,
                width: 300,
                child: widget.error ? errorColumn() : saveColumn(),
              ),
            ),
          ),
        )
        : Container();
  }
}
