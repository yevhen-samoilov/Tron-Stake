import 'dart:convert';
import 'package:equatable/equatable.dart';

class FootballNewsModel {
  final List<Article> data;

  FootballNewsModel({
    required this.data,
  });

  factory FootballNewsModel.fromJson(String str) =>
      FootballNewsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FootballNewsModel.fromMap(Map<String, dynamic> json) =>
      FootballNewsModel(
        data: List<Article>.from(json["data"].map((x) => Article.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Article extends Equatable {
  final String title;
  final String description;
  final String url;
  final String image;
  final String pubDate;

  const Article({
    required this.title,
    required this.description,
    required this.url,
    required this.image,
    required this.pubDate,
  });

  @override
  List<Object?> get props => [url];

  factory Article.fromJson(String str) => Article.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Article.fromMap(Map<String, dynamic> json) => Article(
        title: json["title"],
        description: json["description"],
        url: json["url"],
        image: json["image"],
        pubDate: json["pubDate"],
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "description": description,
        "url": url,
        "image": image,
        "pubDate": pubDate,
      };
}
