import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/components/bg_widget.dart';
import 'package:project/components/button.dart';
import 'package:project/components/circle_indicator.dart';
import 'package:project/components/custom_app_bar.dart';
import 'package:project/screens/editor_screen/editor.dart';
import 'package:project/screens/gallery/components/gallery_explorer.dart';
import 'package:project/server/auth.dart';
import 'package:project/server/firebase.dart';
import 'package:project/server/supabase.dart';
import 'package:project/styles/icons.dart';
import 'package:project/utils/app_text.dart';
import 'package:project/utils/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GalleryScreen extends StatefulWidget {
  GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  bool isLoad = false;
  List<String>? sourceImage;

  @override
  void initState() {
    super.initState();
  }

  void toCreateImage() {
    Get.to(() => EditorScreen(titleScreen: captionEditorNew));
  }

  void toRepaintImage() {
    Get.to(() => EditorScreen(titleScreen: captionEditorEdit));
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: FutureBuilder(
        future: FirestoreService.instance.getImageFromBase(),
        builder: (context, snapshot) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: customAppBar(
              caption: captionGallery,
              leadingIcon: IconApp.logout,
              onLeadingPress: () => AuthorizationService.instance.logout(),
              confirm: snapshot.data?.isNotEmpty == true
                  ? IconApp.repaint
                  : null,
              onConfirmPress: toCreateImage,
            ),
            body: SafeArea(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.only(bottom: 30, left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (snapshot.hasData == false || snapshot.data?.length == 0)
                      gradientButton(caption: createBtn, onPress: toCreateImage)
                    else
                      Expanded(child: gallery(snapshot.data!)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
