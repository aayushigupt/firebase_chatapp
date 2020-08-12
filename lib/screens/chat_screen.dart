import 'package:firebase_ChatApp/widgets/chat/messages.dart';
import 'package:firebase_ChatApp/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Section"),
        actions: <Widget>[
          DropdownButton(
            icon: Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Logout"),
                    ],
                  ),
                ),
                value: "Logout",
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == "Logout") {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(child: Column(
        children: <Widget>[
          Expanded(child: Messages()),
          NewMessage(),
        ],
      )),
      
    );
  }
}
