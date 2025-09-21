// class CarBrandModel {
//   final int id;
//   final String icon;
//   final String name;
//
//   CarBrandModel({
//     required this.id,
//     required this.icon,
//     required this.name,
//   });
//
//   factory CarBrandModel.fromJson(Map<String, dynamic> json) {
//     return CarBrandModel(
//       id: json['id'],
//       icon: json['icon'],
//       name: json['name'],
//     );
//   }
// }
//
// class CarModelModel {
//   final int id;
//   final String name;
//
//   CarModelModel({
//     required this.id,
//     required this.name,
//   });
//
//   factory CarModelModel.fromJson(Map<String, dynamic> json) {
//     return CarModelModel(
//       id: json['id'],
//       name: json['name'],
//     );
//   }
// }
//
// class UserCarModel {
//   final int id;
//   final int userId;
//   final String licencePlate;
//   final String name;
//   final String year;
//   final String kilometer;
//   final String carCertificate;
//   final CarBrandModel carBrand;
//   final CarModelModel carModel;
//   final String createdAt;
//   final String updatedAt;
//
//   UserCarModel({
//     required this.id,
//     required this.userId,
//     required this.licencePlate,
//     required this.name,
//     required this.year,
//     required this.kilometer,
//     required this.carCertificate,
//     required this.carBrand,
//     required this.carModel,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory UserCarModel.fromJson(Map<String, dynamic> json) {
//     return UserCarModel(
//       id: json['id'],
//       userId: json['user_id'],
//       licencePlate: json['licence_plate'],
//       name: json['name'],
//       year: json['year'],
//       kilometer: json['kilometer'],
//       carCertificate: json['car_certificate'],
//       carBrand: CarBrandModel.fromJson(json['car_brand']),
//       carModel: CarModelModel.fromJson(json['car_model']),
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//     );
//   }
// }
