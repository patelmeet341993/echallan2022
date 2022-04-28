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
    createdTime = map['createdTime'];

    try {
      List<String> list = List.castFrom(map['myVehicles'] ?? []);
      myVehicles = list;
    }
    catch(e) {}

  }

  void updateFromMap(Map<String, dynamic> map) {
    id = map['id']?.toString() ?? "";
    name = map['name']?.toString() ?? "";
    image = map['image']?.toString() ?? "";
    email = map['email']?.toString() ?? "";
    createdTime = map['createdTime'];

    try {
      List<String> list = List.castFrom(map['myVehicles'] ?? []);
      myVehicles = list;
    }
    catch(e) {}

  }

  Map<String, dynamic> tomap() {
    return {
      "id" : id,
      "name" : name,
      "image" : image,
      "email" : email,
      "myVehicles" : myVehicles,
      "createdTime" : createdTime,
    };
  }

  @override
  String toString() {
    return "id:${id}, name:$name, image:$image, email:$email, myVehicles:$myVehicles, createdTime:${createdTime}";
  }
}