// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/DatabaseManager/FriendsManager.dart';
import 'package:project/DatabaseManager/ExpensesManager.dart';
import 'package:project/widgets/Loading.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _key = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  List friendsList = [];

  String userEmail = "";
  String userID = "";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchDatabaseList();
  }

  fetchUserInfo() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    userEmail = getUser!.email!;
    userID = getUser != null ? getUser.uid : "";
  }

  fetchDatabaseList() async {
    setState(() => loading = true);

    dynamic resultant = await FriendsManager().getFriendsList(userEmail);
    if (resultant == null) {
      setState(() => loading = false);

      print('Unable to retrieve');
    } else {
      setState(() {
        print(resultant);
        loading = false;
        for (var i = 0; i < resultant.length; i++) {
          if (resultant[i]['userId'] == userEmail) {
            friendsList = resultant[i]["friends"];
            break;
          }
        }
      });
    }
  }

  Map<int, bool> selectedFlag = {};
  bool isSelectionMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        bottom: PreferredSize(
          child: Container(
            color: const Color(0xff03CB9D),
            height: 6.0,
          ),
          preferredSize: const Size.fromHeight(4.0),
        ),
        title: const Text(
          "New Expense",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: 700,
        color: Colors.white,
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                'What bill you want to divide ?',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rubik',
                  fontSize: 25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Title cannot be empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(width: 5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xff03CB9D)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2.0, color: Colors.grey),
                          ),
                          labelText: 'Title',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          )),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _amountController,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'amount cannot be empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(width: 5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xff03CB9D)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2.0, color: Colors.grey),
                          ),
                          labelText: 'Amount',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          )),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 30),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: friendsList.length,
                      itemBuilder: (builder, index) {
                        Map data = friendsList[index];

                        selectedFlag[index] = selectedFlag[index] ?? false;
                        bool? isSelected = selectedFlag[index];
                        return loading
                            ? Loading()
                            : ListTile(
                                onLongPress: () =>
                                    onLongPress(isSelected!, index),
                                onTap: () => onTap(isSelected!, index),
                                title: Text("${data['name']}",
                                    style:
                                        const TextStyle(color: Colors.black)),
                                subtitle: Text("${data['email']}",
                                    style:
                                        const TextStyle(color: Colors.black)),
                                leading: _buildSelectIcon(
                                    isSelected!, data), // updated
                              );
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(height: 30),
                        FlatButton(
                          minWidth: 120.0,
                          height: 50.0,
                          child: const Text('Add',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              addExpense();
                            }
                          },
                          color: Color(0xff03CB9D),
                        ),
                        FlatButton(
                          minWidth: 120.0,
                          height: 50.0,
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: const Color(0xff03CB9D),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      // If there will be any true in the selectionFlag then
      // selection Mode will be true
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }

  Widget _buildSelectIcon(bool isSelected, Map data) {
    if (isSelectionMode) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Color(0xff03CB9D),
      );
    } else {
      return const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add_circle,
            color: Color(0xff03CB9D),
          ));
    }
  }

  void onTap(bool isSelected, int index) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    } else {
      // Open Detail Page
    }
  }

  void addExpense() async {
    var includedFriends = <Map>[];
    var counter = 0;
    for (var i = 0; i < selectedFlag.length; i++) {
      if (selectedFlag[i] ?? false) {
        counter++;
      }
    }

    for (var i = 0; i < friendsList.length; i++) {
      if (selectedFlag[i] ?? false) {
        includedFriends.add({
          "name": friendsList[i]["name"],
          "email": friendsList[i]["email"],
          "amount": double.parse(_amountController.text) / counter
        });
      }
    }

    await ExpensesManager().addExpense(userID, userEmail, _titleController.text,
        double.parse(_amountController.text), includedFriends);

    _titleController.clear();
    _amountController.clear();
    Navigator.pop(context);
  }
}
