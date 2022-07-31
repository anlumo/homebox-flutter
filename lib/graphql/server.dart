import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

enum Errors {
  notLoggedIn,
  queryException,
}

class ServerConnectionState {
  Uri uri;
  Link link;
  GraphQLClient client;

  ServerConnectionState(
      {required this.uri, required this.link, required this.client});
}

// state is logged in/logged out flag
class ServerCubit extends Cubit<ServerConnectionState?> {
  final Dio _dio;
  final PersistCookieJar _cookieJar;

  ServerCubit()
      : _dio = Dio(),
        _cookieJar = PersistCookieJar(),
        super(null) {
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<void> login(Uri uri, String password) async {
    log('login at ${uri.resolve('/login').toString()}');
    var response = await _dio.postUri(
      uri.resolve('/login'),
      data: {'password': password},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (response.statusCode != 200) {
      log("Login failed!");
      emit(null);
    } else {
      log("Logged in");
      var link =
          Link.from([DioLink(uri.resolve('/api/v1').toString(), client: _dio)]);
      var client = GraphQLClient(link: link, cache: GraphQLCache());
      emit(ServerConnectionState(uri: uri, link: link, client: client));
    }
  }

  Future<void> logout() async {
    if (state != null) {
      await _dio.postUri(state!.uri.resolve('/logout'));
      emit(null);
    }
  }

  static const String _allLocationsQuery = r'''
  query allLocations() {
    allLocations {
      id, name,
    }
  }
''';

  Future<List<dynamic>> allLocations() async {
    if (state == null) {
      throw Errors.notLoggedIn;
    }
    final QueryResult result = await state!.client
        .query(QueryOptions(document: gql(_allLocationsQuery)));
    if (result.hasException) {
      log(result.exception.toString());
      throw Errors.queryException;
    }
    log("Query result: ${result.data.toString()}");
    return result.data!['allLocations'];
  }
}
