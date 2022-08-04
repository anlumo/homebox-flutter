import 'package:flutter/material.dart';

class LocationDetails extends StatefulWidget {
  final dynamic location;
  final TextEditingController nameController;

  const LocationDetails(this.location, this.nameController, {Key? key})
      : super(key: key);

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  @override
  initState() {
    super.initState();
    widget.nameController.text = widget.location['name'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Location ${widget.location['name']}"),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: widget.nameController,
          decoration: const InputDecoration(hintText: 'Location Name'),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
        TextButton(
          child: const Text('Rename'),
          onPressed: () {
            Navigator.pop(context, 'OK');
          },
        ),
      ],
    );
  }
}
