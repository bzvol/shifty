import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shifty/controller/debugger.dart';

import '../main.dart';
import '../model/user.dart';
import '../shared/user_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _loggedIn = false;
  var formKey = GlobalKey<FormBuilderState>();

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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
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
                  ? const Text('You are logged in!')
                  : const Text('You are not logged in.'),
              _loggedIn
                  ? ShiftSearch(
                      onLogout: () {
                        setState(() => {
                              _loggedIn = false,
                              App.user = null,
                            });
                      },
                      formKey: formKey)
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

  void refresh() => setState(() {});
}

class ShiftSearch extends StatefulWidget {
  const ShiftSearch(
      {Key? key,
      required Function onLogout,
      required GlobalKey<FormBuilderState> formKey})
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
        const SizedBox(height: 24.0),
        FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              App.user = snapshot.data as User;
              return UserCard(App.user!);
            } else {
              return const CircularProgressIndicator();
            }
          },
          future: User.create(email, id, password),
        )
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
