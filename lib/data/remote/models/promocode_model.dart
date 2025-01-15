import 'dart:convert';

class PromocodeModel {
    final Data data;

    PromocodeModel({
        required this.data,
    });

    factory PromocodeModel.fromJson(String str) => PromocodeModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PromocodeModel.fromMap(Map<String, dynamic> json) => PromocodeModel(
        data: Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "data": data.toMap(),
    };
}

class Data {
    final Promocodes promocodes;

    Data({
        required this.promocodes,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        promocodes: Promocodes.fromMap(json["promocodes"]),
    );

    Map<String, dynamic> toMap() => {
        "promocodes": promocodes.toMap(),
    };
}

class Attributes {
    final Promocodes users;
    final int tokens;
    final String promocode;

    Attributes({
        required this.users,
        required this.tokens,
        required this.promocode,
    });

    factory Attributes.fromJson(String str) => Attributes.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Attributes.fromMap(Map<String, dynamic> json) => Attributes(
        users: Promocodes.fromMap(json["users"]),
        tokens: json["tokens"],
        promocode: json["promocode"],
    );

    Map<String, dynamic> toMap() => {
        "users": users.toMap(),
        "tokens": tokens,
        "promocode": promocode,
    };
}

class Datum {
    final String id;
    final Attributes attributes;

    Datum({
        required this.id,
        required this.attributes,
    });

    factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"],
        attributes: Attributes.fromMap(json["attributes"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "attributes": attributes.toMap(),
    };
}

class Promocodes {
    final List<Datum> data;

    Promocodes({
        required this.data,
    });

    factory Promocodes.fromJson(String str) => Promocodes.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Promocodes.fromMap(Map<String, dynamic> json) => Promocodes(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}
