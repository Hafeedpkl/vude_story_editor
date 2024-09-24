enum BottomOption { mention, text, color }

enum BgDecoration {
  d1(1),
  d2(2),
  d3(3),
  d4(4);

  const BgDecoration(this.bgValue);
  final int bgValue;
}

enum FontFam {
  gilmer(name: 'Gilmer'),
  avenyT(name: 'aveny-t'),
  brutalType(name: 'brutal-type'),
  cosmopolitan(name: 'cosmopolitan'),
  courier(name: 'courier'),
  roboto(name: 'roboto'),
  comic(name: 'comic'),
  winslowBook(name: 'winslow-book'),
  fransisco(name: 'fransisco');

  const FontFam({required this.name});
  final String name;
}

enum PlaybackState { pause, play, next, previous }

enum LoadState { loading, success, failure }

enum StoryMediaType{image,video}

enum Direction { up, down, left, right }
