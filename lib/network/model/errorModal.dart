import 'dart:convert';

class ApiError {
  final Error? error;

  ApiError({
    this.error,
  });

  factory ApiError.fromRawJson(String str) =>
      ApiError.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error?.toJson(),
      };
}

class Error {
  final int? status;
  final String? message;

  Error({
    this.status,
    this.message,
  });

  factory Error.fromRawJson(String str) => Error.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
