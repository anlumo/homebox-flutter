import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                          decoration:
                              const InputDecoration(hintText: 'Server URL'),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the server URL';
                            }
                            return null;
                          })),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
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
                            // TODO
                          },
                          child: const Text('Login'))),
                ]))));
  }
}
