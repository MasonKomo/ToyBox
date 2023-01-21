import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';

// My files
import 'package:toy_checkout/widgets/toyList.dart';

import 'Views/custom_search_delegate.dart';

double screenWidth = 0.0;
double screenHeight = 0.0;

final Color _accentColor = const Color(0xFF272727);
final Color _containerColor = const Color(0xFFF0F2F5);

bool selected = false;
RangeValues _currentRangedValue = const RangeValues(0, 14);
List<String> _values = [
  'PK',
  'K',
  '1st',
  '2nd',
  '3rd',
  '4th',
  '5th',
  '6th',
  '7th',
  '8th',
  '9th',
  '10th',
  '11th',
  '12th'
];

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(color: Color.fromARGB(255, 79, 79, 79));
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Toys',
      style: optionStyle,
    ),
    Text(
      'Index 1: Search',
      style: optionStyle,
    ),
    Text(
      'Index 2: Add Toys',
      style: optionStyle,
    ),
    Text(
      'Index 3: Database',
      style: optionStyle,
    ),
    Text(
      'Index 4: Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 2) {
        // Show the bottom sheet when the Add Toys tab is selected
        showFilterBottomSheet(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Toybox 🧸'),
        actions: [
          IconButton(
              icon:
                  const Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              })
        ],
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('toys').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildToyList(context, snapshot);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.toys),
            label: "Toys",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add Toys",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: "Database",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Color.fromARGB(255, 94, 94, 94),
        onTap: _onItemTapped,
      ),
    );
  }
}

// Add toy bottom sheet
showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      builder: (context) {
        final _firestore = FirebaseFirestore.instance;
        String _toyName = '';
        int _toyQuantity = 0;
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Container(
            width: screenWidth,
            height: screenHeight,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 70.0,
                      height: 5.0,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          color: _accentColor),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "Add a toy",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Toy Name',
                        ),
                        onChanged: (value) => _toyName = value,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _toyQuantity = int.parse(value),
                      ),
                      OutlinedButton(
                        child: Text('Take Photo'),
                        onPressed: () async {
                          // Use the `ImagePicker` package to open the camera
                          final ImagePicker _picker = ImagePicker();

                          var image = await _picker.pickImage(
                              source: ImageSource.camera);

                          // Do something with the image, such as displaying it or uploading it to the database
                        },
                      ),
                      OutlinedButton(
                        child: Text('Choose from Gallery'),
                        onPressed: () async {
                          // Use the `ImagePicker` package to open the gallery
                          final ImagePicker _picker = ImagePicker();

                          var image = await _picker.pickImage(
                              source: ImageSource.gallery);

                          // Do something with the image, such as displaying it or uploading it to the database
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  OutlinedButton(
                    child: Text('Add Toy'),
                    onPressed: () async {
                      final newId =
                          await _firestore.runTransaction((transaction) async {
                        final highestIdQuery = await _firestore
                            .collection('toys')
                            .orderBy('id', descending: true)
                            .limit(1)
                            .get();
                        final highestId = highestIdQuery.docs.first['id'];
                        return highestId + 1;
                      });

                      final secondsSinceEpoch =
                          -3153600000; // 100 years in seconds
                      final defaultTime = Timestamp.fromMillisecondsSinceEpoch(
                          secondsSinceEpoch * 1000);
                      print(defaultTime);
                      // Add a new toy to the database with the given name and quantity
                      await _firestore.collection('toys').add({
                        'name': _toyName,
                        'quantity': _toyQuantity,
                        'checkedOut': false,
                        'id': newId,
                        'checkedOutBy': "",
                        'imageUrl': "",
                        'lastCheckedOut': defaultTime,
                      });

                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  const SizedBox(
                    height: 0.0,
                  ),
                ],
              ),
            ),
          );
        });
      });
}
