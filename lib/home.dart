import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:feedme_home_assignment/model/bot_model.dart';
import 'package:feedme_home_assignment/model/order_model.dart';
import 'package:feedme_home_assignment/reuseable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}

class HomeController extends GetxController {
  Timer? timer;
  var myGroup = AutoSizeGroup();
  List<OrderModel> orderList = [];
  List<BotModel> botList = [];

  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // assign order to bot
      for (var idleBot in botList.where((element) => element.orderNumber == '')) {
        if (orderList.where((element) => element.status == 'pending').isNotEmpty) {
          idleBot.orderNumber = orderList[orderList.indexWhere((element) => element.status == 'pending')].orderNumber;
          idleBot.timer = 10;
          orderList[orderList.indexWhere((element) => element.status == 'pending')].botCode = idleBot.botCode;
          orderList[orderList.indexWhere((element) => element.status == 'pending')].status = 'processing';
        }
      }
      // update bot's timer and status
      for (var bot in botList) {
        if (bot.timer == 0 && bot.orderNumber.isNotEmpty) {
          orderList[orderList.indexWhere((element) => element.orderNumber == bot.orderNumber)].status = 'completed';
          orderList[orderList.indexWhere((element) => element.orderNumber == bot.orderNumber)].botCode = '';
          bot.orderNumber = '';
          bot.timer = 0;
        } else if (bot.orderNumber.isNotEmpty) {
          bot.timer--;
        }
      }
      update();
    });
  }

  void onAddBot() {
    botList.add(BotModel('B${botList.length + 1}', '', 0));
    update();
  }

  void onRemoveBot() {
    if (botList.isNotEmpty) {
      if (orderList.isNotEmpty) {
        orderList[orderList.indexWhere((element) => element.orderNumber == botList[botList.length - 1].orderNumber)].status = 'pending';
        orderList[orderList.indexWhere((element) => element.orderNumber == botList[botList.length - 1].orderNumber)].botCode = '';
      }
      botList.removeLast();
    } else {
      showToast('These is no bots online.');
    }
  }

  void newNormalOrder() {
    if (botList.isNotEmpty) {
      orderList.add(OrderModel('Z${(orderList.length + 1).toString().padLeft(2, '0')}NOM', DateTime.now(), false, 'pending', ''));
      orderSorting();
    } else {
      showToast('These is no bots online.');
    }
  }

  void newVIPOrder() {
    if (botList.isNotEmpty) {
      orderList.add(OrderModel('A${(orderList.length + 1).toString().padLeft(2, '0')}VIP', DateTime.now(), false, 'pending', ''));
      orderSorting();
    } else {
      showToast('These is no bots online.');
    }
  }

  void orderSorting() {
    // orderList.sort((b, a) => a.isVIP.toString().toLowerCase().compareTo(b.isVIP.toString().toLowerCase()));
    orderList.sort((a, b) {
      int cmp = a.isVIP.toString().compareTo(b.isVIP.toString());
      if (cmp != 0) return cmp;
      return a.orderNumber.compareTo(b.orderNumber);
    });
    update();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
          builder: (ctrl) => SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: Get.height * 0.35,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 1),
                            blurRadius: 3,
                          )
                        ]),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(flex: 1, child: labelTest('Bot', bold: true)),
                            Expanded(flex: 3, child: labelTest('Order Number', bold: true)),
                            Expanded(flex: 1, child: labelTest('Timer', bold: true)),
                          ],
                        ),
                        const Divider(),
                        SizedBox(
                          height: Get.height * 0.27,
                          child: ListView.builder(
                              shrinkWrap: true,
                              // padding: const EdgeInsets.symmetric(horizontal: 30),
                              itemCount: ctrl.botList.length,
                              itemBuilder: (context, index) => Row(
                                children: [
                                  Expanded(flex: 1, child: labelTest(ctrl.botList[index].botCode)),
                                  Expanded(flex: 3, child: labelTest(ctrl.botList[index].orderNumber)),
                                  Expanded(flex: 1, child: labelTest('${ctrl.botList[index].timer}s')),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: Get.height * 0.35,
                    // width: Get.width,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 1),
                            blurRadius: 3,
                          )
                        ]),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: labelTest('Pending', bold: true)),
                            Expanded(child: labelTest('Processing', bold: true)),
                            Expanded(child: labelTest('Completed', bold: true)),
                          ],
                        ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            listViewBuilderStatus(ctrl.orderList.where((element) => element.status == 'pending').toList()),
                            listViewBuilderStatus(ctrl.orderList.where((element) => element.status == 'processing').toList()),
                            listViewBuilderStatus(ctrl.orderList.where((element) => element.status == 'completed').toList()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: themeButton('+ Bot', ctrl.onAddBot, ctrl.myGroup)),
                            Expanded(child: themeButton('- Bot', ctrl.onRemoveBot, ctrl.myGroup)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: themeButton('New Normal Order', ctrl.newNormalOrder, ctrl.myGroup)),
                            Expanded(child: themeButton('New VIP Order', ctrl.newVIPOrder, ctrl.myGroup)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

}