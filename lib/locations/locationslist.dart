import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fomebox/graphql/server.dart';

import 'locationdetails.dart';

class LocationsList extends StatefulWidget {
  const LocationsList({Key? key}) : super(key: key);

  @override
  LocationsListState createState() => LocationsListState();
}

class LocationsListState extends State<LocationsList>
    with TickerProviderStateMixin {
  late Future<List<dynamic>?> locationsFuture;

  @override
  void initState() {
    locationsFuture = context.read<ServerCubit>().allLocations();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerCubit, ServerConnectionState?>(
        builder: (context, state) {
      return FutureBuilder(
          future: locationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var locations = snapshot.data as List<dynamic>?;
              if (locations == null) {
                return const Center(child: Text("Unable to load data."));
              }
              return ListView.builder(
                itemCount: locations.length,
                itemBuilder: (BuildContext context, int index) => ListTile(
                    title: Text(locations[index]['name']),
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LocationDetails(locations[index]['id'])));
                      });
                    }),
              );
            }
            return const Center(
                child: CircularProgressIndicator(
              value: null,
              semanticsLabel: 'Loading progress indicator',
            ));
          });
    });
  }
}
