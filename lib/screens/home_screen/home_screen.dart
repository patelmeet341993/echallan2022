import 'dart:async';
import 'package:echallan2022/controllers/navigation_controller.dart';
import 'package:echallan2022/controllers/providers/user_provider.dart';
import 'package:echallan2022/controllers/user_controller.dart';
import 'package:echallan2022/models/vehicle_model.dart';
import 'package:echallan2022/screens/common/components/modal_progress_hud.dart';
import 'package:echallan2022/screens/home_screen/add_vehicle_screen.dart';
import 'package:echallan2022/screens/home_screen/vehicle_challan_list_screen.dart';
import 'package:echallan2022/utils/SizeConfig.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:echallan2022/screens/common/components/app_bar.dart';
import 'package:echallan2022/utils/styles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFirst = true, pageMounted = false, isLoading = false;
  late DatabaseReference _deviceRef;
  late StreamSubscription<DatabaseEvent> _deviceSubscription;

  List<String> videos = [];

  bool status = false;
  String text = "";

  Future<void> initSync() async {
    _deviceRef = FirebaseDatabase.instance.ref('device');

    _deviceSubscription = _deviceRef.onValue.listen((DatabaseEvent event) {
      print("Value:${event.snapshot.value}");
      try {
        Map<String, dynamic> map = Map.castFrom(event.snapshot.value as Map);
        text = map['data'] ?? "";
        status = (map['status'] ?? "") == "on" ? true : false;
        if(pageMounted) setState(() {});
      }
      catch(e) {

      }
    });
  }

  Future<void> deleteVehicle(VehicleModel vehicleModel) async {
    setState(() {
      isLoading = true;
    });

    bool isSuccess = await UserController().deleteVehicle(vehicleModel);

    setState(() {
      isLoading = false;
    });

    if(isSuccess) {
      UserProvider userProvider = Provider.of<UserProvider>(NavigationController().mainAppKey.currentContext!, listen: false);
      userProvider.vehiclesList.remove(vehicleModel);
      userProvider.notifyListeners();
    }
  }

  @override
  void initState() {
    initSync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pageMounted = false;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      pageMounted = true;
    });

    if(isFirst) {
      isFirst = false;
    }

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const SpinKitFadingCircle(color: Styles.primaryColor,),
      color: Colors.white,
      child: Container(
        color: Styles.background,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Styles.background,
            floatingActionButton: getFloatingButton(),
            body: Column(
              children: [
                MyAppBar(title: "Virtual Keyboard", backbtnVisible: false, color: Colors.white,),
                Expanded(
                  child: getMyVehiclesListViw(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton getFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, AddVehicleScreen.routeName);
      },
      child: const Icon(Icons.add),
    );
  }
  
  Widget getMyVehiclesListViw() {
    return Consumer<UserProvider>(
      builder: (BuildContext context, UserProvider userProvider, Widget? child) {
        if(userProvider.isVehiclesLoading) {
          return const Center(child: SpinKitFadingCircle(color: Styles.primaryColor,),);
        }
        else {
          if(userProvider.vehiclesList.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                UserController().getMyVehicles();
              },
              color: Styles.primaryColor,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: userProvider.vehiclesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return getVehicleCard(userProvider.vehiclesList[index]);
                },
              ),
            );
          }
          else {
            return const Center(child: Text("No Vehicles"),);
          }
        }
      },
    );
  }

  Widget getVehicleCard(VehicleModel vehicleModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MySize.size10!, vertical: MySize.size2!),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MySize.size5!),
      ),
      padding: EdgeInsets.symmetric(horizontal: MySize.size10!, vertical: MySize.size10!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Registration Number:${vehicleModel.registrationNumber}", style: TextStyle(fontSize: MySize.size20!),),
          SizedBox(height: MySize.size5!,),
          Text("Vehicle Type:${vehicleModel.vehicleType}", style: TextStyle(fontSize: MySize.size12!),),
          SizedBox(height: MySize.size5!,),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    deleteVehicle(vehicleModel);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(MySize.size5!),
                    ),
                    padding: EdgeInsets.symmetric(vertical: MySize.size6!),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.white, size: MySize.size20!,),
                          SizedBox(width: MySize.size5!,),
                          const Text("Delete", style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: MySize.size5!,),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, VehicleChallanListScreen.routeName, arguments: vehicleModel.registrationNumber);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(MySize.size5!),
                    ),
                    padding: EdgeInsets.symmetric(vertical: MySize.size6!),
                    child: const Center(
                      child: Text("Challans", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
