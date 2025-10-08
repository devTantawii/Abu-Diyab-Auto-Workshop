import 'package:flutter/material.dart';
import '../screens/services/screen/car_check.dart';
import '../screens/services/screen/change_battery.dart';
import '../screens/services/screen/change_oil.dart';
import '../screens/services/screen/change_tire.dart';
import '../screens/services/screen/washing.dart';

void navigateToServiceScreen(BuildContext context, String slug, String title) {
  switch (slug) {
    case 'oils':
      Navigator.push(context, MaterialPageRoute(builder: (_) => ChangeOil()));
      break;
    case 'tires':
      Navigator.push(context, MaterialPageRoute(builder: (_) => ChangeTire()));
      break;
    case 'car-wash':
      Navigator.push(context, MaterialPageRoute(builder: (_) => Washing()));
      break;
    case 'car-checks':
      Navigator.push(context, MaterialPageRoute(builder: (_) => CarCheck()));
      break;
    case 'batteries':
      Navigator.push(context, MaterialPageRoute(builder: (_) => ChangeBattery()));
      break;
    default:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("الصفحة الخاصة بـ $title لسه مش متوفرة")),
      );
  }
}
