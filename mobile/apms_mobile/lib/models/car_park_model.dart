class CarParkModel {
  String id, name, addressNumber, phoneNumber, street, ward, district, city;
  int availableSlotsCount, provinceId;
  double? distance;
  bool status;
  int? visitCount;

  CarParkModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        addressNumber = json["addressNumber"],
        phoneNumber = json["phoneNumber"],
        availableSlotsCount = json["availableSlotsCount"] as int,
        provinceId = json["provinceId"] as int,
        status = json["status"] == 0 ? true : false,
        street = json["street"],
        ward = json["ward"],
        district = json["district"],
        city = json["city"],
        distance = json["distance"],
        visitCount = json["visitCount"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "addressNumber": addressNumber,
        "phoneNumber": phoneNumber,
        "availableSlotsCount": availableSlotsCount,
        "provinceId": provinceId,
        "status": status,
        "stret": street,
        "ward": ward,
        "district": district,
        "city": city,
        "distance": distance,
        "visitCount": visitCount
      };
}

class CarParkSearchQuery {
  String? name;
  double? latitude, longitude;

  CarParkSearchQuery({name, latitude, longitude});

  CarParkSearchQuery copyWith(Map<String, dynamic> json) {
    return CarParkSearchQuery(
        name: json["name"] ?? name,
        latitude: json["latitude"] ?? latitude,
        longitude: json["longitude"] ?? longitude);
  }

  CarParkSearchQuery.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        latitude = json["latitude"],
        longitude = json["longitude"];
  Map<String, dynamic> toJson() => {
        "name": name,
        "latitude": latitude?.toString(),
        "longitude": longitude?.toString()
      };
}
