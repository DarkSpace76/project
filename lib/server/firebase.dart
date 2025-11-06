import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/screens/gallery/model/image.dart';

class FirestoreService {
  late final FirebaseFirestore _firestore;
  static late FirestoreService instance;

  String? userId;

  FirestoreService() {
    _firestore = FirebaseFirestore.instance;
    instance = this;
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> addImageUrltoBase(String publicUrl) async {
    if (userId != null) {
      try {
        await _firestore.collection('images').add({
          'uid': userId,
          'url': publicUrl,
        });
        print('Image added');
      } catch (e) {
        print('Error addImageUrltoBase: ${e}');
      }
    }
  }

  Future<List<AppImamge>?> getImageFromBase() async {
    if (userId != null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('images')
            .where('uid', isEqualTo: userId)
            .get();

        List<AppImamge> images = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          AppImamge appImamge = AppImamge(data['uid'] ?? '', data['url'] ?? '');
          return appImamge;
        }).toList();

        return images;
      } catch (e) {
        print('Ошибка: $e');
      }
      return null;
    }
  }
}
