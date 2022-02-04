// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:project/Services/AuthServices.dart';
import 'package:project/widgets/Loading.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _key = GlobalKey<FormState>();

  final AuthServices _auth = AuthServices();
  bool loading = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Loading()
          : Container(
              height: 700,
              color: Colors.white,
              child: Center(
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Color(0xff03CB9D),
                            fontWeight: FontWeight.w700,
                            fontSize: 50),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Name cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: 'Name',
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.black),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.black),
                                  ),
                                  labelStyle:
                                      const TextStyle(color: Colors.grey)),
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _emailContoller,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Email cannot be empty';
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.black),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.black),
                                  ),
                                  labelStyle:
                                      const TextStyle(color: Colors.grey)),
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Password cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.black),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.grey),
                                  ),
                                  labelStyle:
                                      const TextStyle(color: Colors.grey)),
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FlatButton(
                                  minWidth: 120.0,
                                  height: 50.0,
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  onPressed: () {
                                    if (_key.currentState!.validate()) {
                                      createUser();
                                    }
                                  },
                                  color: const Color(0xff03CB9D),
                                ),
                                FlatButton(
                                  minWidth: 120.0,
                                  height: 50.0,
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: const Color(0xff03CB9D),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void createUser() async {
    setState(() {
      loading = true;
    });
    dynamic result = await _auth.createNewUser(
        _nameController.text, _emailContoller.text, _passwordController.text);

    if (result == null) {
      setState(() {
        loading = false;
      });
      print('Email is not valid');
    } else {
      setState(() {
        loading = false;
      });
      print(result.toString());
      _nameController.clear();
      _passwordController.clear();
      _emailContoller.clear();
      Navigator.pop(context);
    }
  }
}
