import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project/styles/icons.dart';

const List<MaterialColor> _primariesColor = <MaterialColor>[
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.indigo,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.brown,
];

class AppColorPicker extends StatefulWidget {
  final Function(Color?)? onTap;
  final Color? currentColor;
  AppColorPicker({super.key, this.onTap, this.currentColor});

  @override
  State<AppColorPicker> createState() => _AppColorPickerState();
}

class _AppColorPickerState extends State<AppColorPicker> {
  Map<Color, List<Color>> colorList = {};

  List<Color> _genSpectrColor(Color baseColor) {
    List<Color> colorsResult = [];

    final hslBase = HSLColor.fromColor(baseColor);
    double baseHue = hslBase.hue;
    double baseSaturation = hslBase.saturation;
    double baseLightness = hslBase.lightness;

    for (int i = -5; i <= 5; i++) {
      double factor = i / 10.0;

      if (factor < 0) {
        double lightness = baseLightness + (factor * baseLightness);
        double saturation = baseSaturation + (factor.abs() * 0.1);
        colorsResult.add(
          HSLColor.fromAHSL(
            1.0,
            baseHue,
            saturation.clamp(0.1, 1.0),
            lightness.clamp(0.05, 1.0),
          ).toColor(),
        );
      } else if (factor == 0) {
        colorsResult.add(baseColor);
      } else {
        double lightness = baseLightness + (factor * (1.0 - baseLightness));
        double saturation = baseSaturation - (factor * 0.7);
        colorsResult.add(
          HSLColor.fromAHSL(
            1.0,
            baseHue,
            saturation.clamp(0.1, 1.0),
            lightness.clamp(0.0, 0.95),
          ).toColor(),
        );
      }
    }
    if (baseColor == Colors.black) colorsResult.last = Colors.white;
    return colorsResult;
  }

  Map<Color, List<Color>> _generateColorsList() {
    Map<Color, List<Color>> colorsMap = {};

    for (Color bsColor in _primariesColor) {
      colorsMap[bsColor] = _genSpectrColor(bsColor);
    }
    colorsMap[Colors.black] = _genSpectrColor(Colors.black);

    return colorsMap;
  }

  @override
  void initState() {
    colorList = _generateColorsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: colorList.values.map((el) {
              return Column(
                children: [
                  for (int i = 0; i < el.length; i++)
                    InkWell(
                      onTap: () => widget.onTap?.call(el[i]),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          border: widget.currentColor == el[i]
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                          color: el[i],
                        ),
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

Future<Color?> showColorPicker(
  BuildContext btnContext,
  Color? curentColor,
) async {
  final RenderBox button = btnContext.findRenderObject() as RenderBox;
  final Offset offset = button.localToGlobal(Offset.zero);
  const bgColor = Color.fromRGBO(153, 153, 153, 0.97);

  void selectColorCallback(Color? select) {
    Get.back<Color>(result: select);
  }

  final Color? selectedColor = await showDialog(
    context: btnContext,
    barrierColor: Colors.transparent,
    builder: (_) {
      return Stack(
        children: [
          Transform.translate(
            offset: Offset(offset.dx - 13, offset.dy),
            child: SvgPicture.asset(
              IconApp.arrowClip,
              colorFilter: ColorFilter.mode(bgColor, BlendMode.srcIn),
              width: 47,
              height: 13,
            ),
          ),
          Positioned(
            left: offset.dx - (24 * 12 + 16),
            top: offset.dy + 13,
            child: Material(
              borderRadius: BorderRadius.circular(16),
              color: bgColor,
              elevation: 4,
              child: Container(
                padding: EdgeInsets.all(16),
                width: 24 * 13 + 32, //padding 16+16
                height: 24 * 11 + 32,
                child: AppColorPicker(
                  onTap: selectColorCallback,
                  currentColor: curentColor,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  return selectedColor;
}
