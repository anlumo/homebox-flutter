import 'package:flutter/material.dart';

import 'locationdetails.dart';

class LocationsList extends StatefulWidget {
  const LocationsList({Key? key}) : super(key: key);

  @override
  LocationsListState createState() => LocationsListState();
}

class LocationsListState extends State<LocationsList>
    with TickerProviderStateMixin {
  bool loaded = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text('Item ${index + 1}'),
                onTap: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LocationDetails('item$index')));
                  });
                },
              );
            },
          )
        : const Center(
            child: CircularProgressIndicator(
            value: null,
            semanticsLabel: 'Loading progress indicator',
          ));
  }
}
