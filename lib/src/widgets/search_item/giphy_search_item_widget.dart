import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vude_story_editor/src/controller/story_editng_controller.dart';
import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/model/search_item/giphy_search_item.dart';
import 'package:vude_story_editor/src/model/stickers/giphy_sticker_item.dart';

class GiphySearchItemWidget extends StatefulWidget {
  const GiphySearchItemWidget(this.item, {super.key});
  final GiphySearchItem item;

  @override
  State<GiphySearchItemWidget> createState() => _GiphySearchItemWidgetState();
}

class _GiphySearchItemWidgetState extends State<GiphySearchItemWidget> {
  final controller = StoryEditingController.to;
  @override
  initState() {
    super.initState();
    controller.searchTextController.addListener(() {
      controller.showTrendingGifs(controller.searchTextController.text.isEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            if (widget.item.urlOriginal.isNotEmpty) {
              controller.stickerElements.add(GiphyStickerItem(
                  position: const Offset(.5, .5).obs,
                  rotation: 0.0.obs,
                  scale: 1.0.obs,
                  editMode: true,
                  url: widget.item.urlSmall));
              controller.update();
            }
            Get.back();
          },
          child: CachedNetworkImage(
              progressIndicatorBuilder: (context, url, progress) {
                Rx<DownloadProgress> loadingProgress = progress.obs;
                return Center(
                  child: Obx(
                    () => CircularProgressIndicator(
                      value: loadingProgress.value.progress ?? 0,
                      color: themeColor.withOpacity(.8),
                      backgroundColor: themeColor.withOpacity(0.2),
                      strokeWidth: 1.5,
                    ),
                  ),
                );
              },
              imageUrl: widget.item.urlSmall),
        ),
      ),
    );
  }
}
