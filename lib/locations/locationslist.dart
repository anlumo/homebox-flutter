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
  Future<List<dynamic>?>? locationsFuture;

  @override
  Widget build(BuildContext context) {
    locationsFuture ??= context.read<ServerCubit>().allLocations();

    return BlocBuilder<ServerCubit, ServerConnectionState?>(
        builder: (context, state) {
      return FutureBuilder(
          future: locationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var locations = snapshot.data as List<dynamic>?;
              if (locations == null || snapshot.hasError) {
                return Center(
                    child: Text(
                        "Unable to load data: ${(snapshot.error as Errors).describe()}"));
              }
              return ListView.builder(
                  itemCount: locations.length,
                  itemBuilder: (BuildContext context, int index) {
                    final nameController = TextEditingController();
                    return Dismissible(
                        key: Key(locations[index]['id']),
                        onDismissed: (direction) {
                          context.read<ServerCubit>().renameLocation(
                                locations[index]['id'],
                                nameController.text,
                              );
                        },
                        background: Container(color: Colors.red),
                        child: ListTile(
                            title: Text(locations[index]['name']),
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LocationDetails(
                                            locations[index], nameController)));
                              });
                            }));
                  });
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
