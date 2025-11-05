import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project/components/bg_widget.dart';
import 'package:project/components/color_picker.dart';
import 'package:project/components/custom_app_bar.dart';
import 'package:project/screens/editor_screen/components/app_canvas.dart';
import 'package:project/styles/icons.dart';
import 'package:project/utils/app_text.dart';
import 'package:project/utils/utils.dart';

class EditorScreen extends StatefulWidget {
  EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  Color currentColor = Colors.red;
  bool isErease = false;

  void toCreateImage() {}

  void selColorDialog(BuildContext context) {
    showColorPicker(context, currentColor).then((color) {
      setState(() {
        currentColor = color ?? Colors.red;
        print('User selected color -> ${currentColor}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true, //
        appBar: customAppBar(
          caption: captionEditorNew,
          leadingIcon: IconApp.back,
          confirm: IconApp.confirm,
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.only(bottom: 30, left: 16, right: 16),
            child: Column(
              spacing: 20,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 15,
                    children: [
                      _circlBtn(
                        iconPath: IconApp.exportImage,
                        onPress: (ctx) {
                          saveToImage();
                        },
                      ),
                      _circlBtn(iconPath: IconApp.image, onPress: (ctx) {}),
                      _circlBtn(
                        iconPath: IconApp.pen,
                        onPress: (ctx) {
                          isErease = false;
                        },
                      ),
                      _circlBtn(
                        iconPath: IconApp.erese,
                        onPress: (ctx) {
                          isErease = true;
                        },
                      ),
                      _circlBtn(
                        iconPath: IconApp.coloPicker,
                        colorIcon: currentColor,
                        onPress: selColorDialog,
                      ),
                    ],
                  ),
                ),
                Expanded(child: AppCanvas(paintColor: currentColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _circlBtn({
  required String iconPath,
  Color? colorIcon,
  required Function(BuildContext context) onPress,
}) {
  return ClipOval(
    child: Material(
      color: Colors.transparent,
      child: Builder(
        builder: (context) {
          return InkWell(
            borderRadius: BorderRadius.circular(360),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(360),
              ),
              child: SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                fit: BoxFit.none,
                colorFilter: ColorFilter.mode(
                  colorIcon ?? Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            onTap: () => onPress(context),
          );
        },
      ),
    ),
  );
}
