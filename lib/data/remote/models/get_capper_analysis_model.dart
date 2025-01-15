class Analysis {
  final List<AnalysisSection> arrows;

  Analysis({required this.arrows});

  factory Analysis.fromJson(Map<String, dynamic> json) {
    var arrowsList = json['arrows'] as List;
    List<AnalysisSection> sections = [];
    
    for (int i = 0; i < arrowsList.length; i++) {
      if (arrowsList[i] is Map<String, dynamic>) {
        sections.add(AnalysisSection.fromJson(arrowsList[i]));
      }
    }
    
    return Analysis(arrows: sections);
  }
}

class AnalysisSection {
  final String title;
  final List<AnalysisResponse> responses;

  AnalysisSection({
    required this.title,
    required this.responses,
  });

  factory AnalysisSection.fromJson(Map<String, dynamic> json) {
    return AnalysisSection(
      title: json['title']?.toString() ?? '',
      responses: (json['responses'] as List?)
          ?.map((e) => AnalysisResponse.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class AnalysisResponse {
  final String response;
  final String emoji;

  AnalysisResponse({
    required this.response,
    required this.emoji,
  });

  factory AnalysisResponse.fromJson(Map<String, dynamic> json) {
    return AnalysisResponse(
      response: json['response']?.toString() ?? '',
      emoji: json['emoji']?.toString() ?? '',
    );
  }
}