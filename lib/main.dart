// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/Services/AuthServices.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/Dashboard.dart';
import 'package:project/RegistrationScreen.dart';
import 'package:project/AddExpenseScreen.dart';

import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final Color primaryColor = Color(0xff03da9d);
  final Color accentColor = Color(0xff333333);
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => const LoginScreen(),
      '/register': (context) => RegistrationScreen(),
      '/dashboard': (context) => DashboardScreen(),
      '/addExpense': (context) => AddExpenseScreen()
    },
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();

  final AuthServices _auth = AuthServices();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    getTime();
    super.initState();
  }

  String greeting = '';
  IconData gIcon = Icons.favorite;
  Color gIconColor = Colors.black;

  Future<void> getTime() async {
    //make request
    bool isDaytime = false;
    String time = '';
    try {
      Response response = await get(
          Uri.parse('https://worldtimeapi.org/api/timezone/asia/kuala_lumpur'));
      Map data = jsonDecode(response.body);

      //get properties of data
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));

      //set the time property
      isDaytime = now.hour > 6 && now.hour < 19 ? true : false;
      setState(() {
        greeting = isDaytime ? 'Good Day!' : 'Good Evening!';
        gIcon = isDaytime ? Icons.light_mode : Icons.dark_mode;
        gIconColor = isDaytime ? Colors.yellow : Colors.black;
      });
      time = DateFormat.jm().format(now);
    } catch (e) {
      print('caught error: $e');
      time = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    getTime();

    return Scaffold(
        body: Container(
            color: Colors.white,
            child: Center(
              child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              gIcon,
                              size: 40,
                              color: gIconColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '$greeting',
                              style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Login',
                        style: TextStyle(
                            color: Color(0xff03CB9D),
                            fontWeight: FontWeight.w700,
                            fontSize: 50),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Emial cannot be empty';
                                } else {
                                  return null;
                                }
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
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  labelText: 'Password',
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
                            const SizedBox(height: 5),
                            FlatButton(
                              child: const Text('Not regisetred? Sign up'),
                              onPressed: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) =>
                                          RegistrationScreen()),
                                );
                              },
                              textColor: const Color(0xff03CB9D),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FlatButton(
                                  minWidth: 120.0,
                                  height: 50.0,
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    if (_key.currentState!.validate()) {
                                      signInUser();
                                    }
                                  },
                                  color: const Color(0xff03CB9D),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            )));
  }

  void signInUser() async {
    dynamic authResult =
        await _auth.loginUser(_emailController.text, _passwordController.text);
    if (authResult == null) {
      print('Sign in error. could not be able to login');
    } else {
      _emailController.clear();
      _passwordController.clear();
      Navigator.pushNamed(context, '/dashboard');
    }
    Navigator.pushNamed(context, '/dashboard');
  }
}
