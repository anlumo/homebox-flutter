import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fomebox/graphql/server.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool showLoginButton;
  final TextEditingController uriController;
  final TextEditingController passwordController;
  const LoginForm(
      {Key? key,
      this.showLoginButton = true,
      required this.uriController,
      required this.passwordController,
      required this.formKey})
      : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                      controller: widget.uriController,
                      decoration: const InputDecoration(hintText: 'Server URL'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the server URL';
                        }
                        var uri = Uri.tryParse(value);
                        if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
                          return 'Server URL not valid';
                        }

                        return null;
                      })),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                      controller: widget.passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: 'Password'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the server password';
                        }
                        return null;
                      })),
              if (widget.showLoginButton)
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (widget.formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Logging In')));

                            context
                                .read<ServerCubit>()
                                .login(Uri.parse(widget.uriController.text),
                                    widget.passwordController.text)
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Login successful!')));
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Login failed: ${error.toString()}')));
                            });
                          }
                        },
                        child: const Text('Login'))),
            ])));
  }
}
