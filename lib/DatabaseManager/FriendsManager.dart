import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsManager {
  final CollectionReference friends =
      FirebaseFirestore.instance.collection('friends');

  Future getFriendsList(email) async {
    List itemsList = [];

    try {
      await friends.where("userId", isEqualTo: email).get().then((snapshots) {
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

  addFriend(String oid, String oemail, dynamic friend) async {
    if (friend.length != 1) {
      friends.where("userId", isEqualTo: oemail).get().then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          documentSnapshot.reference.update(friend);
        });
      });
    } else {
      await friends.add({'userId': oemail, 'friends': friend});
    }
  }
}


        // documentSnapshot.reference.update(friend);
