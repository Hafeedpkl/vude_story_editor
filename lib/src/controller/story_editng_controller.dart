import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vude_story_editor/src/core/extensions.dart';
import 'package:vude_story_editor/src/model/search_item/giphy_search_item.dart';
import 'package:vude_story_editor/src/model/stickers/audio_sticker_item.dart';
import 'package:vude_story_editor/src/model/stickers/colored_text_sticker_item.dart';
import 'package:vude_story_editor/src/model/stickers/location_sticker_item.dart';
import 'package:vude_story_editor/src/service/api_constants.dart';
import 'package:vude_story_editor/src/service/api_services.dart';
import 'package:vude_story_editor/src/utils/debouncer.dart';
import 'package:vude_story_editor/src/utils/thumbnail_utils.dart';
import 'package:vude_story_editor/src/widgets/bubble_reaction_widget/components/emojis.dart';
import 'package:vude_story_editor/vude_story_editor.dart';

class StoryEditingController extends GetxController
    with WidgetsBindingObserver {
  static StoryEditingController get to => Get.find();

  Color themeColor = const Color(0xFF07FC00);

  //Main action
  RxBool inAction = false.obs;

  //sticker details
  BaseStickerItem? activeItem;
  Offset initPos = Offset.zero;
  Offset currentPos = Offset.zero;
  double currentScale = 1;
  double currentRotation = 0;

  //removeIcon
  RxBool showDeleteIcon = false.obs;
  RxBool isDeletePosition = false.obs;
  List<BaseStickerItem> stickerElements = <BaseStickerItem>[];

  Duration animationDuration = const Duration(milliseconds: 600);
  RxList<Color>? bgColors;
  late FutureOr<List<MentionUser>> Function(String query)
      getMentionUsersCallBack;
  late FutureOr<String?> Function() getLocationCallBack;
  late FutureOr<List<AudioTrack>> Function(String query) audioSearchCallBack;
  late Function(Storycontent content) onEditComplete;
  RxList<MentionUser> mentionUsers = <MentionUser>[].obs;
  late String mediaFile;
  StoryPost? storyPost;
  late String giphyKey;
  RxBool searchMode = false.obs;
  Debouncer debouncer = Debouncer(milliseconds: 300);
  TextEditingController textEditingController = CustomTextEditingController(
      onMatch: (match) {
        // log(match.toString());
      },
      patternMatchMap: {
        RegExp(r"\B@[a-zA-Z0-9]+\b"): const TextStyle(
            fontWeight: FontWeight.bold, decoration: TextDecoration.underline)
      });
  @override
  onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    // getEmojis();
  }

  @override
  onReady() {
    getBgBackground();
  }

  @override
  void didChangeAppLifecycleState(ui.AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (currentAudioPlayer.playing) {
        currentAudioPlayer.stop();
      }
      if (mainAudioPlayer.playing) {
        mainAudioPlayer.pause();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (mainAudioTrack.value != null) {
        mainAudioPlayer.play();
      }
    }
  }

  @override
  onClose() {
    currentAudioPlayer.dispose();
    mainAudioPlayer.dispose();
    editTextItem = null;
    WidgetsBinding.instance.removeObserver(this);
    stickerElements.clear();
    super.dispose();
  }

  initDatas(
      {required String file,
      required List<BaseStickerItem>? drafts,
      Color? themeColor,
      required FutureOr<List<MentionUser>> Function(String query) onMention,
      required FutureOr<String> Function() onTapLocation,
      required FutureOr<List<AudioTrack>> Function(String query) onAudioSearch,
      required Function(Storycontent content) onEditComplete,
      required String giphyKey,
      StoryPost? storyPost}) {
    if (themeColor != null) this.themeColor = themeColor;
    getMentionUsersCallBack = onMention;
    getLocationCallBack = onTapLocation;
    audioSearchCallBack = onAudioSearch;
    this.onEditComplete = onEditComplete;
    mediaFile = file;
    this.storyPost = storyPost;
    this.giphyKey = giphyKey;
    stickerElements.addAll([
      MainMediaStickerItem(
          position: const Offset(0, 0).obs,
          rotation: 0.0.obs,
          scale: 1.0.obs,
          storyPost: storyPost,
          file: file,
          editMode: true,
          isFile: storyPost == null,
          mediaType: storyPost != null
              ? storyPost.currentMedia.postType
              : file.getMediaType() ?? 'image'),
      if (drafts != null) ...drafts
    ]);
    update();
    // getMentionUsers("");
  }

  editingComplete() async {
    final List<BaseStickerItem> stickerList = stickerElements.sublist(1);
    AudioStickerItem? audioSticker;
    if (hasAudioSticker) {
      audioSticker = getAudioSticker;
      stickerList.remove(getAudioSticker);
    }
    final Storycontent storyContent = Storycontent(
        isLocal: storyPost == null,
        mediaFileUrl: mediaFile,
        storyThumbnail: (await generateThumbnailImage()).path,
        mediaSticker: stickerElements.first as MainMediaStickerItem,
        audioSticker: audioSticker,
        bgTopColor: bgColors?[0] ?? Colors.grey,
        bgBottomColor: bgColors?[1] ?? Colors.grey,
        stickers: stickerList);
    // log(storyContent.toJson().toString());
    // Get.to(
    //     () => VudeStoryViewer(content: storyContent, storyLoading: false.obs));
    onEditComplete.call(storyContent);
    stickerElements.clear();
  }

