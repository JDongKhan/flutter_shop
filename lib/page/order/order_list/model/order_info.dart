class OrderInfo {
  String? orderNo;
  String? price;
  String? productName;
  String? productNum;
  String? status;
  String? image;

  OrderInfo({
    this.orderNo,
    this.price,
    this.productName,
    this.productNum,
    this.status,
    this.image,
  });

  OrderInfo.fromJson(dynamic json) {
    orderNo = json['orderNo'];
    price = json['price'];
    productName = json['productName'];
    productNum = json['productNum'];
    status = json['status'];
    image = json['image'];
  }
}
