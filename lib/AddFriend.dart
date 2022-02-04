import 'package:flutter/material.dart';
import 'package:project/DatabaseManager/FriendsManager.dart';
import 'package:project/Services/AuthServices.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddFriendScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddFriendScreen> {
  final _key = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Map<int, bool> selectedFlag = {};

  String userEmail = "";
  String userID = "";

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  fetchUserInfo() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    userEmail = getUser!.email!;
    userID = getUser != null ? getUser.uid : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          child: Container(
            color: const Color(0xff03CB9D),
            height: 6.0,
          ),
          preferredSize: const Size.fromHeight(4.0),
        ),
        title: const Text(
          "Add Friend",
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
        height: 500,
        color: Colors.white,
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Enter Friend's Details",
                style: TextStyle(
                  color: Color(0xff222222),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rubik',
                  fontSize: 32,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
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
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(width: 5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3.0, color: Color(0xff03da9d)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3.0, color: Colors.grey),
                          ),
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          )),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Email input cannot be empty';
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
                                width: 3.0, color: Color(0xff03da9d)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3.0, color: Colors.grey),
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          )),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 24.9),
                    const SizedBox(height: 24.9),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(height: 24.9),
                        FlatButton.icon(
                          height: 50,
                          minWidth: 120,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: const Color(0xff03da9d),
                          label: const Text(
                            "Back",
                            style: TextStyle(
                                fontFamily: 'Rubik', color: Colors.white),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_left,
                              color: Color(0xff222222)),
                        ),
                        FlatButton.icon(
                          height: 50,
                          minWidth: 120,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              addFriend();
                            }
                          },
                          color: const Color(0xff03da9d),
                          label: const Text(
                            "Add",
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              color: Colors.white,
                            ),
                          ),
                          icon: const Icon(Icons.add, color: Color(0xff222222)),
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
    );
  }

  void addFriend() async {
    dynamic result = await FriendsManager().getFriendsList(userEmail);
    if (result.length != 0) {
      result[0]["friends"]
          .add({"name": _nameController.text, "email": _emailController.text});
      await FriendsManager().addFriend(userID, userEmail, result[0]);
    } else {
      await FriendsManager().addFriend(userID, userEmail, [
        {"name": _nameController.text, "email": _emailController.text}
      ]);
    }

    _nameController.clear();
    _emailController.clear();
    Navigator.pop(context);
  }
}
