import 'package:flutter/material.dart';

class NewLocation extends StatelessWidget {
  const NewLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create Location"),
      content: TextFormField(
        decoration: const InputDecoration(hintText: 'Name'),
        autofocus: true,
      ),
      actions: <Widget>[
        TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, 'Cancel')),
        TextButton(
          child: const Text('Create'),
          onPressed: () {
            Navigator.pop(context, 'OK');
          },
        )
      ],
    );
  }
}
