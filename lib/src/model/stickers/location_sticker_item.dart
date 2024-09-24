
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';
import 'package:vude_story_editor/src/widgets/stickers/location_sticker_widget.dart';
import 'package:vude_story_editor/vude_story_editor.dart';

class LocationStickerItem extends BaseStickerItem {
  LocationStickerItem({
    required this.position,
    required this.rotation,
    required this.scale,
    required this.location,
    required this.decorationType,
    this.editMode = false,
  }) {
    bgDecoration(_getDecoration());
  }
  @override
  String get type => 'location';
  @override
  final Rx<Offset> position;

  @override
  final RxDouble rotation;

  @override
  final RxDouble scale;

  @override
  final bool editMode;

  final String location;
  final int decorationType;

  Rx<BgDecoration> bgDecoration = BgDecoration.d1.obs;

  BgDecoration _getDecoration() => switch (decorationType) {
        1 => BgDecoration.d1,
        2 => BgDecoration.d2,
        3 => BgDecoration.d3,
        _ => BgDecoration.d1
      };

  toggleDecoration() {
    switch (bgDecoration.value) {
      case BgDecoration.d1:
        bgDecoration(BgDecoration.d2);
        break;
      case BgDecoration.d2:
        bgDecoration(BgDecoration.d3);
        break;
      case BgDecoration.d3:
        bgDecoration(BgDecoration.d1);
        break;
      default:
    }
  }

  @override
  RxBool isDeletePosition = false.obs;
  @override
  BaseStickerWidget<BaseStickerItem> builder(
          StickerViewConfig config, BoxConstraints constrains) =>
      LocationStickerWidget(this, config, constrains);
  factory LocationStickerItem.fromJson(JSON json) => LocationStickerItem(
      position: Rx(Offset(double.parse(json['position-x'].toString()),
          double.parse(json['position-y'].toString()) )),
      rotation: RxDouble(double.parse(json['rotation'].toString())),
      scale: RxDouble(double.parse(json['scale'].toString())),
      location: json['location'] ?? 'nowhere',
      decorationType: json['decoration'] is int
          ? int.parse(json['decoration'].toString())
          : 1);

  @override
  toJson() => {
        'type': type,
        'position-x': position.value.dx ,
        'position-y': position.value.dy,
        'rotation': rotation.value,
        'scale': scale.value,
        'location': location,
        'decoration': bgDecoration.value.bgValue
      };
}
