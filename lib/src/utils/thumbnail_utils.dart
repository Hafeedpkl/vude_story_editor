import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
class ThumbnailUtils {
  ThumbnailUtils._();
  static Future<String?> getLocalVideoThumbnail(String url) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: url,
      imageFormat: ImageFormat.PNG,
      maxWidth: 600,
      quality: 75,
    );
    if (uint8list == null) return null;
    final tempDir = await getTemporaryDirectory();
    String fileName = 'thumb${DateTime.now().toString()}.png';
    File file = await File('${tempDir.path}/$fileName').create();
    await file.writeAsBytes(uint8list);

    return file.path;
  }

  static Future<String?> getNetworkVideoThumbnail(String url) async {
    try {
      log('create network thumb');
      final fileName = await VideoThumbnail.thumbnailFile(
          video: url, imageFormat: ImageFormat.PNG, maxWidth: 600, quality: 75);
      log('thumb created $fileName');
      return fileName;
    } catch (e) {
      return null;
    }
  }
}
