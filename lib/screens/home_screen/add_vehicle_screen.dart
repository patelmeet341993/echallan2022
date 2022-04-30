import 'package:echallan2022/controllers/navigation_controller.dart';
import 'package:echallan2022/controllers/providers/user_provider.dart';
import 'package:echallan2022/controllers/user_controller.dart';
import 'package:echallan2022/models/vehicle_model.dart';
import 'package:echallan2022/screens/common/components/modal_progress_hud.dart';
import 'package:echallan2022/utils/SizeConfig.dart';
import 'package:echallan2022/utils/my_print.dart';
import 'package:echallan2022/utils/snakbar.dart';
import 'package:flutter/material.dart';
import 'package:echallan2022/screens/common/components/app_bar.dart';
import 'package:echallan2022/utils/styles.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AddVehicleScreen extends StatefulWidget {
  static const String routeName = "/CreateVehicleScreen";

  const AddVehicleScreen({Key? key}) : super(key: key);

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  bool isLoading = false;

  TextEditingController registrationNumberController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedType;

  List<String> vehicleTypes = ["Two Wheeler", "Three Wheeler", "Four Wheeler"];

  Future<void> addVehicle() async {
    setState(() {
      isLoading = true;
    });

    String registrationNumber = registrationNumberController.text;
    String type = selectedType!;

    VehicleModel vehicleModel = VehicleModel(registrationNumber: registrationNumber, vehicleType: type);
    bool isAdded = await UserController().addVehicle(vehicleModel);

    setState(() {
      isLoading = false;
    });

    if(isAdded) {
      Snakbar().show_success_snakbar(context, "Vehicle Added");

      UserProvider userProvider = Provider.of<UserProvider>(NavigationController().mainAppKey.currentContext!, listen: false);
      userProvider.vehiclesList.add(vehicleModel);
      userProvider.notifyListeners();

      Navigator.pop(context);
    }
    else {
      Snakbar().show_error_snakbar(context, "Vehicle Not Added");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Container(
        color: Styles.background,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Styles.background,
            body: Column(
              children: [
                MyAppBar(title: "Add Vehicle", backbtnVisible: true, color: Colors.white,),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getRegistrationNumberTextField(),
                          getTypeDropdown(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getSaveButton(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getRegistrationNumberTextField()  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: TextFormField(
        controller: registrationNumberController,
        validator: (val) {
          if(val?.isEmpty ?? true) {
            return "Registration Number Cannot be empty";
          }
          else{
            return null;
          }
        },
        decoration: getTextFieldInputDecoration(hintText: "Registration Number", fillColor: Colors.white).copyWith(
          prefixIcon: Container(padding: EdgeInsets.symmetric(horizontal: MySize.size20!,), child: Icon(Icons.car_repair, size: MySize.size20,)),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        ),
        style: const TextStyle(
          letterSpacing: 0.1,
          color: Styles.onBackground,
          fontWeight: FontWeight.w500,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(50),
        ],
      ),
    );
  }

  Widget getTypeDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: DropdownButton<String>(
        value: selectedType,
        items: vehicleTypes.map((e) {
          return DropdownMenuItem<String>(
            child: Text(e),
            value: e,
          );
        }).toList(),
        onChanged: (String? newValue) {
          selectedType = newValue;
          setState(() {});
        },
        hint: const Text("Select Vehicle Type"),

      ),
    );
  }

  Widget getSaveButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: InkWell(
        onTap: () {
          bool isValidate = (_formKey.currentState?.validate() ?? false);
          MyPrint.printOnConsole("isValidate:${isValidate}");
          if(isValidate && selectedType != null) {
            MyPrint.printOnConsole("Valid");
            addVehicle();
          }
          else if(selectedType == null) {
            Snakbar().show_error_snakbar(context, "Vehicle Type Must Be Selected");
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: MySize.size20!, vertical: MySize.size10!),
          decoration: BoxDecoration(
            color: Styles.primaryColor,
            borderRadius: BorderRadius.circular(MySize.size5!),
          ),
          child: isLoading ? SpinKitThreeBounce(color: Colors.white, size: MySize.getScaledSizeHeight(17),) : Text("Save", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }

  InputDecoration getTextFieldInputDecoration({required String hintText, required Color fillColor}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        letterSpacing: 0.1,
        color: Styles.onBackground.withOpacity(0.7),
        fontWeight: FontWeight.w400,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: fillColor,
      isDense: true,
      contentPadding: const EdgeInsets.all(15),
    );
  }
}
