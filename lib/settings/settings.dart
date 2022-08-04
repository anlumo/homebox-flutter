import 'package:flutter/material.dart';
import 'package:fomebox/settings/login_form.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: LoginForm(
          uriController: TextEditingController(),
          passwordController: TextEditingController(),
          formKey: GlobalKey<FormState>(),
        ));
  }
}
