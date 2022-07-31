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
  List<dynamic>? locations;
  bool loading = false;

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
    return BlocBuilder<ServerCubit, ServerConnectionState?>(
        builder: (context, state) {
      if (locations == null && !loading && state != null) {
        loading = true;
        context.read<ServerCubit>().allLocations().then((locations) {
          setState(() {
            this.locations = locations;
            loading = false;
          });
        });
        return const Center(
            child: CircularProgressIndicator(
          value: null,
          semanticsLabel: 'Loading progress indicator',
        ));
      }
      return ListView.builder(
        itemCount: locations!.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(locations![index]['name']),
            onTap: () {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LocationDetails(locations![index]['id'])));
              });
            },
          );
        },
      );
    });
  }
}
