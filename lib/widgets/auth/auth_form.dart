import 'dart:io';

import 'package:firebase_ChatApp/widgets/picker/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool _isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File imageFile,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  AuthForm(this.submitFn, this._isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _form = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  var _isLogin = true;
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    final isValid = _form.currentState.validate();
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Pick an Image')));
    }

    if (isValid) {
      _form.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) 
                  UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter a valid username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return 'Please enter a valid username';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget._isLoading) CircularProgressIndicator(),
                  if (!widget._isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget._isLoading)
                    FlatButton(
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
