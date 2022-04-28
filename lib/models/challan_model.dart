class ChallanModel {
  String challanId = "", registrationNumber = "", imageUrl = "";
  DateTime? createdTime;
  double amount = 0;

  ChallanModel({
    this.challanId = "",
    this.registrationNumber = "",
    this.imageUrl = "",
    this.createdTime,
    this.amount = 0,
  });

  ChallanModel.fromMap(Map<String, dynamic> map) {
    challanId = map['challanId']?.toString() ?? "";
    registrationNumber = map['registrationNumber']?.toString() ?? "";
    imageUrl = map['imageUrl']?.toString() ?? "";
    amount = double.tryParse(map['amount']?.toString() ?? "0") ?? 0;
  }

  void updateFromMap(Map<String, dynamic> map) {
    challanId = map['challanId']?.toString() ?? "";
    registrationNumber = map['registrationNumber']?.toString() ?? "";
    imageUrl = map['imageUrl']?.toString() ?? "";
    amount = double.tryParse(map['amount']?.toString() ?? "0") ?? 0;
  }

  Map<String, dynamic> tomap() {
    return {
      "challanId" : challanId,
      "registrationNumber" : registrationNumber,
      "imageUrl" : imageUrl,
      "createdTime" : createdTime,
      "amount" : amount,
    };
  }

  @override
  String toString() {
    return "challanId:${challanId}, registrationNumber:${registrationNumber}, imageUrl:$imageUrl, createdTime:${createdTime}, "
        "amount:${amount}";
  }
}