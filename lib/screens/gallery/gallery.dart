import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/components/bg_widget.dart';
import 'package:project/components/button.dart';
import 'package:project/components/custom_app_bar.dart';
import 'package:project/screens/editor_screen/editor.dart';
import 'package:project/screens/gallery/components/gallery_explorer.dart';
import 'package:project/server/auth.dart';
import 'package:project/styles/icons.dart';
import 'package:project/utils/app_text.dart';
import 'package:project/utils/const.dart';

class GalleryScreen extends StatelessWidget {
  GalleryScreen({super.key});

  List<String> sourceImage = List.generate(15, (i) {
    return 'assets/test.jpg';
  });

  void toCreateImage() {
    Get.to(() => EditorScreen(titleScreen: captionEditorNew));
  }

  void toRepaintImage() {
    Get.to(() => EditorScreen(titleScreen: captionEditorEdit));
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: customAppBar(
          caption: captionGallery,
          leadingIcon: IconApp.logout,
          onLeadingPress: () => AuthorizationService.instance.logout(),
          confirm: sourceImage.isNotEmpty ? IconApp.repaint : null,
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
                Expanded(
                  child: gallery(
                    List.generate(15, (i) {
                      return 'assets/test.jpg';
                    }),
                  ),
                ),
                if (sourceImage.isEmpty)
                  gradientButton(caption: createBtn, onPress: toCreateImage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
