import 'package:flutter/material.dart';

class LocationDetails extends StatelessWidget {
  final String id;
  const LocationDetails(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Location $id")),
      body: Text("Location Location $id"),
    );
  }
}
