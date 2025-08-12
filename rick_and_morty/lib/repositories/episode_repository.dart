import 'package:dio/dio.dart';
import '../models/episode.dart';
import 'base_repository.dart';

class EpisodeRepository implements BaseRepository<Episode> {
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  late final Dio _dio;

  EpisodeRepository() {
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
  Future<List<Episode>> getAll() async {
    try {
      final response = await _dio.get('/episode');
      final List<dynamic> episodesData = response.data['results'];
      return episodesData.map((json) => Episode.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Episode> getById(int id) async {
    try {
      final response = await _dio.get('/episode/$id');
      return Episode.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<Episode>> search(String query) async {
    try {
      final response = await _dio.get('/episode/?name=$query');
      final List<dynamic> episodesData = response.data['results'];
      return episodesData.map((json) => Episode.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getEpisodesWithPagination({int page = 1}) async {
    try {
      final response = await _dio.get('/episode/?page=$page');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Episode>> getEpisodesByCode(String episodeCode) async {
    try {
      final response = await _dio.get('/episode/?episode=$episodeCode');
      final List<dynamic> episodesData = response.data['results'];
      return episodesData.map((json) => Episode.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Episode>> getMultipleEpisodes(List<int> ids) async {
    try {
      final idsString = ids.join(',');
      final response = await _dio.get('/episode/$idsString');

      if (response.data is List) {
        final List<dynamic> episodesData = response.data;
        return episodesData.map((json) => Episode.fromJson(json)).toList();
      } else {
        return [Episode.fromJson(response.data)];
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
          return Exception('Episódio não encontrado.');
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
