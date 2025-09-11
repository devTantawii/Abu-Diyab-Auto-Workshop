import 'package:abu_diyab_workshop/screens/main/cubit/services_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/constant/api.dart';
import '../model/service_model.dart';
class ServicesCubit extends Cubit<ServicesState> {
  final Dio dio;
  static const String baseImageUrl = 'https://devworkshop.abudiyabksa.com/storage/';

  ServicesCubit({required this.dio}) : super(ServicesInitial());

  Future<void> fetchServices() async {
    emit(ServicesLoading());
    try {
      final response = await dio.get(
        productionApi + servicesApi,
        options: Options(
          headers: {
            'Accept-Language': 'ar',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List apiData = response.data['data'];
        final services = apiData.map<ServiceModel>((item) {
          return ServiceModel.fromJson(item);
        }).toList();

        emit(ServicesLoaded(services));
      } else {
        emit(ServicesError('Error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ServicesError('Error fetching services: $e'));
    }
  }
}