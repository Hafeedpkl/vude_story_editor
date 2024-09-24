import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SheetThumbWidget extends StatelessWidget {
  const SheetThumbWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(10)),
        width: context.width * .1,
        height: 5,
      ),
    );
  }
}
