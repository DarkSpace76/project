import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:project/components/bg_widget.dart';
import 'package:project/components/color_picker.dart';
import 'package:project/components/custom_app_bar.dart';
import 'package:project/screens/editor_screen/components/app_canvas.dart';
import 'package:project/screens/editor_screen/components/brush_size_dialog.dart';
import 'package:project/screens/editor_screen/models/model_edit.dart';
import 'package:project/screens/gallery/gallery.dart';
import 'package:project/server/notification.dart';
import 'package:project/styles/icons.dart';
import 'package:project/utils/utils.dart';

class EditorScreen extends StatefulWidget {
  String? titleScreen;
  String? imagePath;
  EditorScreen({super.key, this.titleScreen, this.imagePath});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  @override
  void initState() {
    super.initState();
    Brush();
  }

  void selectBrushTool(BuildContext ctx) {
    setState(() {
      Brush.instance.isErase = false;
    });
  }

  void selectEraseTool(BuildContext ctx) {
    setState(() {
      Brush.instance.isErase = true;
    });
  }

  void selColorDialog(BuildContext context) {
    showColorPicker(context, Brush.instance.color).then((color) {
      setState(() {
        Brush.instance.setColor(color);
        print('User selected color -> ${color}');
      });
    });
  }

  void selectSizeDialog(BuildContext context) {
    showPenSizeDialog(context, Brush.instance.color, Brush.instance.size).then((
      size,
    ) {
      setState(() {
        Brush.instance.setSize(size);
        print('User selected size -> ${size}');
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
          caption: widget.titleScreen,
          leadingIcon: IconApp.back,
          onLeadingPress: () => Get.back(),
          confirm: IconApp.confirm,
          onConfirmPress: () async {
            await saveToImage();
            Get.back<bool>(result: true);
          },
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
                        onPress: (ctx) {},
                      ),
                      _circlBtn(iconPath: IconApp.image, onPress: (ctx) {}),
                      _circlBtn(
                        iconPath: IconApp.brush,
                        onPress: selectBrushTool,
                        onLongPress: selectSizeDialog,
                      ),
                      _circlBtn(
                        iconPath: IconApp.erese,
                        onPress: selectEraseTool,
                        onLongPress: selectSizeDialog,
                      ),
                      _circlBtn(
                        iconPath: IconApp.coloPicker,
                        colorIcon: Brush.instance.color,
                        onPress: selColorDialog,
                      ),
                    ],
                  ),
                ),
                Expanded(child: AppCanvas()),
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
  Function(BuildContext context)? onLongPress,
}) {
  BoxBorder? getBorder() {
    if ((Brush.instance.isErase && IconApp.erese.contains(iconPath)) ||
        (!Brush.instance.isErase && IconApp.brush.contains(iconPath))) {
      return BoxBorder.all(color: Colors.yellowAccent.withAlpha(100), width: 2);
    }
    return null;
  }

  return ClipOval(
    child: Material(
      color: Colors.transparent,
      child: Builder(
        builder: (context) {
          return InkWell(
            onLongPress: onLongPress != null
                ? () => onLongPress(context)
                : null,
            onTap: () => onPress(context),
            borderRadius: BorderRadius.circular(360),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(360),
                border: getBorder(),
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
          );
        },
      ),
    ),
  );
}
