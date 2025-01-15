import 'package:tron_stake/data/remote/models/get_capper_matches_model.dart'
    as model;

class LeagueWithCountry {
  final String id;
  final String name;
  final String slug;
  final String logo;
  final CountryInfo country;
  final List<model.Match> matches;
  final bool expand;

  LeagueWithCountry({
    required this.id,
    required this.name,
    required this.slug,
    required this.logo,
    required this.country,
    required this.matches,
    this.expand = false,
  });

  factory LeagueWithCountry.fromMap(Map<String, dynamic> map) {
    final countryData = map['country'] as Map<String, dynamic>?;
    final country = countryData != null
        ? CountryInfo.fromMap(countryData)
        : CountryInfo.all();

    final matchesData = map['matches'] as List?;
    final matches = matchesData
        ?.map((m) => model.Match.fromMap(m))
        .where((match) => match.status != 100)
        .toList() ?? [];

    return LeagueWithCountry(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      slug: map['slug']?.toString() ?? '',
      logo: map['logo']?.toString() ?? '',
      country: country,
      matches: matches,
    );
  }
}

class CountryInfo {
  final String id;
  final String name;
  final String slug;
  final String? logo;

  CountryInfo({
    required this.id,
    required this.name,
    required this.slug,
    this.logo,
  });

  static CountryInfo fromMap(Map<String, dynamic> map) {
    return CountryInfo(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      slug: map['slug']?.toString() ?? '',
      logo: map['logo']?.toString(),
    );
  }

  static CountryInfo all() => CountryInfo(
        id: 'all',
        name: 'All Countries',
        slug: 'all',
      );
}
