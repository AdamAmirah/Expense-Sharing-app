import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ExpensesManager {
  final CollectionReference expenses =
      FirebaseFirestore.instance.collection('expenses');
  Future addExpense(String oid, String email, String title, double amount,
      dynamic includedFriends) async {
    var id = const Uuid().v1();

    return await expenses.doc(id.toString()).set({
      'ownerID': oid,
      'ownerEmail': email,
      'title': title,
      'amount': amount,
      'friends': includedFriends,
      'id': id.toString()
    });
  }

  Future getExpenseList() async {
    List itemsList = [];

    try {
      await expenses.get().then((snapshots) {
        snapshots.docs.forEach((element) {
          itemsList.add(element.data());
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteExpense(id) async {
    var snapshot = await expenses.where("id", isEqualTo: id).get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
