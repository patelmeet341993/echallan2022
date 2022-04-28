import 'package:cached_network_image/cached_network_image.dart';
import 'package:echallan2022/controllers/user_controller.dart';
import 'package:echallan2022/models/challan_model.dart';
import 'package:echallan2022/screens/common/components/app_bar.dart';
import 'package:echallan2022/utils/SizeConfig.dart';
import 'package:echallan2022/utils/my_print.dart';
import 'package:echallan2022/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class VehicleChallanListScreen extends StatefulWidget {
  static const String routeName = "/VehicleChallanListScreen";

  final String vehicleNumber;

  VehicleChallanListScreen({Key? key, required this.vehicleNumber}) : super(key: key);

  @override
  State<VehicleChallanListScreen> createState() => _VehicleChallanListScreenState();
}

class _VehicleChallanListScreenState extends State<VehicleChallanListScreen> {
  late Future<List<ChallanModel>> futureGetData;

  @override
  void initState() {
    futureGetData = UserController().getChallansFromVehicleId(widget.vehicleNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Styles.background,
          body: Column(
            children: [
              MyAppBar(title: "Challans List", backbtnVisible: true, color: Colors.white,),
              Expanded(
                child: FutureBuilder(
                  future: futureGetData,
                  builder: (BuildContext context, AsyncSnapshot<List<ChallanModel>> snapshot) {
                    if(snapshot.connectionState == ConnectionState.done) {
                      return getChallansListView(snapshot.data ?? []);
                    }
                    else {
                      return const Center(child: SpinKitFadingCircle(color: Styles.primaryColor,),);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getChallansListView(List<ChallanModel> list) {
    if(list.isEmpty) {
      return const Center(child: Text("No Challans"),);
    }
    else {
      return RefreshIndicator(
        onRefresh: () async {
          futureGetData = UserController().getChallansFromVehicleId(widget.vehicleNumber);
          setState(() {});
        },
        color: Styles.primaryColor,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return getChallanCard(list[index]);
          },
        ),
      );
    }
  }

  Widget getChallanCard(ChallanModel challanModel) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(challanModel.imageUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: challanModel.imageUrl,
                  width: MediaQuery.of(context).size.width * 0.6,
                  fit: BoxFit.contain,
                ),
            ],
          ),
          SizedBox(height: MySize.size5!,),
          Text("Challan Id:${challanModel.challanId}", style: TextStyle(fontSize: MySize.size12!),),
          SizedBox(height: MySize.size5!,),
          Text("Registration Number:${challanModel.registrationNumber}", style: TextStyle(fontSize: MySize.size20!),),
          SizedBox(height: MySize.size5!,),
          Text("Amount:${challanModel.amount}", style: TextStyle(fontSize: MySize.size12!),),
          Visibility(
            visible: challanModel.createdTime != null,
            child: Column(
              children: [
                SizedBox(height: MySize.size5!,),
                Text("Time:- ${DateFormat("hh:mm:ss aa, dd-MM-yyyy").format(challanModel.createdTime!)}", style: TextStyle(fontSize: MySize.size12!),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
