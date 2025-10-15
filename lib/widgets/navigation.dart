import 'package:abu_diyab_workshop/screens/services/screen/periodic_maintenance.dart';
import 'package:flutter/material.dart';
import '../screens/services/screen/accidents.dart';
import '../screens/services/screen/car_check.dart';
import '../screens/services/screen/change_battery.dart';
import '../screens/services/screen/change_oil.dart';
import '../screens/services/screen/change_tire.dart';
import '../screens/services/screen/maintenance_breakdowns.dart';
import '../screens/services/screen/washing.dart';

void navigateToServiceScreen(
  BuildContext context,
  String slug,
  String title,
  String description,
  String icon,
) {
  switch (slug) {
    case 'oils':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => ChangeOil(
                title: title,
                description: description,
                icon: icon,
                slug: slug,
              ),
        ),
      );
      break;
    case 'tires':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => ChangeTire(
                title: title,
                description: description,
                icon: icon,
                slug: slug,
              ),
        ),
      );
      break;
    case 'car-wash':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => Washing(
                title: title,
                description: description,
                icon: icon,
                slug: slug,
              ),
        ),
      );
      break;
    case 'car-checks':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => CarCheck(
                title: title,
                description: description,
                icon: icon,
                slug: slug,
              ),
        ),
      );
      break;
    case 'periodic-maintenances':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => PeriodicMaintenance(
                title: title,
                description: description,
                icon: icon,
                slug: slug,
              ),
        ),
      );
      break;
    case 'accidents':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => Accidents(
                title: title,
                description: description,
                icon: icon,
                slug: slug,
              ),
        ),
      );
      break;
    case 'batteries':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => ChangeBattery(
                title: title,
                description: description,
                icon: icon,
                slug: slug, // ✅ هنا
              ),
        ),
      );
      break;
    case 'maintenance-breakdowns':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => MaintenanceBreakdowns(
                title: title,
                description: description,
                icon: icon,
                slug: slug,
              ),
        ),
      );
      break;
    default:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("الصفحة الخاصة بـ $title لسه مش متوفرة")),
      );
  }
}
