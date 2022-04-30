class VehicleModel {
  String registrationNumber = "", vehicleType = "";

  VehicleModel({
    this.registrationNumber = "",
    this.vehicleType = "",
  });

  VehicleModel.fromMap(Map<String, dynamic> map) {
    registrationNumber = map['registrationNumber']?.toString() ?? "";
    vehicleType = map['vehicleType']?.toString() ?? "";
  }

  void updateFromMap(Map<String, dynamic> map) {
    registrationNumber = map['registrationNumber']?.toString() ?? "";
    vehicleType = map['vehicleType']?.toString() ?? "";
  }

  Map<String, dynamic> tomap() {
    return {
      "registrationNumber" : registrationNumber,
      "vehicleType" : vehicleType,
    };
  }

  @override
  String toString() {
    return "registrationNumber:${registrationNumber}, vehicleType:$vehicleType";
  }
}