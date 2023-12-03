import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'model/order_model.dart';

void showToast(String msg, {BuildContext? context}) {
  final scaffold = ScaffoldMessenger.of(context ?? Get.context!);
  scaffold.showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 2000),
      content: Text(msg),
      action: SnackBarAction(label: "OK", textColor: Colors.blueAccent, onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

Widget labelTest (String text, {bool bold = false}) {
  return Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),);
}

Widget listViewBuilderStatus (List<OrderModel> list) {
  return Expanded(
    child: SizedBox(
      height: Get.height * 0.27,
      child: ListView.builder(
          shrinkWrap: true,
          // padding: const EdgeInsets.symmetric(horizontal: 30),
          itemCount: list.length,
          itemBuilder: (context, index) => labelTest(list[index].orderNumber + (list[index].botCode == '' ? '' : ' - ${list[index].botCode}'))),
    ),
  );
}

Widget themeButton(String text, onTapCallBack, AutoSizeGroup autoSizeGroup,
    {Widget? iconWidget, EdgeInsets padding = EdgeInsets.zero, double fontSize = 19, double height = 70, double? width = double.infinity, Color color = Colors.blueAccent}) {
  return InkWell(
    onTap: onTapCallBack,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: ThemeColor.mainDark),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget ?? const Center(),
          iconWidget == null ? const Center() : const SizedBox(width: 8),
          AutoSizeText(
            text,
            style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.w600),
            group: autoSizeGroup,
            minFontSize: 8,
            maxFontSize: 16,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}