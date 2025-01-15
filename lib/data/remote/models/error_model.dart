import 'dart:convert';

class ErrorModel {
    final List<ErrorElement> errors;
    final dynamic data;

    ErrorModel({
        required this.errors,
        required this.data,
    });

    factory ErrorModel.fromJson(String str) => ErrorModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ErrorModel.fromMap(Map<String, dynamic> json) => ErrorModel(
        errors: List<ErrorElement>.from(json["errors"].map((x) => ErrorElement.fromMap(x))),
        data: json["data"],
    );

    Map<String, dynamic> toMap() => {
        "errors": List<dynamic>.from(errors.map((x) => x.toMap())),
        "data": data,
    };
}

class ErrorElement {
    final String message;
    final Extensions extensions;

    ErrorElement({
        required this.message,
        required this.extensions,
    });

    factory ErrorElement.fromJson(String str) => ErrorElement.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ErrorElement.fromMap(Map<String, dynamic> json) => ErrorElement(
        message: json["message"],
        extensions: Extensions.fromMap(json["extensions"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "extensions": extensions.toMap(),
    };
}

class Extensions {
    final ExtensionsError error;
    final String code;

    Extensions({
        required this.error,
        required this.code,
    });

    factory Extensions.fromJson(String str) => Extensions.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Extensions.fromMap(Map<String, dynamic> json) => Extensions(
        error: ExtensionsError.fromMap(json["error"]),
        code: json["code"],
    );

    Map<String, dynamic> toMap() => {
        "error": error.toMap(),
        "code": code,
    };
}

class ExtensionsError {
    final String name;
    final String message;
    final Details details;

    ExtensionsError({
        required this.name,
        required this.message,
        required this.details,
    });

    factory ExtensionsError.fromJson(String str) => ExtensionsError.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ExtensionsError.fromMap(Map<String, dynamic> json) => ExtensionsError(
        name: json["name"],
        message: json["message"],
        details: Details.fromMap(json["details"]),
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "message": message,
        "details": details.toMap(),
    };
}

class Details {
    Details();

    factory Details.fromJson(String str) => Details.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Details.fromMap(Map<String, dynamic> json) => Details(
    );

    Map<String, dynamic> toMap() => {
    };
}