//Mentions
  RxBool mentionUsersLoading = false.obs;
  String tempSeachText = "";
  // Timer? _mentionTimer;
  onMentionSearch(String text) {
    if (text.isEmpty) return;
    int cursorIndex = textEditingController.selection.baseOffset;
    if (cursorIndex < 0) cursorIndex = 0;

    String trimText = text.substring(0, cursorIndex);
    final list = trimText.split(' ');
    if (list.last.startsWith('@')) {
      final mention = list.last.replaceAll('@', '');
      _toggleMention();
      searchMentionUser(mention);
    } else {
      bottomOption(BottomOption.text);
      return;
    }
  }

  onMentionSelect(MentionUser user) {
    int cursorIndex = textEditingController.selection.baseOffset;
    String text = textEditingController.text;
    int mentionStartIndex = text.lastIndexOf('@', cursorIndex - 1) + 1;
    int mentionEndIndex = text.indexOf(' ', cursorIndex);
    if (mentionEndIndex == -1) mentionEndIndex = text.length;
    String newText =
        text.replaceRange(mentionStartIndex, mentionEndIndex, '${user.name} ');

    textEditingController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
            offset: mentionStartIndex + user.name.length + 1));
  }

  _toggleMention() {
    bottomOption.value = BottomOption.mention;
    // 'timer toggle'.logPrint;
    // _mentionTimer?.cancel();
    // _mentionTimer = Timer(const Duration(seconds: 5), () {
    // bottomOption.value = BottomOption.text;
    // 'toggling timer done'.logPrint;
    // });
  }

  searchMentionUser(String query) {
    _toggleMention();
    if (query == tempSeachText) return;
    tempSeachText = query;
    getMentionUsers(query);
  }

  getMentionUsers(String query) async {
    mentionUsersLoading(true);
    debouncer.run(
      () async {
        mentionUsers(await getMentionUsersCallBack.call(query));
        if (mentionUsers.isEmpty) bottomOption(BottomOption.text);
        log('mentionUsers:$mentionUsers');
      },
    );
    mentionUsersLoading(false);
  }

  //Location
  getLocation({bool coloredSticker = false}) async {
    final String? location = await getLocationCallBack.call();
    if (location == null) return;
    log('location::$location');
    stickerElements.add(coloredSticker
        ? ColoredTextStickerItem(
            position: const Offset(.5, .5).obs,
            rotation: 0.0.obs,
            scale: 1.0.obs,
            editMode: true,
            stickerType: 'location',
            text: location.obs,
            decorationType: 1)
        : LocationStickerItem(
            position: const Offset(.5, .5).obs,
            rotation: 0.0.obs,
            scale: 1.0.obs,
            editMode: true,
            location: location,
            decorationType: 1));
    update();
  }

  getBgBackground() async {
    final MainMediaStickerItem mediaSticker =
        stickerElements.first as MainMediaStickerItem;
    final ImageProvider image;
    if (mediaSticker.storyPost != null) {
      if (mediaSticker.mediaType == 'image') {
        image = NetworkImage(mediaSticker.mediaUrl);
      } else {
        image = FileImage(File(await ThumbnailUtils.getNetworkVideoThumbnail(
                mediaSticker.mediaUrl) ??
            ""));
      }
    } else {
      if (mediaSticker.mediaType == 'image') {
        image = FileImage(File(mediaFile));
      } else {
        image = FileImage(
            File(await ThumbnailUtils.getLocalVideoThumbnail(mediaFile) ?? ''));
      }
    }

    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(image);
    final Color color1 =
        paletteGenerator.mutedColor?.color ?? Colors.grey.shade700;
    final Color color2 =
        paletteGenerator.darkMutedColor?.color ?? Colors.blueGrey.shade700;
    bgColors = [color1, color2].obs;
    update();
    log('getBg $color1::$color2');
    log('getBg list isEmpty: ${bgColors == null}');
  }

  //image painting
  final GlobalKey mainImageBoundaryKey = GlobalKey();
  Future<File> generateThumbnailImage() async {
    final boundary = mainImageBoundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    final image = await boundary!.toImage(pixelRatio: 1);
    final directory = (await getApplicationDocumentsDirectory()).path;
    final byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    final pngBytes = byteData.buffer.asUint8List();
    final imgFile = File('$directory/${DateTime.now()}.png');
    await imgFile.writeAsBytes(pngBytes);
    return imgFile;
  }

  void onScaleStart(ScaleStartDetails details) {
    if (activeItem == null) return;
    initPos = details.focalPoint;
    currentPos = activeItem!.position.value;
    currentScale = activeItem!.scale.value;
    currentRotation = activeItem!.rotation.value;
    log('initPos: $initPos, currentScale: $currentScale,currentRotation: $currentRotation');
  }

  void onScaleUpdate(ScaleUpdateDetails details, BoxConstraints constraints) {
    // 'maxWidth: ${constraints.maxWidth}, maxHieght: ${constraints.maxHeight}'.log();
    if (activeItem == null) return;
    if (activeItem!.isMedia && details.pointerCount < 2) return;
    final delta = details.focalPoint - initPos;
    final left = (delta.dx / constraints.maxWidth) + currentPos.dx;
    final top = (delta.dy / constraints.maxHeight) + currentPos.dy;
    // log('top:$top, left:$left');
    final Offset pointer = details.localFocalPoint;
    if (_isDeletePosition(constraints, pointer)) {
      log('Delete Position❗');
      isDeletePosition(true);
      activeItem!.isDeletePosition(true);
      _showHapticFeedBack();
    } else {
      _showedHapticFeedBack = false;
      activeItem!.isDeletePosition(false);
      isDeletePosition(false);
    }
    activeItem!.position(Offset(left, top));
    final scale = (details.scale * currentScale).clamp(1, 10).toDouble();
    activeItem!.rotation(details.rotation + currentRotation);
    activeItem!.scale(scale);
    update();
  }

  bool _showedHapticFeedBack = false;
  _showHapticFeedBack() {
    if (_showedHapticFeedBack) return;
    _showedHapticFeedBack = true;
    HapticFeedback.lightImpact();
  }

  onElementPointerUp(PointerUpEvent e, BaseStickerItem item) {
    if (!item.editMode) return;
    log('onElementPointerUp');
    inAction(false);
    isDeletePosition(false);
    // if (activeItem == null) return;
    showDeleteIcon(false);
    activeItem = null;
    if (!item.isMedia) {
      if (!stickerElements.remove(item)) return;
      if (item.isDeletePosition.isFalse) {
        stickerElements.add(item);
      } else {
        if (item is AudioStickerItem) {
          mainAudioPlayer.stop();
          mainAudioTrack.value = null;
        }
      }
    }
    log('${activeItem != null}', name: 'activeItem');
    update();
  }

  onElementPointerDown(PointerDownEvent e, BaseStickerItem item) {
    if (inAction.value || !item.editMode) return;
    inAction(true);
    activeItem = item;
    initPos = e.position;
    currentScale = item.scale.value;
    currentRotation = item.rotation.value;
    log('${activeItem != null}', name: 'activeItem');
    update();
  }

  onElementPointerMove(PointerMoveEvent e, BaseStickerItem item,
      BuildContext context, BoxConstraints constraints) {
    if (item.isMedia || !item.editMode) return;
    showDeleteIcon(true);
    update();
  }

  bool _isDeletePosition(BoxConstraints constraints, Offset pointer) {
    final double left = pointer.dx / constraints.maxWidth;
    final double top = pointer.dy / constraints.maxHeight;
    // log('left $left, top $top');

    return left > .45 && left <= .55 && top > .9 && top <= .98;
  }

  void onScreenTap() {
    activeItem = null;
  }

  // TextEditing
  TextStickerItem? editTextItem;
  Rx<BottomOption> bottomOption = BottomOption.text.obs;

  addTextSticker(TextStickerItem item) {
    if (item.text.isEmpty) return;
    stickerElements.add(item);
    log(item.toString());
    update();
  }

