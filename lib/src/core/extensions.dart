import 'dart:ui';
import 'dart:developer' as dv;
import 'package:vude_story_editor/src/utils/hex_color.dart';

extension XString on String {
  Color get toHexColor {
    return HexColor(this);
  }

  String get toHexString {
    return replaceAll('FF', '#');
  }

  bool get isFileImage => getMediaType() == 'image';
  String? getMediaType() {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp'];
    final ext = split('.').last.toLowerCase();
    if (imageExtensions.contains(ext)) {
      return 'image';
    } else if (videoExtensions.contains(ext)) {
      return 'video';
    }
    return null;
  }
}

extension XColor on Color {
  String get hexValue {
    return '#${value.toRadixString(16).substring(2).toUpperCase()}';
  }
}

extension XLog on Comparable {
  log([String? name]) => dv.log(toString(), name: name ?? 'quickLog');
  get logPrint => log();
}
