import 'package:cafe_aux_donnees/Backend_bloc.dart';
import 'package:cafe_aux_donnees/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cafe_aux_donnees/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

List controllers = [];

class DailyRevenue extends StatefulWidget {
  final dynamic backendBloc;
  const DailyRevenue({super.key, required this.backendBloc});

  @override
  State<DailyRevenue> createState() => _DailyRevenueState();
}

class _DailyRevenueState extends State<DailyRevenue> {
  String dialyRevenue = "0.00";
  String dateTime = "-"; //"3/7/25 4:25 PM";
  final Color _color = Color(0xFF9D5624);
  dynamic db = FirebaseFirestore.instance;
  String docID = "";
  String date1 = "";
  bool runOnce = true;

  Future<void> usePreviousData() async {
    if (controllers.isNotEmpty) {
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
    for (var cont in controllers) {
      cont.clear();
    }
  }

  String retValforPrice() {
    if (runOnce) getLastPrice();
    return dialyRevenue;
  }

  void saveData() {
    final dataRef = db.collection("default_values").doc(docID);
    final timeRightNow = DateTime.now();
    final date2 = DateFormat.yMMMd().format(timeRightNow);
    final data = {
      "num_of_cust": int.parse(controllers[0].text),
      "avg_or_val": double.parse(controllers[1].text),
      "op_hours": int.parse(controllers[2].text),
      "num_of_emploi": int.parse(controllers[3].text),
      "market_spend": double.parse(controllers[4].text),
      "loc_foot_traffic": int.parse(controllers[5].text),
      "daily_rev": double.parse(globals.dailyRev),
      "date": Timestamp.now(),
    };

    widget.backendBloc.postData();
    if (date1 == date2) {
      dataRef
          .update(data)
          .then(
            (value) => print("DocumentSnapshot successfully updated!"),
            onError: (e) => print("Error updating document $e"),
          );
    } else {
      db
          .collection("default_values")
          .add(data)
          .then(
            (documentSnapshot) =>
                print("Added Data with ID: ${documentSnapshot.id}"),
          );
    }
  }

  Future<void> getLastPrice() async {
    dynamic db = FirebaseFirestore.instance;
    await db.collection("default_values").orderBy("date", descending: true).limit(1).get().then((event) {
      var doc = event.docs[0];
      if (doc != null && doc.data() != null) {
        print("Doc ID: ${doc.id}");
        docID = doc.id;
        setState(() {
          dialyRevenue = doc.data()["daily_rev"].toStringAsFixed(2);
          dynamic tempVar = doc.data()["date"].toDate();
          dateTime =
              "${DateFormat.yMMMd().format(tempVar)} ${DateFormat.Hm().format(tempVar)}";
          date1 = DateFormat.yMMMd().format(tempVar);
        });
      }
    });
    runOnce = false;
  }

  String getPriceText(state) {
    if (state.isEmpty) {
      return "\$${retValforPrice()}";
    } else if (state == "error") {
      return "\$0.00";
    }
    globals.dailyRev = state.substring(0, state.length - 1);
    return "\$${double.parse(state.substring(0, state.length - 1)).toStringAsFixed(2)}";
  }

  void saveControllerData() {
    globals.data.clear();
    for (var cont in controllers) {
      globals.data.add(cont.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
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
                          getPriceText(state),
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
                                      colors: <Color>[
                                        Color(0xff9D5624),
                                        Color(0xff38271C),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                      colors: <Color>[
                                        Color(0xff9D5624),
                                        Color(0xff38271C),
                                      ],
                                    ),
                                  ),
                                  child: Ink(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
              Padding(padding: const EdgeInsets.only(top: 20)),
              SizedBox(
                height: 350,
                child: Scrollbar(
                  thumbVisibility: true,
                  //isAlwaysShown: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        AlignTextFields(index: 0),
                        AlignTextFields(index: 1),
                        AlignTextFields(index: 2),
                        AlignTextFields(index: 3),
                        AlignTextFields(index: 4),
                        AlignTextFields(index: 5),
                        Padding(padding: EdgeInsets.only(bottom: 40)),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  saveControllerData();
                  widget.backendBloc.fetchData();
                  setState(() {
                    globals.showPopup = true;
                    globals.pageLoaded++;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 40),
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
            ],
          ),
        ),
        BlocBuilder<BackendBloc, String>(
          builder: (context, state) {
            String thisMessage;
            if (state == "error") {
              thisMessage =
                  "There was an error while fetching data from the backend. Please try again later.";
              return YellowBird(message: thisMessage, error: true);
            }
            thisMessage =
                "Data fetched successfully!\nIf you want save the data, please click save. Otherwise, data will be lost.";
            return YellowBird(
              message: thisMessage,
              onPressed: () => saveData(),
            );
          },
        ),
      ],
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
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    controllers.clear();
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
