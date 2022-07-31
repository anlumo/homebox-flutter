import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fomebox/graphql/server.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final uriController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                          controller: uriController,
                          decoration:
                              const InputDecoration(hintText: 'Server URL'),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the server URL';
                            }
                            var uri = Uri.tryParse(value);
                            if (uri == null ||
                                !uri.hasScheme ||
                                uri.host.isEmpty) {
                              return 'Server URL not valid';
                            }

                            return null;
                          })),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration:
                              const InputDecoration(hintText: 'Password'),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the server password';
                            }
                            return null;
                          })),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Logging In')));

                              context
                                  .read<ServerCubit>()
                                  .login(Uri.parse(uriController.text),
                                      passwordController.text)
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
                ]))));
  }
}
