import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/core/enums.dart';
import 'package:vude_story_editor/src/core/extensions.dart';
import 'package:vude_story_editor/src/model/stickers/base_sticker_item.dart';
import 'package:vude_story_editor/src/model/stickers/sticker_view_config.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';
import 'package:vude_story_editor/src/widgets/stickers/text_sticker_widget.dart';

class TextStickerItem extends BaseStickerItem {
  TextStickerItem(
      {required this.fontName,
      required this.position,
      required this.rotation,
      required this.scale,
      required this.text,
      required this.textAlign,
      required this.bgValue,
      Color? bgColorV = Colors.white,
      Color? fontColorV = Colors.white,
      this.editMode = false}) {
    bgColor(bgColorV);
    fontColor(fontColorV);
    bgDecoration(BgDecoration.values
        .firstWhere((element) => element.bgValue == bgValue));
    fontSelected(fontFamilyList.indexOf(fontName.value));
  }
  @override
  String get type => 'text-main';
  final RxString fontName;

  @override
  final Rx<Offset> position;

  @override
  final RxDouble scale;

  @override
  final RxDouble rotation;

  @override
  final bool editMode;

  RxString text;

  int bgValue;

  Rx<TextAlign> textAlign;

  Rx<BgDecoration> bgDecoration = BgDecoration.d1.obs;
  Rx<Color> fontColor = Colors.white.obs;
  Rx<Color> bgColor = Colors.white.obs;
  RxInt fontSelected = 0.obs;
  RxBool decorationIconFilled = false.obs;
  Rx<Color> colorSelected = Colors.white.obs;
  Rx<double> fontSize = 25.0.obs;

  @override
  RxBool isDeletePosition = false.obs;
  @override
  toString() =>
      '{type:$type,text:$text, position:$position, scale:$scale, rotation:$rotation}';

  @override
  BaseStickerWidget<BaseStickerItem> builder(
          StickerViewConfig config, BoxConstraints constrains) =>
      TextStickerWidget(this, config, constrains);

  BgDecoration getBgDecoration() {
    return switch (bgValue) {
      1 => BgDecoration.d1,
      2 => BgDecoration.d2,
      3 => BgDecoration.d3,
      _ => BgDecoration.d1
    };
  }

  onClickDecoration() {
    switch (bgDecoration.value) {
      case BgDecoration.d1:
        bgDecoration(BgDecoration.d2);
        decorationIconFilled(true);
        bgColor(Colors.white);
        if (fontColor.value == Colors.white) fontColor(Colors.black);
        break;
      case BgDecoration.d2:
        bgDecoration(BgDecoration.d3);
        decorationIconFilled(true);
        if (fontColor.value == Colors.black) fontColor(Colors.white);
        bgColor(Colors.black);

        break;
      case BgDecoration.d3:
        bgDecoration(BgDecoration.d1);
        decorationIconFilled(false);
        fontColor(colorSelected.value);
        bgColor(Colors.white);
        break;
      default:
    }
  }

  changeColor(Color color) {
    colorSelected(color);
    if (bgDecoration.value == BgDecoration.d3) {
      bgColor(color);
    } else {
      fontColor(color);
    }
  }

  changeFont(int value) {
    fontSelected(value);
    fontName(fontFamilyList[fontSelected.value]);
  }

  factory TextStickerItem.fromJson(JSON json) => TextStickerItem(
      fontName:
          RxString(notNullableType(json['font-family'], replacement: 'Gilmer')),
      position: Rx(Offset(double.parse(json['position-x'].toString()),
          double.parse(json['position-y'].toString()))),
      rotation: RxDouble((json['rotation'].toDouble())),
      scale: RxDouble(json['scale'].toDouble()),
      text: RxString(json['text']),
      bgColorV: json['decoration-color'] == null
          ? null
          : ((json['decoration-color'] as String).toHexColor),
      fontColorV: json['font-color'] == null
          ? null
          : (json['font-color'] as String).toHexColor,
      textAlign: getTextAlign(json['text-align'] ?? 'center').obs,
      bgValue: json['decoration'] ?? 1);

  @override
  JSON toJson() => {
        'type': type,
        'text': text.value,
        'font-family': fontName.value,
        'position-x': position.value.dx,
        'position-y': position.value.dy,
        'rotation': rotation.value,
        'scale': scale.value,
        'text-align': textAlign.value.name,
        'decoration': bgDecoration.value.bgValue,
        'font-color': fontColor.value.hexValue,
        'decoration-color': bgColor.value.hexValue
      };

  static TextAlign getTextAlign(String s) {
    return switch (s) {
      "left" => TextAlign.left,
      "right" => TextAlign.right,
      _ => TextAlign.center,
    };
  }

  static notNullableType(dynamic value, {dynamic replacement}) {
    if (value.runtimeType == replacement.runtimeType) {
      return value;
    }
    return replacement;
  }
}
