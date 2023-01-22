import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toy_checkout/firebase_options.dart';
import 'package:toy_checkout/home.dart';
import 'package:toy_checkout/pages/auth_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('-- WidgetsFlutterBinding.ensureInitialized');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('-- main: Firebase.initializeApp');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Toybox🧸',
//       home: MyHome(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Toybox🧸'),
//       ),
//       body: StreamBuilder(
//         stream: _firestore.collection('toys').snapshots(),
//         builder: (context, AsyncSnapshot snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           final toys = snapshot.data!.docs;
//           List<Widget> toyList = [];
//           for (var toy in toys) {
//             final toyName = toy.data['name'];
//             final toyWidget = ListTile(
//               title: Text(toyName),
//             );
//             toyList.add(toyWidget);
//           }
//           return ListView(
//             children: toyList,
//           );
//         },
//       ),
//     );
//   }
}
