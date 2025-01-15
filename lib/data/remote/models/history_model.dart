import 'dart:convert';

class HistoryModel {
    final Data data;

    HistoryModel({
        required this.data,
    });

    factory HistoryModel.fromJson(String str) => HistoryModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory HistoryModel.fromMap(Map<String, dynamic> json) => HistoryModel(
        data: Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "data": data.toMap(),
    };
}

class Data {
    final AiChats aiChats;

    Data({
        required this.aiChats,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        aiChats: AiChats.fromMap(json["aiChats"]),
    );

    Map<String, dynamic> toMap() => {
        "aiChats": aiChats.toMap(),
    };
}

class AiChats {
    final List<AiChatsDatum> data;
    final Meta meta;

    AiChats({
        required this.data,
        required this.meta,
    });

    factory AiChats.fromJson(String str) => AiChats.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AiChats.fromMap(Map<String, dynamic> json) => AiChats(
        data: List<AiChatsDatum>.from(json["data"].map((x) => AiChatsDatum.fromMap(x))),
        meta: Meta.fromMap(json["meta"]),
    );

    Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "meta": meta.toMap(),
    };
}

class AiChatsDatum {
    final String id;
    final PurpleAttributes attributes;

    AiChatsDatum({
        required this.id,
        required this.attributes,
    });

    factory AiChatsDatum.fromJson(String str) => AiChatsDatum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AiChatsDatum.fromMap(Map<String, dynamic> json) => AiChatsDatum(
        id: json["id"],
        attributes: PurpleAttributes.fromMap(json["attributes"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "attributes": attributes.toMap(),
    };
}

class PurpleAttributes {
    final User user;
    final DateTime createdAt;
    final Participants participants;
    final Messages messages;

    PurpleAttributes({
        required this.user,
        required this.createdAt,
        required this.participants,
        required this.messages,
    });

    factory PurpleAttributes.fromJson(String str) => PurpleAttributes.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PurpleAttributes.fromMap(Map<String, dynamic> json) => PurpleAttributes(
        user: User.fromMap(json["user"]),
        createdAt: DateTime.parse(json["createdAt"]),
        participants: Participants.fromMap(json["participants"]),
        messages: Messages.fromMap(json["messages"]),
    );

    Map<String, dynamic> toMap() => {
        "user": user.toMap(),
        "createdAt": createdAt.toIso8601String(),
        "participants": participants.toMap(),
        "messages": messages.toMap(),
    };
}

class Messages {
    final List<MessagesDatum> data;

    Messages({
        required this.data,
    });

    factory Messages.fromJson(String str) => Messages.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Messages.fromMap(Map<String, dynamic> json) => Messages(
        data: List<MessagesDatum>.from(json["data"].map((x) => MessagesDatum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}

class MessagesDatum {
    final String id;
    final FluffyAttributes attributes;

    MessagesDatum({
        required this.id,
        required this.attributes,
    });

    factory MessagesDatum.fromJson(String str) => MessagesDatum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory MessagesDatum.fromMap(Map<String, dynamic> json) => MessagesDatum(
        id: json["id"],
        attributes: FluffyAttributes.fromMap(json["attributes"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "attributes": attributes.toMap(),
    };
}

class FluffyAttributes {
    final String text;

    FluffyAttributes({
        required this.text,
    });

    factory FluffyAttributes.fromJson(String str) => FluffyAttributes.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory FluffyAttributes.fromMap(Map<String, dynamic> json) => FluffyAttributes(
        text: json["text"],
    );

    Map<String, dynamic> toMap() => {
        "text": text,
    };
}

class Participants {
    final List<Dat> data;

    Participants({
        required this.data,
    });

    factory Participants.fromJson(String str) => Participants.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Participants.fromMap(Map<String, dynamic> json) => Participants(
        data: List<Dat>.from(json["data"].map((x) => Dat.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}

class Dat {
    final DataAttributes attributes;

    Dat({
        required this.attributes,
    });

    factory Dat.fromJson(String str) => Dat.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Dat.fromMap(Map<String, dynamic> json) => Dat(
        attributes: DataAttributes.fromMap(json["attributes"]),
    );

    Map<String, dynamic> toMap() => {
        "attributes": attributes.toMap(),
    };
}

class DataAttributes {
    final String username;

    DataAttributes({
        required this.username,
    });

    factory DataAttributes.fromJson(String str) => DataAttributes.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DataAttributes.fromMap(Map<String, dynamic> json) => DataAttributes(
        username: json["username"],
    );

    Map<String, dynamic> toMap() => {
        "username": username,
    };
}

class User {
    final Dat data;

    User({
        required this.data,
    });

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        data: Dat.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "data": data.toMap(),
    };
}

class Meta {
    final Pagination pagination;

    Meta({
        required this.pagination,
    });

    factory Meta.fromJson(String str) => Meta.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Meta.fromMap(Map<String, dynamic> json) => Meta(
        pagination: Pagination.fromMap(json["pagination"]),
    );

    Map<String, dynamic> toMap() => {
        "pagination": pagination.toMap(),
    };
}

class Pagination {
    final int page;
    final int pageSize;
    final int total;
    final int pageCount;

    Pagination({
        required this.page,
        required this.pageSize,
        required this.total,
        required this.pageCount,
    });

    factory Pagination.fromJson(String str) => Pagination.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Pagination.fromMap(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        pageSize: json["pageSize"],
        total: json["total"],
        pageCount: json["pageCount"],
    );

    Map<String, dynamic> toMap() => {
        "page": page,
        "pageSize": pageSize,
        "total": total,
        "pageCount": pageCount,
    };
}
