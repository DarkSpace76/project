import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project/styles/colors.dart';
import 'package:project/styles/icons.dart';

class BrushSelectSize extends StatefulWidget {
  final Function(double)? onChangeEnd;
  final Color? currentColor;
  double brushSize;
  BrushSelectSize({
    super.key,
    required this.onChangeEnd,
    this.currentColor,
    required this.brushSize,
  });

  @override
  State<BrushSelectSize> createState() => _BrushSelectSizeState();
}

class _BrushSelectSizeState extends State<BrushSelectSize> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Slider(
          value: widget.brushSize,
          min: 5.0,
          max: 50.0,
          onChanged: (double value) {
            setState(() {
              widget.brushSize = value;
            });
          },
          onChangeEnd: widget.onChangeEnd,
        ),
        Container(
          width: widget.brushSize,
          height: widget.brushSize,
          decoration: BoxDecoration(
            color: widget.currentColor,
            borderRadius: BorderRadius.circular(360),
          ),
        ),
      ],
    );
  }
}

Future<double?> showPenSizeDialog(
  BuildContext btnContext,
  Color curentColor,
  double sizeBrush,
) async {
  final RenderBox button = btnContext.findRenderObject() as RenderBox;
  final Offset offset = button.localToGlobal(Offset.zero);

  double selSizeBrush = sizeBrush;

  void selectSize(double? sizeBrush) {
    selSizeBrush = sizeBrush!;
    Get.back<double>(result: sizeBrush);
  }

  await showDialog(
    context: btnContext,
    barrierColor: Colors.transparent,
    builder: (ctx) {
      return Stack(
        children: [
          Transform.translate(
            offset: offset,
            child: SvgPicture.asset(
              IconApp.arrowClip,
              colorFilter: ColorFilter.mode(bgModalColor, BlendMode.srcIn),
              width: 47,
              height: 13,
            ),
          ),
          Positioned(
            left: MediaQuery.of(ctx).size.width - ((24 * 13) + 16),
            top: offset.dy + 13,
            child: Material(
              borderRadius: BorderRadius.circular(16),
              color: bgModalColor,
              elevation: 4,
              child: Container(
                padding: EdgeInsets.all(16),
                width: 24 * 13, //padding 16+16
                height: 24 * 11 + 32,
                child: BrushSelectSize(
                  currentColor: curentColor,
                  onChangeEnd: selectSize,
                  brushSize: selSizeBrush,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  return selSizeBrush;
}
