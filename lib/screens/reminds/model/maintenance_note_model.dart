
class MaintenanceNote {
  final int serviceId;
  final int userCarId;
  final String kilometer;
  final String? lastMaintenance; // YYYY-MM-DD or null
  final String? remindMe; // YYYY-MM-DD or null
  final String details;
  final String? mediaPath; // local path if exists

  MaintenanceNote({
    required this.serviceId,
    required this.userCarId,
    required this.kilometer,
    required this.details,
    this.lastMaintenance,
    this.remindMe,
    this.mediaPath,
  });

  /// helper toMap for debugging or for non-multipart requests
  Map<String, dynamic> toMap() {
    return {
      'service_id': serviceId,
      'user_car_id': userCarId,
      'kilometer': kilometer,
      'last_maintenance': lastMaintenance,
      'remind_me': remindMe,
      'details': details,
      'media': mediaPath,
    };
  }
}
