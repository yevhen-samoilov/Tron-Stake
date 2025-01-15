class HistoryMatchModel {
  final String slug;
  final String sportName;
  final String countryName;
  final String leagueName;
  final String date;
  final String homeTeam;
  final String awayTeam;
  final String prediction;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final String countryLogo;
  final double? w1;
  final double? x;
  final double? w2;
  final bool hasX; // Для определения типа коэффициентов (1X2 или 12)

  HistoryMatchModel({
    required this.slug,
    required this.sportName,
    required this.countryName,
    required this.leagueName,
    required this.date,
    required this.homeTeam,
    required this.awayTeam,
    required this.prediction,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    required this.countryLogo,
    required this.w1,
    required this.x,
    required this.w2,
    required this.hasX,
  });

  Map<String, dynamic> toJson() => {
        'slug': slug,
        'sportName': sportName,
        'countryName': countryName,
        'leagueName': leagueName,
        'date': date,
        'homeTeam': homeTeam,
        'awayTeam': awayTeam,
        'prediction': prediction,
        'homeTeamLogo': homeTeamLogo,
        'awayTeamLogo': awayTeamLogo,
        'countryLogo': countryLogo,
        'w1': w1,
        'x': x,
        'w2': w2,
        'hasX': hasX,
      };

  factory HistoryMatchModel.fromJson(Map<String, dynamic> json) =>
      HistoryMatchModel(
        slug: json['slug'],
        sportName: json['sportName'],
        countryName: json['countryName'],
        leagueName: json['leagueName'],
        date: json['date'],
        homeTeam: json['homeTeam'],
        awayTeam: json['awayTeam'],
        prediction: json['prediction'],
        homeTeamLogo: json['homeTeamLogo'],
        awayTeamLogo: json['awayTeamLogo'],
        countryLogo: json['countryLogo'],
        w1: json['w1']?.toDouble(),
        x: json['x']?.toDouble(),
        w2: json['w2']?.toDouble(),
        hasX: json['hasX'],
      );
}