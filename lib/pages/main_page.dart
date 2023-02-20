import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shifty/model/user.dart';

import '../main.dart';
import 'home_page.dart';
import 'login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _checkLogin());
  }

  @override
  Widget build(BuildContext context) =>
      _loggedIn ? HomePage(onLogout: _onLogout) : LoginPage(onLogin: _onLogin);

  Future<void> _checkLogin() async {
    return;

    /*if (await const FlutterSecureStorage().containsKey(key: 'id')) {
      setState(() => _loggedIn = true);
    }*/
  }

  Future<void> _onLogin(GlobalKey<FormBuilderState> formKey) async {
    final fields = formKey.currentState!.fields;

    const storage = FlutterSecureStorage();
    await storage.write(key: 'email', value: fields['email']!.value);
    await storage.write(key: 'id', value: fields['id']!.value);
    await storage.write(key: 'password', value: fields['password']!.value);

    setState(() => _loggedIn = true);
  }

  Future<void> _onLogout() async {
    await const FlutterSecureStorage().deleteAll();
    setState(() => {
          _loggedIn = false,
          User.instance = null,
        });
  }
}
