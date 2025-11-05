import 'package:flutter/material.dart';
import 'package:project/components/bg_widget.dart';
import 'package:project/components/button.dart';
import 'package:project/components/custom_app_bar.dart';
import 'package:project/styles/icons.dart';
import 'package:project/utils/app_text.dart';
import 'package:project/utils/const.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  void toCreateImage() {}

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: customAppBar(
          caption: captionGallery,
          leadingIcon: IconApp.logout,
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.only(bottom: 30, left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                gradientButton(caption: createBtn, onPress: toCreateImage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
