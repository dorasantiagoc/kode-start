import 'package:dio/dio.dart';
import '../models/location.dart';
import 'base_repository.dart';

class LocationRepository implements BaseRepository<Location> {
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  late final Dio _dio;

  LocationRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (obj) {},
      ),
    );
  }

  @override
  Future<List<Location>> getAll() async {
    try {
      final response = await _dio.get('/location');
      final List<dynamic> locationsData = response.data['results'];
      return locationsData.map((json) => Location.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Location> getById(int id) async {
    try {
      final response = await _dio.get('/location/$id');
      return Location.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<Location>> search(String query) async {
    try {
      final response = await _dio.get('/location/?name=$query');
      final List<dynamic> locationsData = response.data['results'];
      return locationsData.map((json) => Location.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getLocationsWithPagination({
    int page = 1,
  }) async {
    try {
      final response = await _dio.get('/location/?page=$page');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Location>> getLocationsByType(String type) async {
    try {
      final response = await _dio.get('/location/?type=$type');
      final List<dynamic> locationsData = response.data['results'];
      return locationsData.map((json) => Location.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Location>> getLocationsByDimension(String dimension) async {
    try {
      final response = await _dio.get('/location/?dimension=$dimension');
      final List<dynamic> locationsData = response.data['results'];
      return locationsData.map((json) => Location.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Timeout de conexão. Verifique sua internet.');
      case DioExceptionType.receiveTimeout:
        return Exception('Timeout ao receber dados.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return Exception('Localização não encontrada.');
        } else if (statusCode == 500) {
          return Exception('Erro interno do servidor.');
        }
        return Exception('Erro na resposta: $statusCode');
      case DioExceptionType.cancel:
        return Exception('Requisição cancelada.');
      default:
        return Exception('Erro de rede: ${e.message}');
    }
  }
}
