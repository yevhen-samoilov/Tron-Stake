import 'dart:convert';

class GetWitnessModel {
  final num? total;
  final LastBlock lastBlock;
  final List<Witness> data;

  GetWitnessModel({
    required this.total,
    required this.lastBlock,
    required this.data,
  });

  factory GetWitnessModel.fromJson(String str) =>
      GetWitnessModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetWitnessModel.fromMap(Map<String, dynamic> json) => GetWitnessModel(
        total: json["total"],
        lastBlock: LastBlock.fromMap(json["lastBlock"]),
        data: List<Witness>.from(json["data"].map((x) => Witness.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "lastBlock": lastBlock.toMap(),
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Witness {
  final String? address;
  final String? name;
  final String? url;
  final bool producer;
  final String? witnessStatus;
  final num? latestBlockNumber;
  final num? latestSlotNumber;
  final num? missedTotal;
  final num? producedTotal;
  final num? producedTrx;
  final num? votes;
  final num? changeVotes;
  final num? realTimeVotes;
  final num? brokerage;
  final String? annualizedRate;
  final num? producePercentage;
  final num? version;
  final num? witnessType;
  final num? index;
  final num? totalOutOfTimeTrans;
  final num? lastWeekOutOfTimeTrans;
  final bool changedBrokerage;
  final num? lowestBrokerage;
  final num? votesPercentage;

  Witness({
    required this.address,
    required this.name,
    required this.url,
    required this.producer,
    required this.witnessStatus,
    required this.latestBlockNumber,
    required this.latestSlotNumber,
    required this.missedTotal,
    required this.producedTotal,
    required this.producedTrx,
    required this.votes,
    required this.changeVotes,
    required this.realTimeVotes,
    required this.brokerage,
    required this.annualizedRate,
    required this.producePercentage,
    required this.version,
    required this.witnessType,
    required this.index,
    required this.totalOutOfTimeTrans,
    required this.lastWeekOutOfTimeTrans,
    required this.changedBrokerage,
    required this.lowestBrokerage,
    required this.votesPercentage,
  });

  factory Witness.fromJson(String str) => Witness.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Witness.fromMap(Map<String, dynamic> json) => Witness(
        address: json["address"],
        name: json["name"],
        url: json["url"],
        producer: json["producer"],
        witnessStatus: json["witnessStatus"],
        latestBlockNumber: json["latestBlockNumber"],
        latestSlotNumber: json["latestSlotNumber"],
        missedTotal: json["missedTotal"],
        producedTotal: json["producedTotal"],
        producedTrx: json["producedTrx"],
        votes: json["votes"],
        changeVotes: json["changeVotes"],
        realTimeVotes: json["realTimeVotes"],
        brokerage: json["brokerage"],
        annualizedRate: json["annualizedRate"],
        producePercentage: json["producePercentage"],
        version: json["version"],
        witnessType: json["witnessType"],
        index: json["index"],
        totalOutOfTimeTrans: json["totalOutOfTimeTrans"],
        lastWeekOutOfTimeTrans: json["lastWeekOutOfTimeTrans"],
        changedBrokerage: json["changedBrokerage"],
        lowestBrokerage: json["lowestBrokerage"],
        votesPercentage: json["votesPercentage"],
      );

  Map<String, dynamic> toMap() => {
        "address": address,
        "name": name,
        "url": url,
        "producer": producer,
        "witnessStatus": witnessStatus,
        "latestBlockNumber": latestBlockNumber,
        "latestSlotNumber": latestSlotNumber,
        "missedTotal": missedTotal,
        "producedTotal": producedTotal,
        "producedTrx": producedTrx,
        "votes": votes,
        "changeVotes": changeVotes,
        "realTimeVotes": realTimeVotes,
        "brokerage": brokerage,
        "annualizedRate": annualizedRate,
        "producePercentage": producePercentage,
        "version": version,
        "witnessType": witnessType,
        "index": index,
        "totalOutOfTimeTrans": totalOutOfTimeTrans,
        "lastWeekOutOfTimeTrans": lastWeekOutOfTimeTrans,
        "changedBrokerage": changedBrokerage,
        "lowestBrokerage": lowestBrokerage,
        "votesPercentage": votesPercentage,
      };
}

class LastBlock {
  final String? hash;
  final bool confirmed;
  final num? number;
  final num? size;
  final num? timestamp;
  final String? parentHash;
  final String? witnessAddress;
  final num? nrOfTrx;
  final String? txTrieRoot;
  final num? witnessId;

  LastBlock({
    required this.hash,
    required this.confirmed,
    required this.number,
    required this.size,
    required this.timestamp,
    required this.parentHash,
    required this.witnessAddress,
    required this.nrOfTrx,
    required this.txTrieRoot,
    required this.witnessId,
  });

  factory LastBlock.fromJson(String str) => LastBlock.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LastBlock.fromMap(Map<String, dynamic> json) => LastBlock(
        hash: json["hash"],
        confirmed: json["confirmed"],
        number: json["number"],
        size: json["size"],
        timestamp: json["timestamp"],
        parentHash: json["parentHash"],
        witnessAddress: json["witnessAddress"],
        nrOfTrx: json["nrOfTrx"],
        txTrieRoot: json["txTrieRoot"],
        witnessId: json["witnessId"],
      );

  Map<String, dynamic> toMap() => {
        "hash": hash,
        "confirmed": confirmed,
        "number": number,
        "size": size,
        "timestamp": timestamp,
        "parentHash": parentHash,
        "witnessAddress": witnessAddress,
        "nrOfTrx": nrOfTrx,
        "txTrieRoot": txTrieRoot,
        "witnessId": witnessId,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
