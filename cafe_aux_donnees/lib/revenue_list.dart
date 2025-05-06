import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RevenueList extends StatefulWidget {
  const RevenueList({super.key});

  @override
  State<RevenueList> createState() => _RevenueListState();
}

List<String> entries = <String>[];
List<String> dates = <String>[];
List<String> emplois = <String>[];
List<String> orderVal = <String>[];
List<String> hours = <String>[];
List<String> customers = <String>[];
List<String> marketSpend = <String>[];
List<String> footTraffic = <String>[];

List<IconData> icons = [Icons.group_outlined, Icons.sell_outlined, Icons.access_time_outlined, Icons.badge_outlined, Icons.attach_money_outlined, Icons.signpost_outlined]; //avg_or_val
Color coffee = Color(0xFF9D5624);
dynamic db = FirebaseFirestore.instance;

class _RevenueListState extends State<RevenueList> {
  Future<void> usePreviousData() async {
    List<String> thisEntries = <String>[];
    List<String> thisDates = <String>[];
    List<String> thisEmplois = <String>[];
    List<String> thisOrderVal = <String>[];
    List<String> thisHours = <String>[];
    List<String> thisCust = <String>[];
    List<String> thisMarkSpe = <String>[];
    List<String> thisFoot = <String>[];

    await db.collection("default_values").orderBy("date", descending: true).get().then((event) {
      print("Generating list. STarting Doc ID: ${event.docs[0].id}");
      for (var doc in event.docs) {
        thisEntries.add(doc["daily_rev"].toStringAsFixed(2));
        thisEmplois.add(doc["num_of_emploi"].toString());
        thisOrderVal.add(doc["avg_or_val"].toStringAsFixed(2));
        thisHours.add(doc["op_hours"].toString());
        thisCust.add(doc["num_of_cust"].toString());
        thisMarkSpe.add(doc["market_spend"].toStringAsFixed(2));
        thisFoot.add(doc["loc_foot_traffic"].toString());

        dynamic tempVar = doc.data()["date"].toDate();
        thisDates.add(
          "${DateFormat.yMMMd().format(tempVar)} ${DateFormat.Hm().format(tempVar)}",
        );
      }
      setState(() {
        entries = thisEntries;
        dates = thisDates;
        emplois = thisEmplois;
        orderVal = thisOrderVal;
        hours = thisHours;
        customers = thisCust;
        marketSpend = thisMarkSpe;
        footTraffic = thisFoot;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    usePreviousData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 60, bottom: 95),
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 150,
            child: CListItem(index: index),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}

class CListItem extends StatelessWidget {
  final dynamic index;

  const CListItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Daily Revenue:",
                style: TextStyle(
                  color: Color(0xFF6F4F36),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '\$${entries[index]}',
                style: TextStyle(
                  color: Color(0xFF6F4F36),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            alignment: Alignment.centerLeft,
            child: Text(dates[index]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconTextList(icon: 0, text: customers[index]),
              IconTextList(icon: 1, text: orderVal[index]),
              IconTextList(icon: 2, text: hours[index]),
              IconTextList(icon: 3, text: emplois[index]),
            ]
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconTextList(icon: 4, text: marketSpend[index]),
                IconTextList(icon: 5, text: footTraffic[index]),
              ]
            ),
          )
        ],
      ),
    );
  }
}

class IconTextList extends StatelessWidget {
  final int icon;
  final String text;

  const IconTextList({ super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(children: [
        Icon(icons[icon]),
        Text(": $text")
      ]),
    );
  }
}