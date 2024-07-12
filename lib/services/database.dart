import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<bool> checkUserExists(String uid) async {
    DocumentSnapshot userDoc =
        await firestore.collection('Users').doc(uid).get();
    return userDoc.exists;
  }

  Future<void> addUser(String uid, Map<String, dynamic> userInfoMap) async {
    await firestore.collection("User").doc(uid).set(userInfoMap);
  }
}
