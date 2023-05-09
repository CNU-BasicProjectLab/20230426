import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modu_tour/data/tour.dart';

class TourDetailPage extends StatefulWidget {
  const TourDetailPage({Key? key, this.id, this.tourData, this.index, this.databaseReference}) : super(key: key);
  final String? id;
  final TourData? tourData;
  final int? index;
  final DatabaseReference? databaseReference;

  @override
  State<TourDetailPage> createState() => _TourDetailPage();
}

class _TourDetailPage extends State<TourDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
           SliverAppBar(expandedHeight: 50,
           flexibleSpace: FlexibleSpaceBar(
             title: Text(
               '${widget.tourData!.title}',
             style: const TextStyle(color: Colors.white, fontSize: 20),
           ),
             centerTitle: true,
             titlePadding: const EdgeInsets.only(top: 10),
           ),
            pinned: true,
            backgroundColor: Colors.deepOrangeAccent,
           ),
          ]
        )
    );
  }
}
