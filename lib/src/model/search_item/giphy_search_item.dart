import 'package:flutter/cupertino.dart';
import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/model/search_item/base_search_item.dart';
import 'package:vude_story_editor/src/widgets/search_item/giphy_search_item_widget.dart';

class GiphySearchItem extends BaseSearchItem {
  GiphySearchItem({required this.urlSmall, required this.urlOriginal});

  @override
  String get name => 'gif-trending';

  final String urlSmall;
  final String urlOriginal;

  @override
  Widget get builder => GiphySearchItemWidget(this);
  factory GiphySearchItem.fromJson(JSON json) => GiphySearchItem(
      urlOriginal: json['images']['fixed_height']['url'],
      urlSmall: json['images']['fixed_width']['url']);
}
