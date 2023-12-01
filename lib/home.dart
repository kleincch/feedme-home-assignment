import 'dart:async';

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

  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // assign order to bot
      for (var idleBot in dummyBot.where((element) => element.orderNumber == '')) {
        if (dummyOrderList.where((element) => element.status == 'pending').isNotEmpty) {
          idleBot.orderNumber = dummyOrderList[dummyOrderList.indexWhere((element) => element.status == 'pending')].orderNumber;
          idleBot.timer = 3;
          dummyOrderList[dummyOrderList.indexWhere((element) => element.status == 'pending')].botCode = idleBot.botCode;
          dummyOrderList[dummyOrderList.indexWhere((element) => element.status == 'pending')].status = 'processing';
        }
      }
      // update bot's timer and status
      for (var bot in dummyBot) {
        if (bot.timer == 0 && bot.orderNumber.isNotEmpty) {
          dummyOrderList[dummyOrderList.indexWhere((element) => element.orderNumber == bot.orderNumber)].status = 'completed';
          dummyOrderList[dummyOrderList.indexWhere((element) => element.orderNumber == bot.orderNumber)].botCode = '';
          bot.orderNumber = '';
          bot.timer = 0;
        } else if (bot.orderNumber.isNotEmpty) {
          bot.timer--;
        }
      }
      // dummyBot.removeWhere((element) => element.timer == -1);
      // update orders
      // push orders to bot
      update();
    });
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
                    margin: const EdgeInsets.all(20),
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
                        ListView.builder(
                            shrinkWrap: true,
                            // padding: const EdgeInsets.symmetric(horizontal: 30),
                            itemCount: dummyBot.length,
                            itemBuilder: (context, index) => Row(
                              children: [
                                Expanded(flex: 1, child: labelTest(dummyBot[index].botCode)),
                                Expanded(flex: 3, child: labelTest(dummyBot[index].orderNumber)),
                                Expanded(flex: 1, child: labelTest('${dummyBot[index].timer}s')),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    height: Get.height * 0.35,
                    // width: Get.width,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(20),
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
                            listViewBuilderStatus(dummyOrderList.where((element) => element.status == 'pending').toList()),
                            listViewBuilderStatus(dummyOrderList.where((element) => element.status == 'processing').toList()),
                            listViewBuilderStatus(dummyOrderList.where((element) => element.status == 'completed').toList()),
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