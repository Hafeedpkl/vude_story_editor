import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vude_story_editor/src/core/constants.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(this.data,
      {super.key,
      this.textAlign,
      this.overflow,
      this.textScaler,
      this.maxLines,
      this.color,
      this.fontWeight,
      this.fontSize,
      this.fontStyle,
      this.fontFamily,
      this.style,
      this.height,
      this.package});

  final String data;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final TextStyle? style;
  final double? height;
  final String? package;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      key: key,
      style: style ??
          TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              fontFamily: fontFamily,
              height: height,
              package: package),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      textScaler: textScaler,
    );
  }
}

class SvgIcon extends StatelessWidget {
  final String path;
  final double? size;
  final Color? color;

  const SvgIcon(this.path, {super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    final child = SvgPicture.asset(
      path,
      fit: BoxFit.contain,
      height: size,
      width: size,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
    return size == null
        ? child
        : SizedBox(width: size, height: size, child: child);
  }
}

class SvgButton extends StatelessWidget {
  const SvgButton(
      {super.key,
      required this.icon,
      required this.onPressed,
      this.iconSize,
      this.iconColor,
      this.padding});

  final String icon;
  final VoidCallback onPressed;
  final double? iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
          color: Colors.transparent,
          padding: padding,
          child: SvgIcon(icon, size: iconSize, color: iconColor)),
    );
  }
}

SizedBox hSpace(double width) {
  return SizedBox(width: width);
}

SizedBox vSpace(double hieght) {
  return SizedBox(height: hieght);
}

class GradientShade extends StatelessWidget {
  const GradientShade({super.key, required this.gradient, required this.child});
  final Gradient gradient;
  final Widget child;
  @override
  Widget build(Object context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient
          .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: child,
    );
  }
}

Widget annotedRegionLightIcon({required Widget child, Color? statusBarColor}) =>
    AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: child,
    );

class TestContainer extends StatelessWidget {
  const TestContainer({super.key, this.color});
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            border: Border.all(
          color: color ?? themeColor,
        )),
        child: Center(
          child: Icon(
            Icons.add,
            color: color ?? themeColor,
          ),
        ),
      ),
    );
  }
}
