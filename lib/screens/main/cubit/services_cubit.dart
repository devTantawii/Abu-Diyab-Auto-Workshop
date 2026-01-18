import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constant/api.dart';
import '../../../core/langCode.dart';
import '../model/service_model.dart';
import 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final Dio dio;

  ServicesCubit({required this.dio}) : super(ServicesInitial());

  Future<void> fetchServices() async {
    emit(ServicesLoading());
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await dio.get(
        mainApi + servicesApi,
        options: Options(
          headers: {
            "Accept-Language": langCode == '' ? "en" : langCode,
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];

         final List servicesJson = data['services'] ?? [];
        final List productsJson = data['products'] ?? [];

        final services = servicesJson
            .map<ServiceModel>((item) => ServiceModel.fromJson(item))
            .toList();

        final products = productsJson
            .map<ProductModel>((item) => ProductModel.fromJson(item))
            .toList();

        emit(ServicesLoaded(services: services, products: products));
      } else {
        emit(ServicesError('Error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ServicesError('Error fetching services: $e'));
    }
  }
}
