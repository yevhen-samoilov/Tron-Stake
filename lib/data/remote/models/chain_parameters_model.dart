import 'dart:convert';

class ChainParametersModel {
    final List<TronParameter> tronParameters;

    ChainParametersModel({
        required this.tronParameters,
    });

    factory ChainParametersModel.fromJson(String str) => ChainParametersModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ChainParametersModel.fromMap(Map<String, dynamic> json) => ChainParametersModel(
        tronParameters: List<TronParameter>.from(json["tronParameters"].map((x) => TronParameter.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "tronParameters": List<dynamic>.from(tronParameters.map((x) => x.toMap())),
    };
}

class TronParameter {
    final String key;
    final int value;

    TronParameter({
        required this.key,
        required this.value,
    });

    factory TronParameter.fromJson(String str) => TronParameter.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TronParameter.fromMap(Map<String, dynamic> json) => TronParameter(
        key: json["key"],
        value: json["value"],
    );

    Map<String, dynamic> toMap() => {
        "key": key,
        "value": value,
    };
}
