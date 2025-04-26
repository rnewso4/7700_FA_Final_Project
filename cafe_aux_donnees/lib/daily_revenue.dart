import 'package:cafe_aux_donnees/Backend_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cafe_aux_donnees/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List controllers = [];

class DailyRevenue extends StatefulWidget {
  final dynamic backendBloc;
  const DailyRevenue({super.key, required this.backendBloc});

  @override
  State<DailyRevenue> createState() => _DailyRevenueState();
}

class _DailyRevenueState extends State<DailyRevenue> {
  String dialyRevenue = "0.00";
  String dateTime = "3/7/25 4:25 PM";
  Color _color = Colors.teal;

  Future<void> usePreviousData() async {
    if (_color != Colors.teal) {
      setState(() {
        _color = Colors.teal;
      });
    }

    if (controllers.isNotEmpty) {
      dynamic db = FirebaseFirestore.instance;
      await db.collection("default_values").get().then((event) {
        var doc = event.docs[0];
        var fieldNames = globals.firebaseFieldNamesForXValues;
        if (doc != null && doc.data() != null) {
          for (int i = 0; i < controllers.length; i++) {
            controllers[i].text = doc.data()[fieldNames[i]].toString();
          }
        }
      });
    }
  }

  void clearAllFields() {
    if (_color != Color(0xFF9D5624)) {
      setState(() {
        _color = Color(0xFF9D5624);
      });
    } else {
      setState(() {
        _color = Colors.teal;
      });
    }
    for (var cont in controllers) {
      cont.clear();
    }
  }

  String retValforPrice() {
    getLastPrice();
    return dialyRevenue;
  }

  Future<void> getLastPrice() async {
    dynamic db = FirebaseFirestore.instance;
    await db.collection("default_values").get().then((event) {
      var doc = event.docs[0];
      if (doc != null && doc.data() != null) {
        setState(() {
          dialyRevenue = doc.data()["daily_rev"].toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Previously calculated daily revenue",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                wordSpacing: 1.5,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BlocBuilder<BackendBloc, String>(
                    builder: (context, state) {
                      return Text(
                        state.isEmpty ? "\$${retValforPrice()}" : "\$${state.substring(0, state.length - 1)}",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                          color: _color,
                          height: 1.0,
                        ),
                      );
                    },
                  ),
                  Text(dateTime),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 84,
                  width: 306,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: GestureDetector(
                              onTap: usePreviousData,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment(5, 1.5),
                                    colors: <Color>[Color(0xff9D5624), Color(0xff38271C)],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.download,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    Text(
                                      "Use previous data",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: InkWell(
                              onTap: clearAllFields,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(-2, -1),
                                    end: Alignment.bottomRight,
                                    colors: <Color>[Color(0xff9D5624), Color(0xff38271C)],
                                  ),
                                ),
                                child: Ink(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      Text(
                                        "Clear all fields",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        left: 152.5,
                        child: Container(
                          height: 84,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          //color: Colors.purple,
                          alignment: Alignment.bottomRight,
                          child: VerticalDivider(
                            width: 1,
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: AlignTextFields(index: 0),
            ),
            AlignTextFields(index: 1),
            AlignTextFields(index: 2),
            AlignTextFields(index: 3),
            AlignTextFields(index: 4),
            AlignTextFields(index: 5),
            GestureDetector(
              onTap: () {widget.backendBloc.fetchData();},
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 40,
                    width: 205,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(1.2, 1.5),
                        colors: <Color>[Color(0xff9D5624), Color(0xff38271C)],
                      ),
                    ),
                    child: Text(
                      "Generate",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 130)),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AlignTextFields extends StatefulWidget {
  int index;

  AlignTextFields({super.key, required this.index});

  @override
  State<AlignTextFields> createState() => _AlignTextFieldsState();
}

class _AlignTextFieldsState extends State<AlignTextFields> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    controllers.add(_controller);
    //_controller.text = widget.inputText.toString();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        width: 306,
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            label: Text(globals.inputTexts[widget.index]),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
