import 'package:echallan2022/screens/home_screen/vehicle_challan_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:echallan2022/screens/authentication/login_screen.dart';
import 'package:echallan2022/screens/home_screen/create_vehicle_screen.dart';
import 'package:echallan2022/screens/home_screen/main_page.dart';
import 'package:echallan2022/splash_screen.dart';
import 'package:echallan2022/utils/my_print.dart';

class NavigationController {
  GlobalKey<NavigatorState> mainAppKey = GlobalKey<NavigatorState>();

  Route? onGeneratedRoutes(RouteSettings routeSettings) {
    MyPrint.printOnConsole("OnGeneratedRoutes Called for ${routeSettings.name} with arguments:${routeSettings.arguments}");

    Widget? widget;

    switch(routeSettings.name) {
      case SplashScreen.routeName : {
        widget = const SplashScreen();
        break;
      }
      case LoginScreen.routeName : {
        widget = const LoginScreen();
        break;
      }
      case MainPage.routeName : {
        widget = const MainPage();
        break;
      }
      case CreateVehicleScreen.routeName : {
        widget = const CreateVehicleScreen();
        break;
      }
      case VehicleChallanListScreen.routeName : {
        widget = const VehicleChallanListScreen();
        break;
      }
      default : {
        widget = const SplashScreen();
      }
    }

    if(widget != null)return MaterialPageRoute(builder: (_) => widget!);
  }
}