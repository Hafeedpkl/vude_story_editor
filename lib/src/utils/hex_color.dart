import 'dart:ui';

class HexColor extends Color {
  final String _hex;
  int? _getColor() {
    String formattedHex = "FF${_hex.toUpperCase().replaceAll("#", "")}";
    return int.tryParse(formattedHex, radix: 16);
  }

  @override
  int get value => _getColor() ?? 4294967295;
  Color get color => HexColor(_getColor().toString());
  HexColor(this._hex) : super(0);
}
