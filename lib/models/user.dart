import 'package:cloud_firestore/cloud_firestore.dart';

class UserC {
  final String fullname;
  final String imageUrl;
  final String uid;
  final String bike;
  final String description;
  final String email;
  final String username;
  final DateTime birthday;

  UserC(
      {required this.fullname,
      required this.imageUrl,
      required this.uid,
      required this.description,
      required this.email,
      required this.username,
      required this.birthday,
      required this.bike});

  factory UserC.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final fullname = data['fullname'] as String;
    final imageUrl = data['image_url'] as String;
    final uid = data['uid'] as String;
    final description = data['description'] as String;
    final email = data['email'] as String;
    final username = data['username'] as String;
    final bike = data['bike'] as String;
    final birthday = (data['birthday'] as Timestamp).toDate();

    return UserC(
        fullname: fullname,
        imageUrl: imageUrl,
        uid: uid,
        description: description,
        email: email,
        username: username,
        birthday: birthday,
        bike: bike);
  }
}
