import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneytracker_app/appdata.dart';

class FireStore {
  static Future createUser() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    final json = {'userID': AppData.username, 'balance': 0};
    final userData = await getUserData();
    if (userData.docs.length == 0) {
      docUser.set(json);
    } else {
      print(userData.docs[0].data());
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getUserData() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userID', isEqualTo: AppData.username)
        .get();
    return querySnapshot;
  }

  static Future<double> getBalance() async {
    final userData = await getUserData();
    return userData.docs[0].data()['balance'];
  }
}
