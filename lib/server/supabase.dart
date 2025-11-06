import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project/main.dart';
import 'package:project/server/auth.dart';
import 'package:project/server/notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupaBaseService {
  static late SupaBaseService instance;

  SupabaseClient get client => Supabase.instance.client;

  SupaBaseService() {
    initSupa();
    instance = this;
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

        if (await checkBucket(uid) == false) {
          await createBucket(uid);
        }

        await client.storage
            .from(uid)
            .upload(
              fileName,
              uploadFile,
              fileOptions: FileOptions(contentType: 'image/png', upsert: false),
            );

        NotificationService.showNotification(
          title: 'Easy Paint',
          body: 'Картинка сохранена и загружена на сервер',
        );

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
      final buckets = await client.storage.listBuckets();

      for (var bucket in buckets) {
        if (bucket.name.contains(name)) {
          return true;
        }
      }

      if (buckets.isEmpty) return false;
    } catch (e) {
      print('Something happened when receiving the list of available buckets.');
    }
    return false;
  }
}
