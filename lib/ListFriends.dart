// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:project/Services/AuthServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/DatabaseManager/FriendsManager.dart';
import 'package:project/DatabaseManager/DatabaseManager.dart';
import 'package:project/AddFriend.dart';

class ListFriends extends StatefulWidget {
  @override
  _ListFriends createState() => _ListFriends();
}

class _ListFriends extends State<ListFriends> {
  List friendsList = [];

  String userID = "";
  String userEmail = "";
  bool loading = false;

  @override
  void initState() {
    super.initState();
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
    dynamic result = await FriendsManager().getFriendsList(userEmail);

    if (result == null) {
      setState(() {
        loading = false;
      });
      print('Unable to retrieve');
    } else {
      print(result[0]["friends"]);
      setState(() {
        loading = false;
        friendsList = result[0]["friends"];
      });
    }
  }

  final _key = GlobalKey<FormState>();
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
            "Friends",
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
        body: Column(children: <Widget>[
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: Text(
              'My Friends List',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontFamily: 'Rubik',
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(height: 50),
          Expanded(
              child: ListView.builder(
            itemCount: friendsList.length,
            physics: const AlwaysScrollableScrollPhysics(), // new
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      height: 120,
                      width: 600,
                      child: Card(
                        color: const Color(0xffFEFEFE),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.grey, width: 0.1),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  friendsList[index]["name"],
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800]),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                friendsList[index]["email"],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
            },
          )),
          new Container(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFriendScreen()),
                );
                fetchDatabaseList();
              },
              child: const Icon(Icons.add),
              backgroundColor: const Color(0xff03CB9D),
              tooltip: 'Add Friend',
            ),
          )
        ]));
  }
}
