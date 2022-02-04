// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:project/DatabaseManager/ExpensesManager.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Expense_details extends StatefulWidget {
  final dynamic text;
  final dynamic index;

  const Expense_details({Key? key, required this.text, required this.index})
      : super(key: key);

  @override
  _Expense_detailsState createState() => _Expense_detailsState();
}

class _Expense_detailsState extends State<Expense_details> {
  void delete(id) async {
    dynamic result = await ExpensesManager().deleteExpense(id);

    Navigator.pop(context);
  }

  String userEmail = "";
  String userID = "";
  bool loading = false;

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
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          bottom: PreferredSize(
            child: Container(
              color: const Color(0xff03CB9D),
              height: 6.0,
            ),
            preferredSize: const Size.fromHeight(4.0),
          ),
          title: const Text(
            "Details",
            style: TextStyle(
              color: Color(0xff333333),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 30),
                    child: Text(
                      widget.text["title"],
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff03CB9D),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                      child: ListView.builder(
                          // padding: const EdgeInsets.all(20),
                          itemCount: widget.text["friends"].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                // height: 50,
                                padding: const EdgeInsets.all(10.0),

                                alignment: Alignment.center,

                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  '${widget.text["friends"][index]["name"]} owes ${widget.text["friends"][index]["amount"]}',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                    child: Row(
                      children: <Widget>[
                        widget.text["ownerEmail"] != userEmail
                            ? Container()
                            : FlatButton.icon(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                height: 50,
                                minWidth: 150,
                                onPressed: () => {delete(widget.text["id"])},
                                color: const Color(0xff03CB9D),
                                label: const Text(
                                  "Settle Expense",
                                  style: TextStyle(color: Colors.white),
                                ),
                                icon: const Icon(Icons.payment,
                                    color: Color(0xff333333)),
                              ),
                        const SizedBox(
                          width: 40,
                        ),
                        FlatButton.icon(
                          height: 50,
                          minWidth: 150,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: const Color(0xff03CB9D),
                          label: const Text(
                            "Back",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_left,
                              color: Color(0xff333333)),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
