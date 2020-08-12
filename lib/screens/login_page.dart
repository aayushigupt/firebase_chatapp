import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ChatApp/widgets/auth/auth_form.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    void _submitAuthForm(
      String email,
      String username,
      String password,
      File image,
      bool isLogin,
      BuildContext ctx,
    ) async {
      AuthResult _authResult;
      try {
        setState(() {
          _isLoading = true;
        });
        if (isLogin) {
          _authResult = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
        } else {
          _authResult = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child(_authResult.user.uid + '.jpg');

          await ref.putFile(image).onComplete;
          final url = await ref.getDownloadURL();

          await Firestore.instance
              .collection("users")
              .document(_authResult.user.uid)
              .setData({
            'username': username,
            'emailId': email,
            'image_url': url,
          });
          
        }
      } on PlatformException catch (error) {
        var message = 'An error occured , please check your credentials!!';
        if (error.message != null) {
          message = error.message;
        }
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        print(err);
        setState(() {
          _isLoading = false;
        });
      }
    }

    // TODO: implement build
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(
          _submitAuthForm,
          _isLoading,
        ));
  }
}
