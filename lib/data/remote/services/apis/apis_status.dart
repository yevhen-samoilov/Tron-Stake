class Success {
  final Object response;
  Success({
    required this.response,
  });
}

class Failure {
  final int code;
  final String errorResponse;
  Failure({
    required this.code,
    required this.errorResponse,
  });
}
