import 'package:flutter/material.dart';
import 'package:echallan2022/screens/common/components/app_bar.dart';
import 'package:echallan2022/utils/styles.dart';

class CreateVehicleScreen extends StatefulWidget {
  static const String routeName = "/CreateVehicleScreen";

  const CreateVehicleScreen({Key? key}) : super(key: key);

  @override
  _CreateVehicleScreenState createState() => _CreateVehicleScreenState();
}

class _CreateVehicleScreenState extends State<CreateVehicleScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Styles.background,
          body: Column(
            children: [
              MyAppBar(title: "Create Post", backbtnVisible: true, color: Colors.white,),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      getImageSelectionListWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getImageSelectionListWidget() {
    return Container();
  }
}
