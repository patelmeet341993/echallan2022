import 'package:echallan2022/configs/constants.dart';
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
      //DocumentSnapshot<Map<String, dynamic>> dataSnapshot = await FirestoreController().firestore.collection('users').doc(uid).get();

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
      /*Map<String, dynamic> data = {
        "ClientId" : clientModel.ClientId,
      };*/
      //if(clientModel.ClientPhoneNo.isNotEmpty) data['ClientPhoneNo'] = clientModel.ClientPhoneNo;
      //if(clientModel.ClientEmailId.isNotEmpty) data['ClientEmailId'] = clientModel.ClientEmailId;
      //data.remove("ClientId");
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
}