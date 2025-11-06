import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:project/screens/SplashScreen/splash_screen.dart';
import 'package:project/screens/editor_screen/editor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/server/auth.dart';
import 'package:project/utils/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

const supabaseUrl = 'https://gzzpnhbqzninreboubht.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd6enBuaGJxem5pbnJlYm91Ymh0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIzNzQyOTAsImV4cCI6MjA3Nzk1MDI5MH0.HDMgX6R1hq2DEo8Z_dfZoVYtuWX1_92Qa_bMBLSMFmA';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: 'https://ojcjxghedpvsuujbdjxj.storage.supabase.co/storage/v1/s3',
    anonKey: '976358886ee50c0c75170fa1b5dc5ef1dac132cc260d44a852194fa6b64fc426',
  );

  AuthorizationService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Paint ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
    );
  }
}
