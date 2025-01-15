import 'dart:convert';

class MatchesModel {
  List<Country> country;

  MatchesModel({
    required this.country,
  });

  factory MatchesModel.fromJson(String str) =>
      MatchesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MatchesModel.fromMap(Map<String, dynamic> json) => MatchesModel(
        country:
            List<Country>.from(json["country"].map((x) => Country.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "country": List<dynamic>.from(country.map((x) => x.toMap())),
      };

  MatchesModel copyWith({
    List<Country>? country,
  }) {
    return MatchesModel(
      country: country ?? this.country,
    );
  }
}

class Country {
  final String name;
  final String flag;
  List<League> leagues;

  Country({
    required this.name,
    required this.flag,
    required this.leagues,
  });

  factory Country.fromJson(String str) => Country.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Country.fromMap(Map<String, dynamic> json) => Country(
        name: json["name"],
        flag: json["flag"],
        leagues:
            List<League>.from(json["leagues"].map((x) => League.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "flag": flag,
        "leagues": List<dynamic>.from(leagues.map((x) => x.toMap())),
      };
}

class League {
  final String name;
  List<Match> matches;

  League({
    required this.name,
    required this.matches,
  });

  factory League.fromJson(String str) => League.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory League.fromMap(Map<String, dynamic> json) => League(
        name: json["name"],
        matches: List<Match>.from(json["matches"].map((x) => Match.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "matches": List<dynamic>.from(matches.map((x) => x.toMap())),
      };
}

class Match {
  final String homeTeam;
  final String awayTeam;
  final num id;
  final String market;
  final String competitionName;
  final String prediction;
  final String competitionCluster;
  final String status;
  final String federation;
  final String season;
  final String result;
  final DateTime startDate;
  final Odds odds;
  final String homeLogo;
  final String awayLogo;

  Match({
    required this.homeTeam,
    required this.awayTeam,
    required this.id,
    required this.market,
    required this.competitionName,
    required this.prediction,
    required this.competitionCluster,
    required this.status,
    required this.federation,
    required this.season,
    required this.result,
    required this.startDate,
    required this.odds,
    required this.homeLogo,
    required this.awayLogo,
  });

  factory Match.fromJson(String str) => Match.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Match.fromMap(Map<String, dynamic> json) => Match(
        homeTeam: json["home_team"],
        awayTeam: json["away_team"],
        id: json["id"],
        market: json["market"],
        competitionName: json["competition_name"],
        prediction: json["prediction"],
        competitionCluster: json["competition_cluster"],
        status: json["status"],
        federation: json["federation"],
        season: json["season"],
        result: json["result"],
        startDate: DateTime.parse(json["start_date"]),
        odds: Odds.fromMap(json["odds"]),
        homeLogo: json["home_logo"],
        awayLogo: json["away_logo"],
      );

  Map<String, dynamic> toMap() => {
        "home_team": homeTeam,
        "away_team": awayTeam,
        "id": id,
        "market": market,
        "competition_name": competitionName,
        "prediction": prediction,
        "competition_cluster": competitionCluster,
        "status": status,
        "federation": federation,
        "season": season,
        "result": result,
        "start_date": startDate.toIso8601String(),
        "odds": odds.toMap(),
        "home_logo": homeLogo,
        "away_logo": awayLogo,
      };
}

class Odds {
  final num? the1;
  final num? the2;
  final num? the12;
  final num? x;
  final num? the1X;
  final num? x2;
  final num? yes;
  final num? no;

  Odds({
    required this.the1,
    required this.the2,
    required this.the12,
    required this.x,
    required this.the1X,
    required this.x2,
    required this.yes,
    required this.no,
  });

  factory Odds.fromJson(String str) => Odds.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Odds.fromMap(Map<String, dynamic> json) => Odds(
        the1: json["1"],
        the2: json["2"],
        the12: json["12"],
        x: json["X"],
        the1X: json["1X"],
        x2: json["X2"],
        yes: json["yes"],
        no: json["no"],
      );

  Map<String, dynamic> toMap() => {
        "1": the1,
        "2": the2,
        "12": the12,
        "X": x,
        "1X": the1X,
        "X2": x2,
        "yes": yes,
        "no": no,
      };
}