// Audio
  RxList<AudioTrack> audioTracks = <AudioTrack>[].obs;
  RxBool audioLoading = false.obs;
  AudioPlayer mainAudioPlayer = AudioPlayer();
  AudioPlayer currentAudioPlayer = AudioPlayer();
  Rxn<AudioTrack> mainAudioTrack = Rxn();
  Rxn<AudioTrack> currentAudioTrack = Rxn();
  bool get hasAudioSticker =>
      stickerElements.any((element) => element is AudioStickerItem);
  AudioStickerItem get getAudioSticker =>
      (stickerElements.firstWhere((element) => element is AudioStickerItem)
          as AudioStickerItem);

  onAudioSearch(String query) async {
    if (currentAudioPlayer.playing) {
      currentAudioPlayer.stop();
      currentAudioTrack.value = null;
    }
    audioLoading(true);
    audioTracks(await audioSearchCallBack.call(query));
    audioLoading(false);
    log(audioTracks.toString());
  }

  setMainAudio(AudioTrack track) {
    if (track.mp3 == null) return;
    if (currentAudioPlayer.playing) {
      currentAudioPlayer.stop();
    }
    mainAudioTrack.value = track;
    mainAudioPlayer.setUrl(track.mp3!);
    mainAudioPlayer.setLoopMode(LoopMode.all);
    mainAudioPlayer.play();
    if (hasAudioSticker) {
      getAudioSticker.audioName = track.title;
      getAudioSticker.audioUrl = track.mp3!;
    } else {
      stickerElements.add(
          AudioStickerItem.new_(audioName: track.title, audioUrl: track.mp3!));
      update();
    }
    log(mainAudioTrack.toString());
    Get.back();
  }

  setCurrentAudio(AudioTrack track) {
    if (track.mp3 == null) return;
    currentAudioTrack.value = track;
    currentAudioPlayer.setUrl(track.mp3!);
    currentAudioPlayer.setLoopMode(LoopMode.all);
    if (mainAudioPlayer.playing) {
      mainAudioPlayer.pause();
    }
    currentAudioPlayer.play();
    update();
  }

  toggleCurrentAudio(AudioTrack track) {
    if (currentAudioTrack.value != track) {
      setCurrentAudio(track);
      return;
    }
    if (currentAudioPlayer.playing) {
      currentAudioPlayer.stop();
    } else {
      currentAudioPlayer.play();
    }
  }

