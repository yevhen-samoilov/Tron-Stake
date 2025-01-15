import 'dart:convert';

class CreateChatModel {
    final CreateChatModelData data;

    CreateChatModel({
        required this.data,
    });

    factory CreateChatModel.fromJson(String str) => CreateChatModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CreateChatModel.fromMap(Map<String, dynamic> json) => CreateChatModel(
        data: CreateChatModelData.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "data": data.toMap(),
    };
}

class CreateChatModelData {
    final CreateAiChat createAiChat;

    CreateChatModelData({
        required this.createAiChat,
    });

    factory CreateChatModelData.fromJson(String str) => CreateChatModelData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CreateChatModelData.fromMap(Map<String, dynamic> json) => CreateChatModelData(
        createAiChat: CreateAiChat.fromMap(json["createAiChat"]),
    );

    Map<String, dynamic> toMap() => {
        "createAiChat": createAiChat.toMap(),
    };
}

class CreateAiChat {
    final CreateAiChatData data;

    CreateAiChat({
        required this.data,
    });

    factory CreateAiChat.fromJson(String str) => CreateAiChat.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CreateAiChat.fromMap(Map<String, dynamic> json) => CreateAiChat(
        data: CreateAiChatData.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "data": data.toMap(),
    };
}

class CreateAiChatData {
    final String id;

    CreateAiChatData({
        required this.id,
    });

    factory CreateAiChatData.fromJson(String str) => CreateAiChatData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CreateAiChatData.fromMap(Map<String, dynamic> json) => CreateAiChatData(
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
    };
}
