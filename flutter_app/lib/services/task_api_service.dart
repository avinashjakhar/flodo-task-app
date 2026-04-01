import 'package:dio/dio.dart';
import '../models/task.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class TaskApiService {
  final Dio _dio;

  TaskApiService({String baseUrl = 'http://localhost:8000/api/v1'})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 30),
            headers: {'Content-Type': 'application/json'},
          ),
        );

  Future<List<Task>> getTasks({String? search, TaskStatus? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (status != null) queryParams['status'] = status.label;

      final response = await _dio.get('/tasks', queryParameters: queryParams);
      final List tasks = response.data['tasks'];
      return tasks.map((e) => Task.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Task> createTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required TaskStatus status,
    int? blockedById,
  }) async {
    try {
      final response = await _dio.post('/tasks', data: {
        'title': title,
        'description': description,
        'due_date': _formatDate(dueDate),
        'status': status.label,
        'blocked_by_id': blockedById,
      });
      return Task.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Task> updateTask(
    int id, {
    String? title,
    String? description,
    DateTime? dueDate,
    TaskStatus? status,
    int? blockedById,
    bool clearBlockedBy = false,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (dueDate != null) data['due_date'] = _formatDate(dueDate);
      if (status != null) data['status'] = status.label;
      if (clearBlockedBy) {
        data['blocked_by_id'] = null;
      } else if (blockedById != null) {
        data['blocked_by_id'] = blockedById;
      }

      final response = await _dio.put('/tasks/$id', data: data);
      return Task.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _dio.delete('/tasks/$id');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> autocomplete(String query) async {
    try {
      final response = await _dio.get(
        '/tasks/search/autocomplete',
        queryParameters: {'q': query},
      );
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  ApiException _handleDioError(DioException e) {
    if (e.response != null) {
      final detail = e.response?.data['detail'];
      return ApiException(
        detail is String ? detail : 'Server error',
        statusCode: e.response?.statusCode,
      );
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiException('Connection timed out. Is the server running?');
    }
    return ApiException('Network error: ${e.message}');
  }
}
