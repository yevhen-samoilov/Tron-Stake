import 'dart:convert';

class GetCapperMatchesModel {
  final String? id;
  final String? name;
  final String? slug;
  final String? logo;
  final Country country;
  final num? priority;
  final bool expand;
  final List<Match> matches;

  GetCapperMatchesModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.logo,
    required this.country,
    required this.priority,
    required this.expand,
    required this.matches,
  });

  factory GetCapperMatchesModel.fromJson(String str) =>
      GetCapperMatchesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetCapperMatchesModel.fromMap(Map<String, dynamic>? json) =>
      GetCapperMatchesModel(
        id: json?["id"],
        name: json?["name"],
        slug: json?["slug"],
        logo: json?["logo"],
        country: Country.fromMap(json?["country"]),
        priority: json?["priority"],
        expand: json?["expand"],
        matches: List<Match>.from(json?["matches"].map((x) => Match.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "slug": slug,
        "logo": logo,
        "country": country.toMap(),
        "priority": priority,
        "expand": expand,
        "matches": List<dynamic>.from(matches.map((x) => x.toMap())),
      };
}

class Country {
  final String? id;
  final String? slug;
  final String? name;
  final String? iso;
  final String? ioc;
  final String? logo;

  Country({
    this.id,
    this.slug,
    this.name,
    this.iso,
    this.ioc,
    this.logo,
  });

  factory Country.fromJson(String str) => Country.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Country.fromMap(Map<String, dynamic>? json) => Country(
        id: json?["id"]?.toString(),
        slug: json?["slug"]?.toString(),
        name: json?["name"]?.toString(),
        iso: json?["iso"]?.toString(),
        ioc: json?["ioc"]?.toString(),
        logo: json?["logo"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "slug": slug,
        "name": name,
        "iso": iso,
        "ioc": ioc,
        "logo": logo,
      };
}

class Match {
  final String? id;
  final String? slug;
  final String? sportSlug;
  final String? leagueSlug;
  final String? matchDate;
  final String? matchEndedAt;
  final Teams teams;
  final bool isLive;
  final dynamic minute;
  final num? winner;
  final Odds odds;
  final UserPrediction userPrediction;
  final PredictionStats predictionStats;
  final List<String>? result;
  final ResultScores? resultScores;
  final String? score;
  final num? status;
  final String? prediction;
  final dynamic popularOutcomes;

  Match({
    required this.id,
    required this.slug,
    required this.sportSlug,
    required this.leagueSlug,
    required this.matchDate,
    required this.matchEndedAt,
    required this.teams,
    required this.isLive,
    required this.minute,
    required this.winner,
    required this.odds,
    required this.userPrediction,
    required this.predictionStats,
    this.result,
    this.resultScores,
    required this.score,
    required this.status,
    required this.prediction,
    required this.popularOutcomes,
  });

  factory Match.fromJson(String str) => Match.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Match.fromMap(Map<String, dynamic>? json) => Match(
        id: json?["id"]?.toString(),
        slug: json?["slug"]?.toString(),
        sportSlug: json?["sportSlug"]?.toString(),
        leagueSlug: json?["leagueSlug"]?.toString(),
        matchDate: json?["matchDate"]?.toString(),
        matchEndedAt: json?["matchEndedAt"]?.toString(),
        teams: json?["teams"] == null
            ? Teams.fromMap({})
            : Teams.fromMap(json?["teams"] as Map<String, dynamic>),
        isLive: json?["isLive"] ?? false,
        minute: json?["minute"],
        winner: json?["winner"] as num?,
        odds: json?["odds"] == null
            ? Odds.fromMap({})
            : Odds.fromMap(json?["odds"] as Map<String, dynamic>),
        userPrediction: json?["userPrediction"] == null
            ? UserPrediction.fromMap({})
            : UserPrediction.fromMap(
                json?["userPrediction"] as Map<String, dynamic>),
        predictionStats: json?["predictionStats"] == null
            ? PredictionStats.fromMap({})
            : PredictionStats.fromMap(
                json?["predictionStats"] as Map<String, dynamic>),
        result: json?["result"] == null
            ? []
            : List<String>.from(json?["result"].map((x) => x.toString())),
        resultScores: json?["resultScores"] == null
            ? ResultScores.fromMap({})
            : ResultScores.fromMap(
                json?["resultScores"] as Map<String, dynamic>),
        score: json?["score"]?.toString() ?? "",
        status: json?["status"] as num?,
        prediction: json?["prediction"]?.toString() ?? "",
        popularOutcomes: json?["popularOutcomes"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "slug": slug,
        "sportSlug": sportSlug,
        "leagueSlug": leagueSlug,
        "matchDate": matchDate,
        "matchEndedAt": matchEndedAt,
        "teams": teams.toMap(),
        "isLive": isLive,
        "minute": minute,
        "winner": winner,
        "odds": odds.toMap(),
        "userPrediction": userPrediction.toMap(),
        "predictionStats": predictionStats.toMap(),
        "result": List<dynamic>.from(result ?? []),
        "resultScores": resultScores?.toMap(),
        "score": score,
        "status": status,
        "prediction": prediction,
        "popularOutcomes": popularOutcomes,
      };
}

class Odds {
  final OneXTwo? oneXTwo;
  final OneTwo? oneTwo;

  Odds({
    this.oneXTwo,
    this.oneTwo,
  });

  factory Odds.fromJson(String str) => Odds.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Odds.fromMap(Map<String, dynamic>? json) => Odds(
        oneXTwo: json?["one_x_two"] == null
            ? null
            : OneXTwo.fromMap(json?["one_x_two"] as Map<String, dynamic>),
        oneTwo: json?["one_two"] == null
            ? null
            : OneTwo.fromMap(json?["one_two"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        "one_x_two": oneXTwo?.toMap(),
        "one_two": oneTwo?.toMap(),
      };
}

class OneTwo {
  final W1 w1;
  final W1 w2;

  OneTwo({
    required this.w1,
    required this.w2,
  });

  factory OneTwo.fromJson(String str) => OneTwo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OneTwo.fromMap(Map<String, dynamic>? json) => OneTwo(
        w1: W1.fromMap(json?["w1"]),
        w2: W1.fromMap(json?["w2"]),
      );

  Map<String, dynamic> toMap() => {
        "w1": w1.toMap(),
        "w2": w2.toMap(),
      };
}

class W1 {
  final String? type;
  final String? outcome;
  final num? value;
  final dynamic change;

  W1({
    required this.type,
    required this.outcome,
    required this.value,
    required this.change,
  });

  factory W1.fromJson(String str) => W1.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory W1.fromMap(Map<String, dynamic>? json) => W1(
        type: json?["type"],
        outcome: json?["outcome"],
        value: json?["value"] ?? 0,
        change: json?["change"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "outcome": outcome,
        "value": value,
        "change": change,
      };
}

class OneXTwo {
  final W1 w1;
  final W1 x;
  final W1 w2;

  OneXTwo({
    required this.w1,
    required this.x,
    required this.w2,
  });

  factory OneXTwo.fromJson(String str) => OneXTwo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OneXTwo.fromMap(Map<String, dynamic>? json) => OneXTwo(
        w1: W1.fromMap(json?["w1"]),
        x: W1.fromMap(json?["x"]),
        w2: W1.fromMap(json?["w2"]),
      );

  Map<String, dynamic> toMap() => {
        "w1": w1.toMap(),
        "x": x.toMap(),
        "w2": w2.toMap(),
      };
}

class PredictionStats {
  final num? total;
  final bool haveExpertPredictions;

  PredictionStats({
    required this.total,
    required this.haveExpertPredictions,
  });

  factory PredictionStats.fromJson(String str) =>
      PredictionStats.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PredictionStats.fromMap(Map<String, dynamic>? json) => PredictionStats(
        total: json?["total"],
        haveExpertPredictions: json?["haveExpertPredictions"],
      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "haveExpertPredictions": haveExpertPredictions,
      };
}

class ResultScores {
  final String? halfTime;
  final String? total;
  final String? the1;
  final String? the2;
  final String? the3;
  final String? the4;
  final String? overTime;
  final String? the5;
  final String? the6;
  final String? the7;
  final String? the8;
  final String? the9;
  final String? afterPenalty;

  ResultScores({
    required this.halfTime,
    required this.total,
    required this.the1,
    required this.the2,
    required this.the3,
    required this.the4,
    required this.overTime,
    required this.the5,
    required this.the6,
    required this.the7,
    required this.the8,
    required this.the9,
    required this.afterPenalty,
  });

  factory ResultScores.fromJson(String str) =>
      ResultScores.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResultScores.fromMap(Map<String, dynamic>? json) => ResultScores(
        halfTime: json?["halfTime"]?.toString(),
        total: json?["total"]?.toString(),
        the1: json?["1"]?.toString(),
        the2: json?["2"]?.toString(),
        the3: json?["3"]?.toString(),
        the4: json?["4"]?.toString(),
        overTime: json?["overTime"]?.toString(),
        the5: json?["5"]?.toString(),
        the6: json?["6"]?.toString(),
        the7: json?["7"]?.toString(),
        the8: json?["8"]?.toString(),
        the9: json?["9"]?.toString(),
        afterPenalty: json?["afterPenalty"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "halfTime": halfTime,
        "total": total,
        "1": the1,
        "2": the2,
        "3": the3,
        "4": the4,
        "overTime": overTime,
        "5": the5,
        "6": the6,
        "7": the7,
        "8": the8,
        "9": the9,
        "afterPenalty": afterPenalty,
      };
}

class Teams {
  final Away home;
  final Away away;

  Teams({
    required this.home,
    required this.away,
  });

  factory Teams.fromJson(String str) => Teams.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Teams.fromMap(Map<String, dynamic>? json) => Teams(
        home: Away.fromMap(json?["home"] as Map<String, dynamic>? ?? {}),
        away: Away.fromMap(json?["away"] as Map<String, dynamic>? ?? {}),
      );

  Map<String, dynamic> toMap() => {
        "home": home.toMap(),
        "away": away.toMap(),
      };
}

class Away {
  final String? id;
  final String? slug;
  final String? logo;
  final String? name;
  final String? shortName;
  final dynamic statistic;
  final Country? country;
  final dynamic pastMatches;
  final dynamic tennisRankingInfo;

  Away({
    this.id,
    this.slug,
    this.logo,
    this.name,
    this.shortName,
    this.statistic,
    this.country,
    this.pastMatches,
    this.tennisRankingInfo,
  });

  factory Away.fromJson(String str) => Away.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Away.fromMap(Map<String, dynamic>? json) => Away(
        id: json?["id"]?.toString(),
        slug: json?["slug"]?.toString(),
        logo: json?["logo"]?.toString(),
        name: json?["name"]?.toString(),
        shortName: json?["shortName"]?.toString(),
        statistic: json?["statistic"],
        country: json?["country"] == null
            ? null
            : Country.fromMap(json?["country"] as Map<String, dynamic>),
        pastMatches: json?["pastMatches"],
        tennisRankingInfo: json?["tennisRankingInfo"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "slug": slug,
        "logo": logo,
        "name": name,
        "shortName": shortName,
        "statistic": statistic,
        "country": country?.toMap(),
        "pastMatches": pastMatches,
        "tennisRankingInfo": tennisRankingInfo,
      };
}

class StatisticClass {
  final num? corners;
  final num? yellowCards;
  final num? redCards;
  final num? fouls;
  final num? offsides;
  final num? throwIns;
  final num? cardsGiven;
  final num? freeKicks;
  final num? goalkeeperKicks;
  final num? injuries;
  final num? shotsBlocked;
  final num? shotsOffGoal;
  final num? shotsOnGoal;
  final num? goalkeeperSaves;
  final num? shotsTotal;
  final num? substitutions;
  final num? yellowRedCards;
  final num? ballPossession;
  final num? xg;
  final String? tennisGames;
  final num? goalsConceded;
  final num? goalsInPowerPlay;
  final num? goalsWhileShortHanded;
  final num? penalties;
  final num? penaltyMinutes;
  final num? powerPlays;
  final num? puckPossession;
  final num? saves;
  final num? shutouts;
  final num? assists;
  final num? biggestLead;
  final num? defensiveRebounds;
  final num? freeThrowAttemptsSuccessful;
  final num? freeThrowAttemptsTotal;
  final num? offensiveRebounds;
  final num? rebounds;
  final num? steals;
  final num? teamLeads;
  final num? teamRebounds;
  final num? teamTurnovers;
  final num? threePonumAttemptsSuccessful;
  final num? threePonumAttemptsTotal;
  final num? timeSpentInLead;
  final num? timeouts;
  final num? turnovers;
  final num? twoPonumAttemptsSuccessful;
  final num? twoPonumAttemptsTotal;
  final num? aces;
  final num? breakponumsWon;
  final num? numFaults;
  final num? firstServePonumsWon;
  final num? firstServeSuccessful;
  final num? gamesWon;
  final num? maxGamesInARow;
  final num? maxPonumsInARow;
  final num? ponumsWon;
  final num? secondServePonumsWon;
  final num? secondServeSuccessful;
  final num? serviceGamesWon;
  final num? servicePonumsLost;
  final num? servicePonumsWon;
  final num? tiebreaksWon;
  final num? totalBreakponums;
  final num? leaderAssists;
  final String? leaderAssistsPlayer;
  final num? leaderPonums;
  final String? leaderPonumsPlayer;
  final num? leaderRebounds;
  final String? leaderReboundsPlayer;
  final dynamic volleyballGames;

  StatisticClass({
    required this.corners,
    required this.yellowCards,
    required this.redCards,
    required this.fouls,
    required this.offsides,
    required this.throwIns,
    required this.cardsGiven,
    required this.freeKicks,
    required this.goalkeeperKicks,
    required this.injuries,
    required this.shotsBlocked,
    required this.shotsOffGoal,
    required this.shotsOnGoal,
    required this.goalkeeperSaves,
    required this.shotsTotal,
    required this.substitutions,
    required this.yellowRedCards,
    required this.ballPossession,
    required this.xg,
    required this.tennisGames,
    required this.goalsConceded,
    required this.goalsInPowerPlay,
    required this.goalsWhileShortHanded,
    required this.penalties,
    required this.penaltyMinutes,
    required this.powerPlays,
    required this.puckPossession,
    required this.saves,
    required this.shutouts,
    required this.assists,
    required this.biggestLead,
    required this.defensiveRebounds,
    required this.freeThrowAttemptsSuccessful,
    required this.freeThrowAttemptsTotal,
    required this.offensiveRebounds,
    required this.rebounds,
    required this.steals,
    required this.teamLeads,
    required this.teamRebounds,
    required this.teamTurnovers,
    required this.threePonumAttemptsSuccessful,
    required this.threePonumAttemptsTotal,
    required this.timeSpentInLead,
    required this.timeouts,
    required this.turnovers,
    required this.twoPonumAttemptsSuccessful,
    required this.twoPonumAttemptsTotal,
    required this.aces,
    required this.breakponumsWon,
    required this.numFaults,
    required this.firstServePonumsWon,
    required this.firstServeSuccessful,
    required this.gamesWon,
    required this.maxGamesInARow,
    required this.maxPonumsInARow,
    required this.ponumsWon,
    required this.secondServePonumsWon,
    required this.secondServeSuccessful,
    required this.serviceGamesWon,
    required this.servicePonumsLost,
    required this.servicePonumsWon,
    required this.tiebreaksWon,
    required this.totalBreakponums,
    required this.leaderAssists,
    required this.leaderAssistsPlayer,
    required this.leaderPonums,
    required this.leaderPonumsPlayer,
    required this.leaderRebounds,
    required this.leaderReboundsPlayer,
    required this.volleyballGames,
  });

  factory StatisticClass.fromJson(String str) =>
      StatisticClass.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StatisticClass.fromMap(Map<String, dynamic>? json) => StatisticClass(
        corners: json?["corners"],
        yellowCards: json?["yellowCards"],
        redCards: json?["redCards"],
        fouls: json?["fouls"],
        offsides: json?["offsides"],
        throwIns: json?["throwIns"],
        cardsGiven: json?["cardsGiven"],
        freeKicks: json?["freeKicks"],
        goalkeeperKicks: json?["goalkeeperKicks"],
        injuries: json?["injuries"],
        shotsBlocked: json?["shotsBlocked"],
        shotsOffGoal: json?["shotsOffGoal"],
        shotsOnGoal: json?["shotsOnGoal"],
        goalkeeperSaves: json?["goalkeeperSaves"],
        shotsTotal: json?["shotsTotal"],
        substitutions: json?["substitutions"],
        yellowRedCards: json?["yellowRedCards"],
        ballPossession: json?["ballPossession"],
        xg: json?["xg"] ?? 0,
        tennisGames: json?["tennisGames"],
        goalsConceded: json?["goalsConceded"],
        goalsInPowerPlay: json?["goalsInPowerPlay"],
        goalsWhileShortHanded: json?["goalsWhileShortHanded"],
        penalties: json?["penalties"],
        penaltyMinutes: json?["penaltyMinutes"],
        powerPlays: json?["powerPlays"],
        puckPossession: json?["puckPossession"],
        saves: json?["saves"],
        shutouts: json?["shutouts"],
        assists: json?["assists"],
        biggestLead: json?["biggestLead"],
        defensiveRebounds: json?["defensiveRebounds"],
        freeThrowAttemptsSuccessful: json?["freeThrowAttemptsSuccessful"],
        freeThrowAttemptsTotal: json?["freeThrowAttemptsTotal"],
        offensiveRebounds: json?["offensiveRebounds"],
        rebounds: json?["rebounds"],
        steals: json?["steals"],
        teamLeads: json?["teamLeads"],
        teamRebounds: json?["teamRebounds"],
        teamTurnovers: json?["teamTurnovers"],
        threePonumAttemptsSuccessful: json?["threePonumAttemptsSuccessful"],
        threePonumAttemptsTotal: json?["threePonumAttemptsTotal"],
        timeSpentInLead: json?["timeSpentInLead"],
        timeouts: json?["timeouts"],
        turnovers: json?["turnovers"],
        twoPonumAttemptsSuccessful: json?["twoPonumAttemptsSuccessful"],
        twoPonumAttemptsTotal: json?["twoPonumAttemptsTotal"],
        aces: json?["aces"],
        breakponumsWon: json?["breakponumsWon"],
        numFaults: json?["numFaults"],
        firstServePonumsWon: json?["firstServePonumsWon"],
        firstServeSuccessful: json?["firstServeSuccessful"],
        gamesWon: json?["gamesWon"],
        maxGamesInARow: json?["maxGamesInARow"],
        maxPonumsInARow: json?["maxPonumsInARow"],
        ponumsWon: json?["ponumsWon"],
        secondServePonumsWon: json?["secondServePonumsWon"],
        secondServeSuccessful: json?["secondServeSuccessful"],
        serviceGamesWon: json?["serviceGamesWon"],
        servicePonumsLost: json?["servicePonumsLost"],
        servicePonumsWon: json?["servicePonumsWon"],
        tiebreaksWon: json?["tiebreaksWon"],
        totalBreakponums: json?["totalBreakponums"],
        leaderAssists: json?["leaderAssists"],
        leaderAssistsPlayer: json?["leaderAssistsPlayer"],
        leaderPonums: json?["leaderPonums"],
        leaderPonumsPlayer: json?["leaderPonumsPlayer"],
        leaderRebounds: json?["leaderRebounds"],
        leaderReboundsPlayer: json?["leaderReboundsPlayer"],
        volleyballGames: json?["volleyballGames"],
      );

  Map<String, dynamic> toMap() => {
        "corners": corners,
        "yellowCards": yellowCards,
        "redCards": redCards,
        "fouls": fouls,
        "offsides": offsides,
        "throwIns": throwIns,
        "cardsGiven": cardsGiven,
        "freeKicks": freeKicks,
        "goalkeeperKicks": goalkeeperKicks,
        "injuries": injuries,
        "shotsBlocked": shotsBlocked,
        "shotsOffGoal": shotsOffGoal,
        "shotsOnGoal": shotsOnGoal,
        "goalkeeperSaves": goalkeeperSaves,
        "shotsTotal": shotsTotal,
        "substitutions": substitutions,
        "yellowRedCards": yellowRedCards,
        "ballPossession": ballPossession,
        "xg": xg,
        "tennisGames": tennisGames,
        "goalsConceded": goalsConceded,
        "goalsInPowerPlay": goalsInPowerPlay,
        "goalsWhileShortHanded": goalsWhileShortHanded,
        "penalties": penalties,
        "penaltyMinutes": penaltyMinutes,
        "powerPlays": powerPlays,
        "puckPossession": puckPossession,
        "saves": saves,
        "shutouts": shutouts,
        "assists": assists,
        "biggestLead": biggestLead,
        "defensiveRebounds": defensiveRebounds,
        "freeThrowAttemptsSuccessful": freeThrowAttemptsSuccessful,
        "freeThrowAttemptsTotal": freeThrowAttemptsTotal,
        "offensiveRebounds": offensiveRebounds,
        "rebounds": rebounds,
        "steals": steals,
        "teamLeads": teamLeads,
        "teamRebounds": teamRebounds,
        "teamTurnovers": teamTurnovers,
        "threePonumAttemptsSuccessful": threePonumAttemptsSuccessful,
        "threePonumAttemptsTotal": threePonumAttemptsTotal,
        "timeSpentInLead": timeSpentInLead,
        "timeouts": timeouts,
        "turnovers": turnovers,
        "twoPonumAttemptsSuccessful": twoPonumAttemptsSuccessful,
        "twoPonumAttemptsTotal": twoPonumAttemptsTotal,
        "aces": aces,
        "breakponumsWon": breakponumsWon,
        "numFaults": numFaults,
        "firstServePonumsWon": firstServePonumsWon,
        "firstServeSuccessful": firstServeSuccessful,
        "gamesWon": gamesWon,
        "maxGamesInARow": maxGamesInARow,
        "maxPonumsInARow": maxPonumsInARow,
        "ponumsWon": ponumsWon,
        "secondServePonumsWon": secondServePonumsWon,
        "secondServeSuccessful": secondServeSuccessful,
        "serviceGamesWon": serviceGamesWon,
        "servicePonumsLost": servicePonumsLost,
        "servicePonumsWon": servicePonumsWon,
        "tiebreaksWon": tiebreaksWon,
        "totalBreakponums": totalBreakponums,
        "leaderAssists": leaderAssists,
        "leaderAssistsPlayer": leaderAssistsPlayer,
        "leaderPonums": leaderPonums,
        "leaderPonumsPlayer": leaderPonumsPlayer,
        "leaderRebounds": leaderRebounds,
        "leaderReboundsPlayer": leaderReboundsPlayer,
        "volleyballGames": volleyballGames,
      };
}

class UserPrediction {
  final bool exists;
  final dynamic status;

  UserPrediction({
    required this.exists,
    required this.status,
  });

  factory UserPrediction.fromJson(String str) =>
      UserPrediction.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserPrediction.fromMap(Map<String, dynamic>? json) => UserPrediction(
        exists: json?["exists"],
        status: json?["status"],
      );

  Map<String, dynamic> toMap() => {
        "exists": exists,
        "status": status,
      };
}
