import 'dart:convert';

class GetCapperSportsModel {
  final String slug;
  final String name;

  GetCapperSportsModel({
    required this.slug,
    required this.name,
  });

  factory GetCapperSportsModel.fromJson(String str) =>
      GetCapperSportsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetCapperSportsModel.fromMap(Map<String, dynamic> json) => GetCapperSportsModel(
        slug: json["slug"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "slug": slug,
        "name": name,
      };
}
