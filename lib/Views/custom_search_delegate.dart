import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Get the search query
    final trimmedQuery = query.trim();

    // Search the Firestore database for a name that matches the query
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('toys')
          .where('name', isEqualTo: trimmedQuery)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text("Nothing Found"),
          );
        }

        final results = snapshot.data!.docs;

        // TODO: Return the search results in a suitable format (e.g. a list view)
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Get the search query
    final trimmedQuery = query.trim();

    // Search the Firestore database for names that contain the query
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('toys')
          .where('name', isGreaterThanOrEqualTo: trimmedQuery)
          .where('name', isLessThan: trimmedQuery + 'z')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text("An error occured"),
          );
        }

        final results = snapshot.data!.docs;

        // TODO: Return the search results in a suitable format (e.g. a list view)
      },
    );
  }
}
