import 'package:cloud_firestore/cloud_firestore.dart';

class UserC {
  final String fullname;
  final String imageUrl;
  final String uid;
  final String description;
  final String email;
  final String username;

  UserC({
    required this.fullname,
    required this.imageUrl,
    required this.uid,
    required this.description,
    required this.email,
    required this.username,
  });

  factory UserC.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final fullname = data['fullname'] as String;
    final imageUrl = data['image_url'] as String;
    final uid = data['uid'] as String;
    final description = data['description'] as String;
    final email = data['email'] as String;
    final username = data['username'] as String;

    return UserC(
      fullname: fullname,
      imageUrl: imageUrl,
      uid: uid,
      description: description,
      email: email,
      username: username,
    );
  }
}
