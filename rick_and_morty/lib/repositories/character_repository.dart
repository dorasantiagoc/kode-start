import 'package:dio/dio.dart';
import '../models/character.dart';
import 'base_repository.dart';

class CharacterRepository implements BaseRepository<Character> {
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  late final Dio _dio;

  CharacterRepository() {
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
  Future<List<Character>> getAll() async {
    try {
      final response = await _dio.get('/character');
      final List<dynamic> charactersData = response.data['results'];
      return charactersData.map((json) => Character.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Character> getById(int id) async {
    try {
      final response = await _dio.get('/character/$id');
      return Character.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<Character>> search(String query) async {
    try {
      final response = await _dio.get('/character/?name=$query');
      final List<dynamic> charactersData = response.data['results'];
      return charactersData.map((json) => Character.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getCharactersWithPagination({
    int page = 1,
  }) async {
    try {
      final response = await _dio.get('/character/?page=$page');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Character>> getCharactersByStatus(String status) async {
    try {
      final response = await _dio.get('/character/?status=$status');
      final List<dynamic> charactersData = response.data['results'];
      return charactersData.map((json) => Character.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Character>> getCharactersBySpecies(String species) async {
    try {
      final response = await _dio.get('/character/?species=$species');
      final List<dynamic> charactersData = response.data['results'];
      return charactersData.map((json) => Character.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Character>> getCharactersByGender(String gender) async {
    try {
      final response = await _dio.get('/character/?gender=$gender');
      final List<dynamic> charactersData = response.data['results'];
      return charactersData.map((json) => Character.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Character>> getMultipleCharacters(List<int> ids) async {
    try {
      final idsString = ids.join(',');
      final response = await _dio.get('/character/$idsString');

      if (response.data is List) {
        final List<dynamic> charactersData = response.data;
        return charactersData.map((json) => Character.fromJson(json)).toList();
      } else {
        return [Character.fromJson(response.data)];
      }
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
          return Exception('Personagem não encontrado.');
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
