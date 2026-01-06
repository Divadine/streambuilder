import 'dart:async';
import 'dart:io';
import 'package:fullproject/models/state_city.dart';

class UserFormState {
  File? image;
  StateModel? state;
  CityModel? city;
  String? gender;
  bool agree;
  Map<String, bool> passwordRules;

  UserFormState({
    this.image,
    this.state,
    this.city,
    this.gender,
    this.agree = false,
    required this.passwordRules,
  });
}

class UserFormStream {
  final _controller = StreamController<UserFormState>.broadcast();

  UserFormState _state = UserFormState(
    passwordRules: {
      "Min 8 chars": false,
      "1 Uppercase": false,
      "1 Number": false,
      "1 Special Char": false,
    },
  );

  Stream<UserFormState> get stream => _controller.stream;
  UserFormState get current => _state;

  void updatePassword(String v) {
    _state.passwordRules = {
      "Min 8 chars": v.length >= 8,
      "1 Uppercase": RegExp(r'[A-Z]').hasMatch(v),
      "1 Number": RegExp(r'\d').hasMatch(v),
      "1 Special Char": RegExp(r'[@$!%*?&]').hasMatch(v),
    };
    _controller.add(_state);
  }

  void updateState(StateModel s) {
    _state.state = s;
    _state.city = null;
    _controller.add(_state);
  }

  void updateCity(CityModel c) {
    _state.city = c;
    _controller.add(_state);
  }

  void updateGender(String g) {
    _state.gender = g;
    _controller.add(_state);
  }

  void updateAgree(bool v) {
    _state.agree = v;
    _controller.add(_state);
  }

  void updateImage(File f) {
    _state.image = f;
    _controller.add(_state);
  }

  void dispose() {
    _controller.close();
  }
}
