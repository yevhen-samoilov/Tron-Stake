import 'dart:convert';

class GetChatModel {
  final GetChatModelData data;

  GetChatModel({
    required this.data,
  });

  factory GetChatModel.fromJson(String str) =>
      GetChatModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetChatModel.fromMap(Map<String, dynamic> json) => GetChatModel(
        data: GetChatModelData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "data": data.toMap(),
      };
}

class GetChatModelData {
  final AiChat aiChat;

  GetChatModelData({
    required this.aiChat,
  });

  factory GetChatModelData.fromJson(String str) =>
      GetChatModelData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetChatModelData.fromMap(Map<String, dynamic> json) =>
      GetChatModelData(
        aiChat: AiChat.fromMap(json["aiChat"]),
      );

  Map<String, dynamic> toMap() => {
        "aiChat": aiChat.toMap(),
      };
}

class AiChat {
  final AiChatData data;

  AiChat({
    required this.data,
  });

  factory AiChat.fromJson(String str) => AiChat.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AiChat.fromMap(Map<String, dynamic> json) => AiChat(
        data: AiChatData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "data": data.toMap(),
      };
}

class AiChatData {
  final String id;
  final PurpleAttributes attributes;

  AiChatData({
    required this.id,
    required this.attributes,
  });

  factory AiChatData.fromJson(String str) =>
      AiChatData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AiChatData.fromMap(Map<String, dynamic> json) => AiChatData(
        id: json["id"],
        attributes: PurpleAttributes.fromMap(json["attributes"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "attributes": attributes.toMap(),
      };
}

class PurpleAttributes {
  final FluffyUser user;
  final DateTime createdAt;
  final Participants participants;
  final Messages messages;
  final List<int>? pinned;

  PurpleAttributes({
    required this.user,
    required this.createdAt,
    required this.participants,
    required this.messages,
    required this.pinned,
  });

  factory PurpleAttributes.fromJson(String str) =>
      PurpleAttributes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PurpleAttributes.fromMap(Map<String, dynamic> json) =>
      PurpleAttributes(
        user: FluffyUser.fromMap(json["user"]),
        createdAt: DateTime.parse(json["createdAt"]),
        participants: Participants.fromMap(json["participants"]),
        messages: Messages.fromMap(json["messages"]),
        pinned: json["pinned"] == null
            ? []
            : List<int>.from(json["pinned"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "user": user.toMap(),
        "createdAt": createdAt.toIso8601String(),
        "participants": participants.toMap(),
        "messages": messages.toMap(),
        "pinned":
            pinned == null ? [] : List<dynamic>.from(pinned!.map((x) => x)),
      };
}

class Messages {
  final List<Datum> data;

  Messages({
    required this.data,
  });

  factory Messages.fromJson(String str) => Messages.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Messages.fromMap(Map<String, dynamic> json) => Messages(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Datum {
  final FluffyAttributes attributes;

  Datum({
    required this.attributes,
  });

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        attributes: FluffyAttributes.fromMap(json["attributes"]),
      );

  Map<String, dynamic> toMap() => {
        "attributes": attributes.toMap(),
      };
}

class FluffyAttributes {
  final String text;
  final PurpleUser user;

  FluffyAttributes({
    required this.text,
    required this.user,
  });

  factory FluffyAttributes.fromJson(String str) =>
      FluffyAttributes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FluffyAttributes.fromMap(Map<String, dynamic> json) =>
      FluffyAttributes(
        text: json["text"],
        user: PurpleUser.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "text": text,
        "user": user.toMap(),
      };
}

class PurpleUser {
  final UserData data;

  PurpleUser({
    required this.data,
  });

  factory PurpleUser.fromJson(String str) =>
      PurpleUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PurpleUser.fromMap(Map<String, dynamic> json) => PurpleUser(
        data: UserData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "data": data.toMap(),
      };
}

class UserData {
  final String id;

  UserData({
    required this.id,
  });

  factory UserData.fromJson(String str) => UserData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
      };
}

class Participants {
  final List<Dat> data;

  Participants({
    required this.data,
  });

  factory Participants.fromJson(String str) =>
      Participants.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Participants.fromMap(Map<String, dynamic> json) => Participants(
        data: List<Dat>.from(json["data"].map((x) => Dat.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Dat {
  final TentacledAttributes attributes;

  Dat({
    required this.attributes,
  });

  factory Dat.fromJson(String str) => Dat.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Dat.fromMap(Map<String, dynamic> json) => Dat(
        attributes: TentacledAttributes.fromMap(json["attributes"]),
      );

  Map<String, dynamic> toMap() => {
        "attributes": attributes.toMap(),
      };
}

class TentacledAttributes {
  final String username;

  TentacledAttributes({
    required this.username,
  });

  factory TentacledAttributes.fromJson(String str) =>
      TentacledAttributes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TentacledAttributes.fromMap(Map<String, dynamic> json) =>
      TentacledAttributes(
        username: json["username"],
      );

  Map<String, dynamic> toMap() => {
        "username": username,
      };
}

class FluffyUser {
  final Dat data;

  FluffyUser({
    required this.data,
  });

  factory FluffyUser.fromJson(String str) =>
      FluffyUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FluffyUser.fromMap(Map<String, dynamic> json) => FluffyUser(
        data: Dat.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "data": data.toMap(),
      };
}
