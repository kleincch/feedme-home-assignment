class OrderModel {
  String orderNumber;
  DateTime dateTime;
  bool isVIP;
  String status;
  String botCode;

  OrderModel(this.orderNumber, this.dateTime, this.isVIP, this.status, this.botCode);
}

List<OrderModel> dummyOrderList = [
  OrderModel('NOM1', DateTime.now().add(const Duration(minutes: -5)), false, 'pending', ''),
  OrderModel('NOM2', DateTime.now(), false, 'pending', ''),
  OrderModel('VIP3', DateTime.now().add(const Duration(minutes: 5)), true, 'pending', ''),
];