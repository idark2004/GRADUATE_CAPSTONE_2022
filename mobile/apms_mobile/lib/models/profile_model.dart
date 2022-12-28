class ProfileModel {
  String id, phoneNumber, fullName;
  double accountBalance;

  ProfileModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        phoneNumber = json["phoneNumber"],
        fullName = json["fullName"],
        accountBalance = json["accountBalance"] + .0;

  Map<String, dynamic> toJson() => {
        "id": id,
        "phoneNumber": phoneNumber,
        "fullName": fullName,
        "accountBalance": accountBalance
      };
}
