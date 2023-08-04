import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future addUserImage(String imageUrl) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      'image_url': imageUrl
    }); // set overwrites the entire document with the new data
    // ignore: empty_catches
  } catch (e) {}
}

Future<String> uploadImageToFirebase(imageFile, folderName) async {
  if (imageFile != null) {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('$folderName/${DateTime.now()}.png');

    final uploadTask = storageRef.putFile(imageFile!);
    await uploadTask.whenComplete(() => null);
    final downloadUrl = await storageRef.getDownloadURL();
    FirebaseFirestore.instance.collection('images').add({'url': downloadUrl});
    return downloadUrl;
  }
  return '';
}
