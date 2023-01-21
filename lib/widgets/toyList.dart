import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:toy_checkout/Views/ToyDetailPage.dart';

Widget buildToyList(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (!snapshot.hasData) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  final toys = snapshot.data!.docs;
  List<Widget> toyList = [];

  for (var toy in toys) {
    final toyName = toy.get('name') ?? '';
    final toyImageUrl =
        toy.data().toString().contains('imageUrl') ? toy.get('imageUrl') : '';
    final toyLastCheckedOut = toy.get('lastCheckedOut') ??
        Timestamp.fromMicrosecondsSinceEpoch(-3153600000) as Timestamp;

    final toyWidget = Container(
      height: 80,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ClipOval(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: toyImageUrl.isEmpty
                        ? AssetImage('assets/images/default_toy_icon.png')
                            as ImageProvider
                        : AssetImage(toyImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toyName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Last checked out: ${formatTimestamp(toyLastCheckedOut)}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    toyList.add(
      InkWell(
        onTap: () async {
          final data = snapshot.data;
          final toyDetailPage = await buildToyDetailPage(context, toy);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => toyDetailPage,
            ),
          );
        },
        child: toyWidget,
      ),
    );
  }

  return ListView(
    children: toyList,
  );
}

String formatTimestamp(Timestamp timestamp) {
  final defaultTime = Timestamp.fromMillisecondsSinceEpoch(-3153600000);
  print(defaultTime);
  if (timestamp == defaultTime) {
    return 'Never';
  }

  DateTime date = timestamp.toDate();
  return timeago.format(date);
}
