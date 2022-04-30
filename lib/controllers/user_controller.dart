import 'package:echallan2022/configs/constants.dart';
import 'package:echallan2022/controllers/navigation_controller.dart';
import 'package:echallan2022/models/challan_model.dart';
import 'package:echallan2022/models/vehicle_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:echallan2022/controllers/providers/user_provider.dart';
import 'package:echallan2022/models/user_model.dart';
import 'package:echallan2022/utils/my_print.dart';
import 'package:provider/provider.dart';

class UserController {
  static UserController? _instance;

  factory UserController() {
    _instance ??= UserController._();
    return _instance!;
  }

  UserController._();

  Future<bool> isUserExist(BuildContext context, String uid) async {
    if(uid.isEmpty) return false;

    MyPrint.printOnConsole("Uid:${uid}");
    if(uid == null || uid.isEmpty) return false;

    bool isUserExist = false;

    try {
      DataSnapshot dataSnapshot = await FirebaseDatabase.instance.ref(USERS_NODE).child(uid).get();
      MyPrint.printOnConsole("dataSnapshot IsExist:${dataSnapshot.exists}");
      MyPrint.printOnConsole("dataSnapshot data:${dataSnapshot.value}");

      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      if(dataSnapshot.exists && dataSnapshot.value != null) {
        Map<String, dynamic> map = {};
        try {
          map = Map.castFrom<dynamic, dynamic, String, dynamic>(dataSnapshot.value as Map);
        }
        catch(e, s) {
          MyPrint.printOnConsole("Error in Converting User Data To Map:${e}");
          MyPrint.printOnConsole(s);
        }

        if(map.isNotEmpty) {
          UserModel userModel = UserModel.fromMap(map);
          userProvider.userModel = userModel;
          MyPrint.printOnConsole("User Model:${userProvider.userModel}");
          isUserExist = true;
        }
        else {
          isUserExist = false;
        }
      }
      else {
        UserModel userModel = UserModel(
          id: uid,
          name: userProvider.firebaseUser?.displayName ?? "",
          email: userProvider.firebaseUser?.email ?? "",
          image: userProvider.firebaseUser?.photoURL ?? "",
          createdTime: DateTime.now(),
        );
        bool isSuccess = await UserController().createUser(context, userModel);
        MyPrint.printOnConsole("Insert Client Success:${isSuccess}");
      }
    }
    catch(e) {
      MyPrint.printOnConsole("Error in UserController.isClientExist:${e}");
    }

    return isUserExist;
  }

  Future<bool> createUser(BuildContext context,UserModel userModel) async {
    try {
      Map<String, dynamic> data = userModel.tomap();

      await FirebaseDatabase.instance.ref(USERS_NODE).child(userModel.id).set(data);

      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.userModel = userModel;

      return true;
    }
    catch(e) {
      MyPrint.printOnConsole("Error in UserController.createUser:${e}");
    }

    return false;
  }

  Future<void> getMyVehicles() async {
    UserProvider userProvider = Provider.of<UserProvider>(NavigationController().mainAppKey.currentContext!, listen: false);

    if((userProvider.userModel?.myVehicles ?? []).isNotEmpty) {
      userProvider.vehiclesList.clear();
      userProvider.isVehiclesLoading = true;
      userProvider.notifyListeners();

      List<Future> futures = [];
      List<VehicleModel> vehicles = [];

      MyPrint.printOnConsole("Vehicles List:${(userProvider.userModel?.myVehicles ?? [])}");
      for (var element in (userProvider.userModel?.myVehicles ?? [])) {
        futures.add(FirebaseDatabase.instance.ref(VEHICLES_NODE).child(element).get().then((DataSnapshot dataSnapshot) {
          if(dataSnapshot.exists && dataSnapshot.value != null) {
            Map<String, dynamic> map = {};
            try {
              map = Map.castFrom<dynamic, dynamic, String, dynamic>(dataSnapshot.value as Map);
            }
            catch(e, s) {
              MyPrint.printOnConsole("Error in Converting User Data To Map:${e}");
              MyPrint.printOnConsole(s);
            }

            if(map.isNotEmpty) {
              VehicleModel vehicleModel = VehicleModel.fromMap(map);
              vehicles.add(vehicleModel);
              MyPrint.printOnConsole("vehicleModel:${vehicleModel}");
            }
          }
        })
        .catchError((e) {

        }));
      }

      await Future.wait(futures);

      userProvider.vehiclesList = vehicles;
      userProvider.isVehiclesLoading = false;
      userProvider.notifyListeners();
    }
    else {
      userProvider.vehiclesList.clear();
      userProvider.notifyListeners();
    }
  }
  
