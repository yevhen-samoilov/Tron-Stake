import 'dart:convert';

class MarketTips {
  final List<MarketPrediction> marketPrediction;

  MarketTips({
    required this.marketPrediction,
  });

  factory MarketTips.fromJson(String str) =>
      MarketTips.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MarketTips.fromMap(Map<String, dynamic> json) => MarketTips(
        marketPrediction: List<MarketPrediction>.from(
            json["market_prediction"].map((x) => MarketPrediction.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "market_prediction":
            List<dynamic>.from(marketPrediction.map((x) => x.toMap())),
      };
}

class MarketPrediction {
  final String name;
  final String fullName;
  final String marker;
  final bool free;

  MarketPrediction({
    required this.name,
    required this.fullName,
    required this.marker,
    required this.free,
  });

  factory MarketPrediction.fromJson(String str) =>
      MarketPrediction.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MarketPrediction.fromMap(Map<String, dynamic> json) =>
      MarketPrediction(
        name: json["name"],
        fullName: json["fullName"],
        marker: json["marker"],
        free: json["free"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "fullName": fullName,
        "marker": marker,
        "free": free,
      };
}
