class CovidModel {
  final int localCases;
  final int localDeaths;
  final int localRecovered;
  final int localActiveCases;

  CovidModel({
    this.localCases,
    this.localDeaths,
    this.localRecovered,
    this.localActiveCases,
  });

  factory CovidModel.fromJson(Map<String, dynamic> json) {
    return CovidModel(
      localCases: json['local_new_cases'],
      localDeaths: json['local_deaths'],
      localRecovered: json['local_recovered'],
      localActiveCases: json['local_active_cases'],
    );
  }
}
