import 'package:fullproject/models/state_city.dart';

final List<StateModel> states = [
  StateModel(
    id: 1,
    name: 'Tamil Nadu',
    cities: [
      CityModel(id: 1, name: 'Chennai', stateId: 1),
      CityModel(id: 2, name: 'Madurai', stateId: 1),
      CityModel(id: 3, name: 'Coimbatore', stateId: 1),
    ],
  ),
  StateModel(
    id: 2,
    name: 'Kerala',
    cities: [
      CityModel(id: 4, name: 'Kochi', stateId: 2),
      CityModel(id: 5, name: 'Trivandrum', stateId: 2),
      CityModel(id: 6, name: 'Calicut', stateId: 2),
    ],
  ),
  StateModel(
    id: 3,
    name: 'Karnataka',
    cities: [
      CityModel(id: 7, name: 'Bangalore', stateId: 3),
      CityModel(id: 8, name: 'Mysore', stateId: 3),
      CityModel(id: 9, name: 'Hubli', stateId: 3),
    ],
  ),
];
