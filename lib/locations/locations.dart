import 'package:flutter/material.dart';
import 'package:fomebox/locations/locationslist.dart';
import 'package:fomebox/locations/newlocation.dart';

class LocationsTab extends StatelessWidget {
  const LocationsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Locations"), actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create new location',
            onPressed: () {
              showDialog(
                  context: context, builder: (context) => const NewLocation());
            }),
      ]),
      body: const LocationsList(),
    );
  }
}
