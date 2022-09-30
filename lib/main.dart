import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shifty/controller/rooster_api.dart';

import 'model/user.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shifty',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loggedIn = false;
  late final User _user;
  var formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shifty'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _loggedIn
                  ? const Text('You are logged in!')
                  : const Text('You are not logged in.'),
              _loggedIn
                  ? ShiftSearch(onLogout: () {
                      setState(() => _loggedIn = false);
                    }, formKey: formKey)
                  : LoginForm(onLogin: (formKey) {
                      setState(() => {
                        this.formKey = formKey,
                        _loggedIn = true,
                      });
                    }),
            ],
          ),
        ));
  }
}

class ShiftSearch extends StatefulWidget {
  const ShiftSearch({Key? key, required Function onLogout, required GlobalKey<FormBuilderState> formKey})
      : _onLogout = onLogout,
        _formKey = formKey,
        super(key: key);

  final Function _onLogout;
  final GlobalKey<FormBuilderState> _formKey;

  @override
  State<ShiftSearch> createState() => _ShiftSearchState();
}

class _ShiftSearchState extends State<ShiftSearch> {
  @override
  Widget build(BuildContext context) {
    String email = widget._formKey.currentState!.fields['email']!.value;
    String id = widget._formKey.currentState!.fields['id']!.value;
    String password = widget._formKey.currentState!.fields['password']!.value;

    return Column(
      children: [
        ElevatedButton(
          onPressed: () => widget._onLogout(),
          child: const Text('Logout'),
        ),
        FutureBuilder(builder: (context, snapshot) {

        },
        future: User.createWithAuth(email, id, password))
      ],
    );
  }
}

class LoginForm extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final Function(GlobalKey<FormBuilderState>) _onLogin;

  LoginForm({super.key, required Function(GlobalKey<FormBuilderState>) onLogin})
      : _onLogin = onLogin;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: _formKey,
        child: Column(children: [
          FormBuilderTextField(
              name: 'email',
              decoration: const InputDecoration(labelText: 'Email')),
          FormBuilderTextField(
              name: 'id', decoration: const InputDecoration(labelText: 'ID')),
          FormBuilderTextField(
              name: 'password',
              decoration: const InputDecoration(labelText: 'Password')),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.saveAndValidate()) {
                _onLogin(_formKey.currentState!);
              }
            },
            child: const Text('Login'),
          ),
        ]));
  }
}
