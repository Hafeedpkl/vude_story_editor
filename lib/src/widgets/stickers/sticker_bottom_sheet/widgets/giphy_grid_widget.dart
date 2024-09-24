import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vude_story_editor/src/controller/story_editng_controller.dart';
import 'package:vude_story_editor/src/widgets/common_widgets.dart';
import 'package:vude_story_editor/src/widgets/search_item/giphy_search_item_widget.dart';

class StickerSearchGrid extends StatelessWidget {
  const StickerSearchGrid({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => StoryEditingController.to.showTrendingGifs.isFalse
        ? _SearchedGifsWidget(
            scrollController: scrollController, key: const Key('search_gif'))
        : _TrendingGifsWidget(
            scrollController: scrollController,
            key: const Key('trending_gif')));
  }
}

class _TrendingGifsWidget extends StatefulWidget {
  const _TrendingGifsWidget({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  State<_TrendingGifsWidget> createState() => _TrendingGifsWidgetState();
}

class _TrendingGifsWidgetState extends State<_TrendingGifsWidget> {
  final controller = StoryEditingController.to;
  @override
  initState() {
    super.initState();
    StoryEditingController.to.getTrendingGifs();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (StoryEditingController.to.gifTrendingLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (StoryEditingController.to.trendingGifs.isEmpty) {
        return Center(
          child: Column(
            children: [
              const TextWidget('Something went wrong!'),
              TextButton(
                  onPressed: () {
                    StoryEditingController.to.getTrendingGifs();
                  },
                  child: const TextWidget('Retry'))
            ],
          ),
        );
      }
      return GridView.builder(
          physics: const BouncingScrollPhysics(),
          controller: widget.scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4),
          itemCount: controller.trendingGifs.length,
          itemBuilder: (context, index) =>
              GiphySearchItemWidget(controller.trendingGifs[index]));
    });
  }
}

class _SearchedGifsWidget extends StatelessWidget {
  const _SearchedGifsWidget({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (StoryEditingController.to.gifSearchLoading.value) {
          return const Align(
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator());
        }
        return Visibility(
          visible: StoryEditingController.to.gifSearchResults.isNotEmpty,
          replacement: const TextWidget('No result found.'),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            itemCount: StoryEditingController.to.gifSearchResults.length,
            itemBuilder: (context, index) => GiphySearchItemWidget(
                StoryEditingController.to.gifSearchResults[index]),
          ),
        );
      },
    );
  }
}
