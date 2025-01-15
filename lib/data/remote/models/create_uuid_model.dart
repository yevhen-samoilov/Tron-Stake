import 'dart:convert';

class CreateUuidModel {
    final CreateUuidModelData data;

    CreateUuidModel({
        required this.data,
    });

    factory CreateUuidModel.fromJson(String str) => CreateUuidModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CreateUuidModel.fromMap(Map<String, dynamic> json) => CreateUuidModel(
        data: CreateUuidModelData.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "data": data.toMap(),
    };
}

class CreateUuidModelData {
    final CreatePay createPay;

    CreateUuidModelData({
        required this.createPay,
    });

    factory CreateUuidModelData.fromJson(String str) => CreateUuidModelData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CreateUuidModelData.fromMap(Map<String, dynamic> json) => CreateUuidModelData(
        createPay: CreatePay.fromMap(json["createBettingPay"]),
    );

    Map<String, dynamic> toMap() => {
        "createBettingPay": createPay.toMap(),
    };
}

class CreatePay {
    final CreatePayData data;

    CreatePay({
        required this.data,
    });

    factory CreatePay.fromJson(String str) => CreatePay.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CreatePay.fromMap(Map<String, dynamic> json) => CreatePay(
        data: CreatePayData.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "data": data.toMap(),
    };
}

class CreatePayData {
    final String id;

    CreatePayData({
        required this.id,
    });

    factory CreatePayData.fromJson(String str) => CreatePayData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CreatePayData.fromMap(Map<String, dynamic> json) => CreatePayData(
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
    };
}
