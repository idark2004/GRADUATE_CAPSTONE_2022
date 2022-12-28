class TopupModel {
  int price;

  TopupModel({required this.price});

  TopupModel.fromJson(Map<String, dynamic> json) : price = json["price"];
}
