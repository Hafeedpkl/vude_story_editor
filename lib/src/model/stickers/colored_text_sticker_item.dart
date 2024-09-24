import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/core/enums.dart';
import 'package:vude_story_editor/src/model/stickers/base_sticker_item.dart';
import 'package:vude_story_editor/src/model/stickers/sticker_view_config.dart';
import 'package:vude_story_editor/src/widgets/common_widgets.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';
import 'package:vude_story_editor/src/widgets/stickers/colored_text_sticker_widget.dart';

class ColoredTextStickerItem extends BaseStickerItem {
  ColoredTextStickerItem({
    required this.scale,
    required this.position,
    required this.rotation,
    required this.text,
    this.editMode = false,
    required this.stickerType,
    required this.decorationType,
    this.secondaryText,
  }) {
    bgDecoration(_getDecoration());
  }
  @override
  String get type => 'text-colored';
  @override
  final Rx<Offset> position;

  @override
  final RxDouble rotation;

  final int decorationType;

  @override
  final RxDouble scale;
  final String stickerType;
  RxString text;
  String? secondaryText;

  Rx<BgDecoration> bgDecoration = BgDecoration.d1.obs;

// ColorStickerType colorStickerType

  @override
  final bool editMode;

  @override
  BaseStickerWidget<BaseStickerItem> builder(
          StickerViewConfig config, BoxConstraints constrains) =>
      ColoredTextStickerWidget(this, config, constrains);

  ColorStickerType get coloredSticker => _getColorSelectionType();

  Color get backgroundColor => _backGroundColor();

  Color _backGroundColor() {
    return switch (bgDecoration.value) {
      BgDecoration.d2 => Colors.white30,
      _ => Colors.white,
    };
  }

  ColorStickerType _getColorSelectionType() {
    return switch (stickerType) {
      "location" => _LocationColorStickerType(this),
      "mention" => _MentionColorStickerType(this),
      "link" => _LinkColorStickerType(this),
      _ => _MentionColorStickerType(this),
    };
  }

  BgDecoration _getDecoration() => switch (decorationType) {
        1 => BgDecoration.d1,
        2 => BgDecoration.d2,
        3 => BgDecoration.d3,
        _ => BgDecoration.d1
      };

  toggleBgDecoration() {
    bgDecoration(switch (bgDecoration.value) {
      BgDecoration.d1 => BgDecoration.d2,
      BgDecoration.d2 => BgDecoration.d3,
      BgDecoration.d3 => BgDecoration.d4,
      BgDecoration.d4 => BgDecoration.d1,
    });
  }

  factory ColoredTextStickerItem.fromJson(JSON json) => ColoredTextStickerItem(
      position: Rx(Offset(double.parse(json['position-x'].toString()),
          double.parse(json['position-y'].toString()))),
      rotation: RxDouble(json['rotation'].toDouble()),
      scale: RxDouble(json['scale'].toDouble()),
      text: RxString(json['text']),
      secondaryText: json['secondary_text'],
      stickerType: json['sticker_type'],
      decorationType: json['decoration'] ?? 1);

  @override
  toJson() => {
        'type': type,
        'position-x': position.value.dx,
        'position-y': position.value.dy,
        'rotation': rotation.value,
        'scale': scale.value,
        'text': text.value,
        'secondary_text': secondaryText,
        'sticker_type': stickerType,
        'decoration': bgDecoration.value.bgValue
      };

  @override
  RxBool isDeletePosition = false.obs;
}

abstract class ColorStickerType {
  ColorStickerType(this.sticker);
  ColoredTextStickerItem sticker;
  List<Color> get textGradientColor;
  List<Color> get iconGradientColor;
  Color get bgColor => switch (sticker.bgDecoration.value) {
        BgDecoration.d2 => Colors.white30,
        _ => Colors.white,
      };
  Widget get leadingIcon;
}

class _LocationColorStickerType extends ColorStickerType {
  _LocationColorStickerType(super.sticker);

  @override
  List<Color> get textGradientColor => switch (sticker.bgDecoration.value) {
        BgDecoration.d1 => [Colors.purple, Colors.purple],
        BgDecoration.d2 => [Colors.white, Colors.white],
        BgDecoration.d3 => [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue
          ],
        BgDecoration.d4 => [Colors.black, Colors.black]
      };

  @override
  List<Color> get iconGradientColor => switch (sticker.bgDecoration.value) {
        BgDecoration.d1 => [Colors.purple, Colors.purple],
        BgDecoration.d2 => [Colors.white, Colors.white],
        BgDecoration.d3 => [Colors.red, Colors.red],
        BgDecoration.d4 => [Colors.yellow, Colors.red, Colors.purple]
      };

  @override
  Widget get leadingIcon => Icon(
        Icons.location_on,
        color: Colors.white,
        size: sticker.text.value.length > 30 ? 11 : 15,
      );
}

class _MentionColorStickerType extends ColorStickerType {
  _MentionColorStickerType(super.sticker);

  @override
  List<Color> get textGradientColor => switch (sticker.bgDecoration.value) {
        BgDecoration.d1 => [Colors.deepOrange, Colors.deepOrange],
        BgDecoration.d2 => [Colors.white, Colors.white],
        BgDecoration.d3 => [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue
          ],
        BgDecoration.d4 => [Colors.black, Colors.black]
      };

  @override
  List<Color> get iconGradientColor => switch (sticker.bgDecoration.value) {
        BgDecoration.d1 => [Colors.deepOrange, Colors.deepOrange],
        BgDecoration.d2 => [Colors.white, Colors.white],
        BgDecoration.d3 => [Colors.red, Colors.red],
        BgDecoration.d4 => [Colors.yellow, Colors.red, Colors.purple]
      };

  @override
  Widget get leadingIcon => const TextWidget(
        '@',
        fontWeight: FontWeight.bold,
      );
}

class _LinkColorStickerType extends ColorStickerType {
  _LinkColorStickerType(super.sticker);

  @override
  List<Color> get textGradientColor => switch (sticker.bgDecoration.value) {
        BgDecoration.d1 => [Colors.blue, Colors.blue],
        BgDecoration.d2 => [Colors.white, Colors.white],
        BgDecoration.d3 => [Colors.black, Colors.black],
        BgDecoration.d4 => [Colors.black, Colors.black]
      };

  @override
  List<Color> get iconGradientColor => switch (sticker.bgDecoration.value) {
        BgDecoration.d1 => [Colors.blue, Colors.blue],
        BgDecoration.d2 => [Colors.white, Colors.white],
        BgDecoration.d3 => [Colors.black, Colors.black],
        BgDecoration.d4 => [Colors.yellow, Colors.red, Colors.purple]
      };

  @override
  Widget get leadingIcon => const Padding(
        padding: EdgeInsets.only(right: 5),
        child: SvgIcon(
          'packages/vude_story_editor/assets/svg/link_sticker_icon.svg',
          size: 15,
        ),
      );
}
