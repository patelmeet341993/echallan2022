import 'package:flutter/material.dart';

class VehicleChallanListScreen extends StatefulWidget {
  static const String routeName = "/VehicleChallanListScreen";

  final String vehicleNumber;

  const VehicleChallanListScreen({Key? key, this.vehicleNumber = ""}) : super(key: key);

  @override
  State<VehicleChallanListScreen> createState() => _VehicleChallanListScreenState();
}

class _VehicleChallanListScreenState extends State<VehicleChallanListScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
