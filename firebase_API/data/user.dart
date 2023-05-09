import 'package:firebase_database/firebase_database.dart';

class User {
  final String? id;
  final String? pw;
  final String? createTime;

  const User({required this.id, required this.pw, required this.createTime});

  User.fromsnapshot(DataSnapshot snapshot)
  :
      id = (snapshot.value as Map)['id'],
      pw = (snapshot.value as Map)['pw'],
      createTime = (snapshot.value as Map)['createTime'];

  toJson() {
    return {
      'id' : id,
      'pw' : pw,
      'createTime' : createTime,
    };
  }
}