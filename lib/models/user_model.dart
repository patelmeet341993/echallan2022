class UserModel {
  String id = "", name = "", image = "", email = "";
  List<String> myVehicles = [];
  DateTime? createdTime;

  UserModel({
    this.id = "",
    this.name = "",
    this.image = "",
    this.email = "",
    this.myVehicles = const [],
    this.createdTime,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map['id']?.toString() ?? "";
    name = map['name']?.toString() ?? "";
    image = map['image']?.toString() ?? "";
    email = map['email']?.toString() ?? "";

    try {
      String timeString = (map['createdTime']?.toString() ?? "");
      if(timeString.isNotEmpty) {
        createdTime = DateTime.tryParse(timeString);
      }
    }
    catch(e) {}

    try {
      Map<String, dynamic> myVehiclesMap = Map.castFrom<dynamic, dynamic, String, dynamic>(map['myVehicles'] ?? []);
      myVehicles = myVehiclesMap.keys.toList();
    }
    catch(e) {}
  }

  void updateFromMap(Map<String, dynamic> map) {
    id = map['id']?.toString() ?? "";
    name = map['name']?.toString() ?? "";
    image = map['image']?.toString() ?? "";
    email = map['email']?.toString() ?? "";

    try {
      String timeString = (map['createdTime']?.toString() ?? "");
      if(timeString.isNotEmpty) {
        createdTime = DateTime.tryParse(timeString);
      }
    }
    catch(e) {}

    try {
      Map<String, dynamic> myVehiclesMap = Map.castFrom<dynamic, dynamic, String, dynamic>(map['myVehicles'] ?? []);
      myVehicles = myVehiclesMap.keys.toList();
    }
    catch(e) {}

  }

  Map<String, dynamic> tomap() {
    Map<String, dynamic> myVehiclesMap = {};
    myVehicles.forEach((element) {
      myVehiclesMap[element] = true;
    });

    return {
      "id" : id,
      "name" : name,
      "image" : image,
      "email" : email,
      "myVehicles" : myVehiclesMap,
      "createdTime" : createdTime.toString(),
    };
  }

  @override
  String toString() {
    return "id:${id}, name:$name, image:$image, email:$email, myVehicles:$myVehicles, createdTime:${createdTime}";
  }
}