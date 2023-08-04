import 'package:cloud_firestore/cloud_firestore.dart';

// called with: final host = await getDocumentByIdEveryType("users", hostId, (snapshot) => Host.fromDocument(snapshot));
// --> 3rd argument is which type of document I want to get
Future<T> getDocumentByIdEveryType<T>(String collectionName, String? documentId,
    T Function(DocumentSnapshot) fromSnapshot) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection(collectionName)
      .doc(documentId)
      .get();
  return fromSnapshot(snapshot);
}