  Future<bool> addVehicle(VehicleModel vehicleModel) async {
    bool isSuccess = false;

    isSuccess = await FirebaseDatabase.instance.ref(VEHICLES_NODE).child(vehicleModel.registrationNumber).set(vehicleModel.tomap()).then((value) async {
      MyPrint.printOnConsole("Vehicle Document Added:${vehicleModel.registrationNumber}");

      UserProvider userProvider = Provider.of<UserProvider>(NavigationController().mainAppKey.currentContext!, listen: false);
      userProvider.userModel?.myVehicles.remove(vehicleModel.registrationNumber);
      userProvider.userModel?.myVehicles.add(vehicleModel.registrationNumber);

      bool isUpdateUserSuccess = await FirebaseDatabase.instance.ref(USERS_NODE).child(userProvider.userid).child("myVehicles").child(vehicleModel.registrationNumber).set(true).then((value) {
        MyPrint.printOnConsole("User Document Added:${vehicleModel.registrationNumber}");

        return true;
      })
      .catchError((e) {
        MyPrint.printOnConsole("Error in Adding User Document:${e}");

        return false;
      });

      return isUpdateUserSuccess;
    })
    .catchError((e) {
      MyPrint.printOnConsole("Error in Adding Vehicle Document:${e}");

      return false;
    });
    
    return isSuccess;
  }

  Future<bool> deleteVehicle(VehicleModel vehicleModel) async {
    bool isSuccess = false;

    isSuccess = await FirebaseDatabase.instance.ref(VEHICLES_NODE).child(vehicleModel.registrationNumber).remove().then((value) async {
      MyPrint.printOnConsole("Vehicle Document Deleted:${vehicleModel.registrationNumber}");

      UserProvider userProvider = Provider.of<UserProvider>(NavigationController().mainAppKey.currentContext!, listen: false);
      userProvider.userModel?.myVehicles.remove(vehicleModel.registrationNumber);

      bool isUpdateUserSuccess = await FirebaseDatabase.instance.ref(USERS_NODE).child(userProvider.userid).child("myVehicles").child(vehicleModel.registrationNumber).remove().then((value) {
        MyPrint.printOnConsole("User Document Updated:${vehicleModel.registrationNumber}");

        return true;
      })
          .catchError((e) {
        MyPrint.printOnConsole("Error in Updating User Document:${e}");

        return false;
      });

      return isUpdateUserSuccess;
    })
        .catchError((e) {
      MyPrint.printOnConsole("Error in Deleting Vehicle Document:${e}");

      return false;
    });

    return isSuccess;
  }

  Future<List<ChallanModel>> getChallansFromVehicleId(String vehicleId) async {
    List<ChallanModel> challans = [];

    DatabaseEvent databaseEvent = await FirebaseDatabase.instance.ref(CHALLANS_NODE).orderByChild("registrationNumber").equalTo(vehicleId).once();
    MyPrint.printOnConsole("Challans Length:${databaseEvent.snapshot.children.length}");

    databaseEvent.snapshot.children.forEach((DataSnapshot dataSnapshot) {
      if(dataSnapshot.exists && dataSnapshot.value != null) {
        Map<String, dynamic> map = {};
        try {
          map = Map.castFrom<dynamic, dynamic, String, dynamic>(dataSnapshot.value as Map);
        }
        catch(e, s) {
          MyPrint.printOnConsole("Error in Converting User Data To Map:${e}");
          MyPrint.printOnConsole(s);
        }

        if(map.isNotEmpty) {
          ChallanModel challanModel = ChallanModel.fromMap(map);
          challans.add(challanModel);
          MyPrint.printOnConsole("challanModel:${challanModel}");
        }
      }
    });

    return challans;
  }
}