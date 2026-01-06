class StateModel {
  final int id;
  final String name;
  final List<CityModel> cities;

  StateModel({
    required this.id,
    required this.name,
    required this.cities,
  });
}

class CityModel {
  final int id;
  final String name;
  final int stateId;

  CityModel({
    required this.id,
    required this.name,
    required this.stateId,
  });
}
