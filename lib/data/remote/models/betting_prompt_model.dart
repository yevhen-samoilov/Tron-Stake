import 'dart:convert';

class BettingPromptModel {
  final BettingPromptModelData data;

  BettingPromptModel({
    required this.data,
  });

  factory BettingPromptModel.fromJson(String str) =>
      BettingPromptModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BettingPromptModel.fromMap(Map<String, dynamic> json) =>
      BettingPromptModel(
        data: BettingPromptModelData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "data": data.toMap(),
      };
}

class BettingPromptModelData {
  final BettingPrompt bettingPrompt;

  BettingPromptModelData({
    required this.bettingPrompt,
  });

  factory BettingPromptModelData.fromJson(String str) =>
      BettingPromptModelData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BettingPromptModelData.fromMap(Map<String, dynamic> json) =>
      BettingPromptModelData(
        bettingPrompt: BettingPrompt.fromMap(json["bettingPrompt"]),
      );

  Map<String, dynamic> toMap() => {
        "bettingPrompt": bettingPrompt.toMap(),
      };
}

class BettingPrompt {
  final BettingPromptData data;

  BettingPrompt({
    required this.data,
  });

  factory BettingPrompt.fromJson(String str) =>
      BettingPrompt.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BettingPrompt.fromMap(Map<String, dynamic> json) => BettingPrompt(
        data: BettingPromptData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "data": data.toMap(),
      };
}

class BettingPromptData {
  final Attributes attributes;

  BettingPromptData({
    required this.attributes,
  });

  factory BettingPromptData.fromJson(String str) =>
      BettingPromptData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BettingPromptData.fromMap(Map<String, dynamic> json) =>
      BettingPromptData(
        attributes: Attributes.fromMap(json["attributes"]),
      );

  Map<String, dynamic> toMap() => {
        "attributes": attributes.toMap(),
      };
}

class Attributes {
  final AttributesData data;

  Attributes({
    required this.data,
  });

  factory Attributes.fromJson(String str) =>
      Attributes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Attributes.fromMap(Map<String, dynamic> json) => Attributes(
        data: AttributesData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "data": data.toMap(),
      };
}

class AttributesData {
  final List<String> prompts;

  AttributesData({
    required this.prompts,
  });

  factory AttributesData.fromJson(String str) =>
      AttributesData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AttributesData.fromMap(Map<String, dynamic> json) => AttributesData(
        prompts: List<String>.from(json["prompts"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "prompts": List<dynamic>.from(prompts.map((x) => x)),
      };
}
