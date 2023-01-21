import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:toy_checkout/models/toy.dart';

Future<Widget> buildToyDetailPage(
    BuildContext context, DocumentSnapshot toy) async {
  final id = toy.get('id');
  final name = toy.get('name');
  final imageUrl = toy.get('imageUrl');
  final lastCheckedOut = toy.get('lastCheckedOut');
  final isCheckedOut = toy.get('checkedOut');
  final checkedOutBy = toy.get('checkedOutBy');

  final toyObj = Toy(
    id: id as int,
    name: name as String,
    imageUrl: imageUrl as String,
    lastCheckedOut: lastCheckedOut as Timestamp,
    isCheckedOut: isCheckedOut as bool,
    checkedOutBy: checkedOutBy as String,
  );
  return ToyDetailPage(toy: toyObj);
}

class ToyDetailPage extends StatelessWidget {
  final Toy toy;

  ToyDetailPage({required this.toy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toy Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: toy.imageUrl.isEmpty
                      ? AssetImage('assets/images/default_toy_icon.png')
                          as ImageProvider
                      : NetworkImage(toy.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              toy.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Time since last checkout: ${formatTimestamp(toy.lastCheckedOut)}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              toy.isCheckedOut
                  ? 'Currently checked out by ${toy.checkedOutBy}'
                  : 'Not currently checked out',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatTimestamp(Timestamp timestamp) {
  if (timestamp == null) {
    return 'Never';
  }

  DateTime date = timestamp.toDate();
  return timeago.format(date);
}
