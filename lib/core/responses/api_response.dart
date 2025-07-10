abstract class ApiResponse<T> {
  ApiResponse({
    required this.errors,
    required this.message,
    required this.data,
  });
  final dynamic errors;
  final String message;
  final T data;
}
