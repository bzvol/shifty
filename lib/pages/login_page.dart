import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final void Function(GlobalKey<FormBuilderState>) _onLogin;

  LoginPage(
      {super.key, required void Function(GlobalKey<FormBuilderState>) onLogin})
      : _onLogin = onLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to Shifty'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FormBuilder(
            key: _formKey,
            child: Column(children: [
              buildEmailField(),
              buildIdField(),
              buildPasswordField(),
              const SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.saveAndValidate()) {
                    _onLogin(_formKey);
                  }
                },
                child: const Text('Login'),
              ),
            ])),
      ),
    );
  }

  final _mailPattern = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
  FormBuilderTextField buildEmailField() => FormBuilderTextField(
      name: 'email',
      decoration: const InputDecoration(labelText: 'Email'),
      autofillHints: const [AutofillHints.email],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        } else if (!_mailPattern.hasMatch(value)) {
          return 'Email is invalid';
        }
        return null;
      });

  FormBuilderTextField buildIdField() => FormBuilderTextField(
      name: 'id',
      decoration: const InputDecoration(labelText: 'ID'),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty || value.length != 7) {
          return '7-digit ID required';
        }
        return null;
      });

  FormBuilderTextField buildPasswordField() => FormBuilderTextField(
      name: 'password',
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      autofillHints: const [AutofillHints.password],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        return null;
      });
}
