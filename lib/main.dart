import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ChatApp/screens/chat_screen.dart';
import 'package:firebase_ChatApp/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Screen',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          backgroundColor: Colors.pink,
          accentColor: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)))),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
              return ChatScreen();
            }
            return LoginPage();
          }),
    );
  }
}
