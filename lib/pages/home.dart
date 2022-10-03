import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart';
import 'package:shifty/controller/api.dart';
import 'package:shifty/controller/debugger.dart';
import 'package:shifty/model/zones.dart';

import '../main.dart';
import '../model/shift.dart';
import '../model/user.dart';
import '../shared/user_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _loggedIn = false;
  var loginFormFields = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    Debugger.context = context;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shifty'),
          centerTitle: true,
        ),
        drawer: Drawer(
            child: SafeArea(
              child: ListView(padding: const EdgeInsets.all(16), children: [
                if (kDebugMode) ...[
                  const Text('HTTP Responses',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24)),
                  const SizedBox(height: 16),
                  ...Debugger.responses
                      .map((response) => HttpResponseCard(response)),
                ]
              ]),
            )),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _loggedIn
                  ? ShiftSearch(
                onLogout: () {
                  setState(() =>
                  {
                    _loggedIn = false,
                    App.user = null,
                  });
                },
                loginFormFields: loginFormFields,
              )
                  : LoginForm(onLogin: (formKey) {
                setState(() =>
                {
                  loginFormFields = formKey.currentState!.fields,
                  _loggedIn = true,
                });
              }),
            ],
          ),
        ));
  }

  void refreshDebugger(List<Response> list, Response response) =>
      setState(() {
        list = [...list, response];
      });
}

class ShiftSearch extends StatefulWidget {
  const ShiftSearch({Key? key,
    required Function onLogout,
    required Map<String, dynamic> loginFormFields})
      : _onLogout = onLogout,
        _loginFormFields = loginFormFields,
        super(key: key);

  final Function _onLogout;
  final Map<String, dynamic> _loginFormFields;

  @override
  State<ShiftSearch> createState() => _ShiftSearchState();
}

class _ShiftSearchState extends State<ShiftSearch> {
  @override
  Widget build(BuildContext context) {
    String email = widget._loginFormFields['email']!.value;
    String id = widget._loginFormFields['id']!.value;
    String password = widget._loginFormFields['password']!.value;

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          App.user = snapshot.data as User;
          // return ;
          return Column(
            children: [
              ElevatedButton(
                onPressed: () => widget._onLogout(),
                child: const Text('Logout'),
              ),
              const SizedBox(height: 24.0),
              UserCard(App.user!),
              const SizedBox(height: 24.0),
              /*ElevatedButton(
                onPressed: () => {

                },
                child: const Text('Search'),
              ),*/
              FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: ListView(
                          children: Shift.searchResults.map((s) =>
                              Text("- ${zones[s.zoneId]} ${s.start
                                  .toString()} -> ${s.end.toString()} (${s.type
                                  .toString()})")).toList(),
                        )
                    );
                  }
                  else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return const LinearProgressIndicator();
                },
                future: App.user!.searchShifts(_getStart(), _getEnd()),
              )
            ],
          );
        }
        return const CircularProgressIndicator();
      },
      future: User.create(email, id, password),
    );
  }

  DateTime _getStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 0, 0, 0);
  }

  DateTime _getEnd() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
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
              decoration: const InputDecoration(labelText: 'Email'),
              autofillHints: const [AutofillHints.email],
              validator: (value) {
                final mailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                } else if (!mailPattern.hasMatch(value)) {
                  return 'Email is invalid';
                }
                return null;
              }),
          FormBuilderTextField(
              name: 'id',
              decoration: const InputDecoration(labelText: 'ID'),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty || value.length != 7) {
                  return '7-digit ID required';
                }
                return null;
              }),
          FormBuilderTextField(
              name: 'password',
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              autofillHints: const [AutofillHints.password],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                return null;
              }),
          const SizedBox(height: 12.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.saveAndValidate()) {
                _onLogin(_formKey);
              }
            },
            child: const Text('Login'),
          ),
        ]));
  }
}
