import 'package:ecommerce_app/core/Routes/base_routs.dart';
import 'package:ecommerce_app/core/app/screen/no_route.dart';
import 'package:ecommerce_app/model/get_all_prudict.dart';
import 'package:ecommerce_app/presentation/page/catogares/car_care.dart';
import 'package:ecommerce_app/presentation/page/my_requset_Screen.dart';
import 'package:ecommerce_app/presentation/page/services_car/Maintenan_car/welcome_bage.dart';
import 'package:ecommerce_app/presentation/page/catogares/parts.dart';
import 'package:ecommerce_app/presentation/page/auth/login.dart';
import 'package:ecommerce_app/presentation/page/auth/sinup.dart';
import 'package:ecommerce_app/presentation/page/catogares/screen.dart';
import 'package:ecommerce_app/presentation/page/home.dart';
import 'package:ecommerce_app/presentation/page/prudcit_detils.dart';
import 'package:ecommerce_app/presentation/page/services_car/integrated_parts.dart';
import 'package:ecommerce_app/presentation/page/services_car/obd_services_car/obd.dart';
import 'package:ecommerce_app/presentation/page/services_car/quick_diagnostic.dart';
import 'package:ecommerce_app/presentation/page/services_car/servises_page.dart';
import 'package:ecommerce_app/presentation/page/services_car/winch_requset.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppRoutes {
  static const String login = 'login';
  static const String sinup = "sinup";
  static const String prudicDetils = "prudicDetils";
  static const String home = "home";
  static const String adress = "adress";
  static const String parts = "parts";
  static const String screen = "screen";
  static const String carcare = "carcare";
  static const String servicescar = "carservisec";
  static const String carwifi = "carwifi";
  static const String winchRequest = "winchRequest";
  static const String quickDiagnostic = "QuickDiagnostic";
  static const String obdblutos = " static const Strin";
  static const String integratedParts = "integratedParts";
  static const String myRequsetScreen = "MyRequsetScreen";
  Route onGneratRouts(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return BaseRoute(page: Login());
      case sinup:
        return BaseRoute(page: SinUp());
      case prudicDetils:
        final PrudctModel arg = settings.arguments as PrudctModel;
        return BaseRoute(page: PrudcitDetils(data: arg));
      case home:
        return BaseRoute(page: Home());
      case parts:
        return BaseRoute(page: Parts());
      case screen:
        return BaseRoute(page: Screen());
      case carcare:
        return BaseRoute(page: CarCare());
      case servicescar:
        return BaseRoute(page: ServicesPage());
      case carwifi:
        return BaseRoute(page: WelcomePage());
      case winchRequest:
        return BaseRoute(page: (WinchRequest()));
      case quickDiagnostic:
        return BaseRoute(page: (QuickDiagnostic()));
      case obdblutos:
        return BaseRoute(page: (OBDHomePage()));
      case integratedParts:
        return BaseRoute(page: (IntegratedParts()));
      case myRequsetScreen:
        return BaseRoute(page: (MyRequsetScreen()));
      default:
        return BaseRoute(page: NoRoute());
    }
  }
}
