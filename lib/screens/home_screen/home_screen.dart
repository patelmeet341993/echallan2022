import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:echallan2022/screens/common/components/app_bar.dart';
import 'package:echallan2022/utils/SizeConfig.dart';
import 'package:echallan2022/utils/my_print.dart';
import 'package:echallan2022/utils/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFirst = true, pageMounted = false;
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

    return Container(
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
    );
  }

  FloatingActionButton getFloatingButton() {
    return FloatingActionButton(
      onPressed: () {

      },
      child: Icon(Icons.add),
    );
  }
  
  Widget getMyVehiclesListViw() {
    return Container();
  }
}
