import 'package:fullproject/models/state_city.dart';

class Users {
  int? id;
  String firstName;
  String lastName;
  String phone;
  String password;
  String gender;
  String dob;
  String? profilePic;

  StateModel? selectedState;
  CityModel? selectedCity;

  Users({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.password,
    required this.gender,
    required this.dob,
    this.profilePic,
    this.selectedState,
    this.selectedCity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'password': password,
      'gender': gender,
      'dob': dob,
      'profilePic': profilePic,
      'state_id': selectedState?.id,
      'city_id': selectedCity?.id,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phone: map['phone'],
      password: map['password'],
      gender: map['gender'],
      dob: map['dob'],
      profilePic: map['profilePic'],
    );
  }
}
