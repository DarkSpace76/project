import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:project/main.dart';
import 'package:project/screens/auth/auth.dart';
import 'package:project/server/auth.dart';
import 'package:project/server/firebase.dart';
import 'package:project/server/notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupaBaseService {
  static late SupaBaseService instance;

  SupabaseClient get client => Supabase.instance.client;
  String? userId;

  SupaBaseService() {
    initSupa();
    instance = this;
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  void initSupa() async {
    String supUrlApp = dotenv.env['supabaseUrl'] ?? '';
    String supPubKey = dotenv.env['supabaseKey'] ?? '';

    await Supabase.initialize(url: supUrlApp, anonKey: supPubKey);
  }

  Future<void> createBucket(String name) async {
    await Supabase.instance.client.storage.createBucket(name);
  }

  // Upload file using standard upload
  Future<void> uploadFile(Uint8List data, String fileName) async {
    final tempDir = Directory.systemTemp;
    final uploadFile = File('${tempDir.path}/$fileName');

    try {
      String? uid = AuthorizationService.instance.getuserUid();
      if (uid != null) {
        await uploadFile.writeAsBytes(data);

        String path = await client.storage
            .from('images')
            .upload(
              fileName,
              uploadFile,
              fileOptions: FileOptions(contentType: 'image/png', upsert: false),
            );

        String imageUrl = client.storage
            .from('images')
            .getPublicUrl(path.split('/')[1]);

        await FirestoreService.instance.addImageUrltoBase(imageUrl);

        NotificationService.showNotification(
          body: 'Картинка сохранена и загружена на сервер',
        );
        print(imageUrl);
        print("Successfully uploaded to Supabase: $fileName");
      }
    } catch (e) {
      print('Error uploads image to bucket: ${e}}');
    } finally {
      if (await uploadFile.exists()) {
        await uploadFile.delete();
      }
    }
  }

  Future<bool> checkBucket(name) async {
    try {
      if (userId != null) {
        final buckets = await client.storage.listBuckets();

        for (var bucket in buckets) {
          if (bucket.name.contains(userId!)) {
            return true;
          }
        }

        if (buckets.isEmpty) return false;
      } else {
        NotificationService.showNotification(body: 'Пользователь не найден');
        Get.off(AuthScreen());
      }
    } catch (e) {
      print('Something happened when receiving the list of available buckets.');
    }
    return false;
  }

  Future<List<String>?> getUserFiles() async {
    try {
      if (userId != null) {
        final List<FileObject> files = await client.storage
            .from(userId!)
            .list();

        final List<String> imageUrls = files.map((file) {
          return client.storage.from(userId!).getPublicUrl(file.name);
        }).toList();

        return imageUrls;
      }
    } catch (e) {
      print('Error getting bucket files: $e');
    }
    return null;
  }
}
