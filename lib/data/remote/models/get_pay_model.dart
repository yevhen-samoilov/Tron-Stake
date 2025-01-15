import 'dart:convert';

class GetBettingPayModel {
    final GetBettingPayModelData data;

    GetBettingPayModel({
        required this.data,
    });

    factory GetBettingPayModel.fromJson(String str) => GetBettingPayModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetBettingPayModel.fromMap(Map<String, dynamic> json) => GetBettingPayModel(
        data: GetBettingPayModelData.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "data": data.toMap(),
    };
}

class GetBettingPayModelData {
    final BettingPay bettingPay;

    GetBettingPayModelData({
        required this.bettingPay,
    });

    factory GetBettingPayModelData.fromJson(String str) => GetBettingPayModelData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetBettingPayModelData.fromMap(Map<String, dynamic> json) => GetBettingPayModelData(
        bettingPay: BettingPay.fromMap(json["bettingPay"]),
    );

    Map<String, dynamic> toMap() => {
        "bettingPay": bettingPay.toMap(),
    };
}

class BettingPay {
    final BettingPayData data;

    BettingPay({
        required this.data,
    });

    factory BettingPay.fromJson(String str) => BettingPay.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory BettingPay.fromMap(Map<String, dynamic> json) => BettingPay(
        data: BettingPayData.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "data": data.toMap(),
    };
}

class BettingPayData {
    final String id;
    final PurpleAttributes attributes;

    BettingPayData({
        required this.id,
        required this.attributes,
    });

    factory BettingPayData.fromJson(String str) => BettingPayData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory BettingPayData.fromMap(Map<String, dynamic> json) => BettingPayData(
        id: json["id"],
        attributes: PurpleAttributes.fromMap(json["attributes"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "attributes": attributes.toMap(),
    };
}

class PurpleAttributes {
    final String userId;
    final BettingUser bettingUser;
    final String uuid;
    final int tokens;
    final bool pay;

    PurpleAttributes({
        required this.userId,
        required this.bettingUser,
        required this.uuid,
        required this.tokens,
        required this.pay,
    });

    factory PurpleAttributes.fromJson(String str) => PurpleAttributes.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PurpleAttributes.fromMap(Map<String, dynamic> json) => PurpleAttributes(
        userId: json["userID"],
        bettingUser: BettingUser.fromMap(json["betting_user"]),
        uuid: json["uuid"],
        tokens: json["tokens"],
        pay: json["pay"],
    );

    Map<String, dynamic> toMap() => {
        "userID": userId,
        "betting_user": bettingUser.toMap(),
        "uuid": uuid,
        "tokens": tokens,
        "pay": pay,
    };
}

class BettingUser {
    final BettingUserData data;

    BettingUser({
        required this.data,
    });

    factory BettingUser.fromJson(String str) => BettingUser.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory BettingUser.fromMap(Map<String, dynamic> json) => BettingUser(
        data: BettingUserData.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "data": data.toMap(),
    };
}

class BettingUserData {
    final FluffyAttributes attributes;

    BettingUserData({
        required this.attributes,
    });

    factory BettingUserData.fromJson(String str) => BettingUserData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory BettingUserData.fromMap(Map<String, dynamic> json) => BettingUserData(
        attributes: FluffyAttributes.fromMap(json["attributes"]),
    );

    Map<String, dynamic> toMap() => {
        "attributes": attributes.toMap(),
    };
}

class FluffyAttributes {
    final int tokens;

    FluffyAttributes({
        required this.tokens,
    });

    factory FluffyAttributes.fromJson(String str) => FluffyAttributes.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory FluffyAttributes.fromMap(Map<String, dynamic> json) => FluffyAttributes(
        tokens: json["tokens"],
    );

    Map<String, dynamic> toMap() => {
        "tokens": tokens,
    };
}
