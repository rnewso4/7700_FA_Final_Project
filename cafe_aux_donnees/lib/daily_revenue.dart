import 'package:flutter/material.dart';

class DailyRevenue extends StatefulWidget {
  const DailyRevenue({ super.key });

  @override
  State<DailyRevenue> createState() => _DailyRevenueState();
}

class _DailyRevenueState extends State<DailyRevenue> {
  String dialyRevenue = "4900.77";
  String dateTime = "3/7/25 4:25 PM";
  Color _color = Colors.limeAccent;

  void onPressed() {
    if (_color == Colors.limeAccent) {
      setState(() {
        _color = Color(0xFF9D5624);
      });
    } else {
      setState(() {
        _color = Colors.limeAccent;
      });
    }
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
                wordSpacing: 1.5
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$$dialyRevenue",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF9D5624),
                      height: 1.0
                    ),
                  ),
                  Text(
                    dateTime
                  )
                ]
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(1.2, 1.5),
                      colors: <Color>[
                        Color(0xff9D5624),
                        Color(0xff38271C),
                      ], 
                    ),
                  ),
                  height: 84,
                  width: 306,
                  child: Stack(
                    children: [
                      Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: onPressed,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.download,
                                  color: Colors.white,
                                  size: 40
                                ),
                                Text(
                                  "Use previous data",
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                  )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: InkWell(
                            onTap: onPressed,
                            child: Ink(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 40
                                  ),
                                  Text(
                                    "Clear all fields",
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                    )
                                ],
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
                            thickness: 2
                          ),
                        ),
                      )
                    ],
                    ),
                  ),
                ),
              ),
              AlignTextFields(text: "Number of customers per day", topMargin: 40,), // 1
              AlignTextFields(text: "Average order value", topMargin: 20), // 2
              AlignTextFields(text: "Operating hours per day", topMargin: 20), // 3
              AlignTextFields(text: "Number of employees", topMargin: 20), // 4
              AlignTextFields(text: "Marketing spend per day", topMargin: 20), // 5
              AlignTextFields(text: "Location foot traffic", topMargin: 20), // 67
              Container(
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
                        colors: <Color>[
                          Color(0xff9D5624),
                          Color(0xff38271C),
                        ], 
                      ),
                    ),
                    child: Text(
                      "Generate",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20
                      )
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 130))
          ]
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AlignTextFields extends StatelessWidget {
  String text;
  double topMargin;

  AlignTextFields({ super.key, required this.text, required this.topMargin });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: topMargin),
        width: 306,
        //height: 50,
        child: TextField(
          decoration: InputDecoration(
            label: Text(text),
            border: OutlineInputBorder()
          ),
        ),
      ),
      );
  }
}