import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'model/order_model.dart';

Widget labelTest (String text, {bool bold = false}) {
  return Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),);
}

Widget listViewBuilderStatus (List<OrderModel> list) {
  return Expanded(
    child: ListView.builder(
        shrinkWrap: true,
        // padding: const EdgeInsets.symmetric(horizontal: 30),
        itemCount: list.length,
        itemBuilder: (context, index) => labelTest(list[index].orderNumber + (list[index].botCode == '' ? '' : ' - ${list[index].botCode}'))),
  );
}
