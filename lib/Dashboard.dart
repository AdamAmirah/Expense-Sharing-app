// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/DatabaseManager/DatabaseManager.dart';
import 'package:project/DatabaseManager/ExpensesManager.dart';
import 'package:project/Services/AuthServices.dart';
import 'package:project/AddExpenseScreen.dart';
import 'package:project/widgets/Loading.dart';
import 'package:http/http.dart';
import 'package:project/ExpenseDetails.dart';
import 'package:project/ListFriends.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

String quote = "";

class _DashboardScreenState extends State<DashboardScreen> {
  Future<void> getQuote() async {
    //make request
    try {
      Response response =
          await get(Uri.parse('https://ancient-bastion-99124.herokuapp.com/'));
      // Future.delayed(const Duration(seconds: 20), () {
      setState(() {
        quote = response.body.toString();

        // });
      });
    } catch (e) {
      print('caught error: $e');
    }
  }

  final AuthServices _auth = AuthServices();
  final String postsURL = "https://ancient-bastion-99124.herokuapp.com/";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _scoreController = TextEditingController();

  List userProfilesList = [];
  List expensesList = [];

  String userID = "";
  String userEmail = "";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getQuote();
    fetchUserInfo();
    fetchDatabaseList();
  }

  fetchUserInfo() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    userID = getUser != null ? getUser.uid : "";
    userEmail = getUser!.email!;
  }

  fetchDatabaseList() async {
    setState(() {
      loading = true;
    });
    dynamic resultant = await DatabaseManager().getUsersList();
    dynamic list = await ExpensesManager().getExpenseList();
    dynamic expenseResult = <Map>[];

    if (resultant == null) {
      setState(() {
        loading = false;
      });
      print('Unable to retrieve');
    } else {
      setState(() {
        loading = false;
        userProfilesList = resultant;
      });
    }

    if (expensesList == null) {
      print('Unable to retrieve');
    } else {
      for (var i = 0; i < list.length; i++) {
        if (list[i]["ownerID"] == userID) {
          expenseResult.add(list[i]);
        }
        for (var j = 0; j < list[i]["friends"].length; j++) {
          if (list[i]["friends"][j]["email"] == userEmail) {
            expenseResult.add({
              'ownerID': list[i]["ownerID"],
              'ownerEmail': list[i]["ownerEmail"],
              'title': list[i]["title"],
              'amount': list[i]["friends"][j]["amount"],
              'friends': list[i]["friends"],
            });
          }
        }
      }
      setState(() {
        expensesList = expenseResult ?? [];
      });
    }
  }

  updateData(String name, String gender, int score, String userID) async {
    await DatabaseManager().updateUserList(name, gender, score, userID);
    fetchDatabaseList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            FlatButton(
              onPressed: () async {
                await _auth.signOut().then((result) {
                  Navigator.of(context).pop(true);
                });
              },
              child: const Icon(
                Icons.exit_to_app,
                color: Color(0xff03CB9D),
              ),
              color: Colors.white,
            )
          ],
          bottom: PreferredSize(
            child: Container(
              color: const Color(0xff03CB9D),
              height: 6.0,
            ),
            preferredSize: const Size.fromHeight(4.0),
          ),
          title: const Text(
            'Expenses',
            style: TextStyle(
              color: Color(0xff333333),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: loading
            ? Loading()
            : Column(children: <Widget>[
                const SizedBox(height: 20),
                Container(
                    height: 90,
                    alignment: Alignment.center,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white, width: 5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              'Tip of the day : $quote',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Rubik',
                              ),
                            ),
                          ),
                        ))),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => ListFriends()),
                          );
                          setState(() {
                            fetchDatabaseList();
                          });
                        },
                        label: const Text(
                          'Friends',
                          style:
                              TextStyle(fontSize: 20, color: Color(0xff03CB9D)),
                        ),
                        icon: const Icon(Icons.person,
                            size: 30, color: Color(0xff03CB9D)),
                      ),
                      const SizedBox(width: 50),
                      FlatButton.icon(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => AddExpenseScreen()),
                          );
                          setState(() {
                            fetchDatabaseList();
                          });
                        },
                        label: const Text(
                          'Add Expense',
                          style:
                              TextStyle(fontSize: 20, color: Color(0xff03CB9D)),
                        ),
                        icon: const Icon(Icons.add, color: Color(0xff03CB9D)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: expensesList.length,
                  physics: const AlwaysScrollableScrollPhysics(), // new
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: SizedBox(
                            height: 230,
                            width: 600,
                            child: Card(
                              color: const Color(0xffFEFEFE),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.grey, width: 0.1),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        expensesList[index]['title'],
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[800]),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      expensesList[index]['ownerEmail'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'RM${expensesList[index]['amount']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.green[900],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Center(
                                      child: FlatButton.icon(
                                        height: 50,
                                        minWidth: 120,
                                        onPressed: () async {
                                          await Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                fullscreenDialog: true,
                                                builder: (context) =>
                                                    Expense_details(
                                                        text:
                                                            expensesList[index],
                                                        index: index)),
                                          );
                                          setState(() {
                                            fetchDatabaseList();
                                          });
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: const Color(0xff03CB9D),
                                        label: const Text(
                                          "Expense Details",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        icon: const Icon(Icons.list,
                                            color: Color(0xff333333)),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ));
                  },
                ))
              ]));
  }
}
