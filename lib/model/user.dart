import 'package:shifty/model/shift.dart';

import '../controller/api.dart';

class User {
  static User? instance;

  late final String name;
  final String email;
  final String id;
  final String _password;
  late String _bearer;

  late final String phone;
  late final int group;
  late final int cityId;

  static Future<User> create(String email, String id, String password) async {
    final user = User._(email, id, password);
    await user._init();

    return user;
  }

  User._(this.email, this.id, this._password);

  Future<void> _refreshBearer() async {
    _bearer = 'Bearer ${await API.auth(email, _password)}';
  }

  Future<void> _init() async {
    await _refreshBearer();
    final data = await API.getEmployeeData(_bearer, id);

    name = data['name'];
    phone = data['phone_number'];
    group = data['batch_number'];
    cityId = data['city']['id'];
  }

  Future<void> searchShifts(DateTime start, DateTime end) async {
    Shift.searchResults = await API.getShifts(
        _bearer,
        id,
        cityId,
        start: start,
        end: end,
      );
  }
}