//GIF
  FocusNode searchFocusNode = FocusNode();
  TextEditingController searchTextController = TextEditingController();
  RxBool gifTrendingLoading = false.obs;
  RxBool gifSearchLoading = false.obs;
  RxList<GiphySearchItem> trendingGifs = <GiphySearchItem>[].obs;
  RxList<GiphySearchItem> gifSearchResults = <GiphySearchItem>[].obs;
  RxBool showTrendingGifs = true.obs;
  getTrendingGifs() async {
    if (trendingGifs.isNotEmpty) return;
    final url =
        ApiConstants.giphyBaseUrl + ApiEndPoints.giphyTrending(giphyKey);
    gifTrendingLoading(true);
    await ApiServices()
        .getMethod(url)
        .then((value) {
          // prettyLog(value.data);
          trendingGifs(List.from((value.data['data'] as List)
              .map((e) => GiphySearchItem.fromJson(e))));
        })
        .whenComplete(() => gifTrendingLoading(false))
        .onError((error, stackTrace) {
          log('', error: error, stackTrace: stackTrace);
        });
  }

  onSearchGifs(String query) async {
    gifSearchLoading(true);
    final String url =
        ApiConstants.giphyBaseUrl + ApiEndPoints.giphySearch(giphyKey, query);
    ApiServices().getMethod(url).then((value) {
      gifSearchResults(List.from((value.data['data'] as List)
          .map((e) => GiphySearchItem.fromJson(e))));
    }).whenComplete(() => gifSearchLoading(false));
  }

  // Bubble reaction
  RxString selectedBubbleEmoji = '😍'.obs;
  List<String> recommentedBubbleEmojis = ['😍', '😂', '😯', '😢'];
  List<Emoji> emojiList = <Emoji>[];

  getEmojis() async {
    emojiList = emojies;
    update();
  }

  searchEmojis(String query) async {
    debouncer.run(() {
      emojiList = emojies
          .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      update();
    });
  }
}
