import 'package:firstly/welcome.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';

import 'package:firebase_core/firebase_core.dart';

 void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(MyApp());
}


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // Initialize Firebase
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, Orientation, DeviceType) =>MaterialApp(
         home: welcomeScreen(),
      ),
    );
  }
}
