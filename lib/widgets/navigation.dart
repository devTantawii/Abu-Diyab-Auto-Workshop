import 'package:flutter/material.dart';
import '../screens/services/screen/change_battery.dart';
import '../screens/services/screen/change_oil.dart';
import '../screens/services/screen/change_tire.dart';
import '../screens/services/screen/washing.dart';
import '../screens/services/screen/car_check.dart';

void navigateToServiceScreen(BuildContext context, int? id, String title) {
  switch (id) {
    case 6:
      Navigator.push(context, MaterialPageRoute(builder: (_) => ChangeOil()));
      break;
    case 5:
      Navigator.push(context, MaterialPageRoute(builder: (_) => ChangeTire()));
      break;
    case 3:
      Navigator.push(context, MaterialPageRoute(builder: (_) => Washing()));
      break;
    case 9:
      Navigator.push(context, MaterialPageRoute(builder: (_) => CarCheck()));
      break;
    case 4:
      Navigator.push(context, MaterialPageRoute(builder: (_) => ChangeBattery()));
      break;
    default:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("الصفحة الخاصة بـ $title لسه مش متوفرة")),
      );
  }
}
