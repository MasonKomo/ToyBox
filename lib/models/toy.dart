import 'package:cloud_firestore/cloud_firestore.dart';

class Toy {
  final int id;
  final String name;
  final String imageUrl;
  final Timestamp lastCheckedOut;
  final bool isCheckedOut;
  final String checkedOutBy;

  Toy({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.lastCheckedOut,
    required this.isCheckedOut,
    required this.checkedOutBy,
  });

  get checkedOut => null;
}
