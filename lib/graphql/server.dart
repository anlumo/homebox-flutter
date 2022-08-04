import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fomebox/main.dart';
import 'package:fomebox/settings/login_form.dart';
import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:fomebox/main.dart';

enum Errors {
  notLoggedIn,
  queryException,
}

extension ErrorNames on Errors {
  String describe() {
    switch (this) {
      case Errors.notLoggedIn:
        {
          return "Not logged in.";
        }
      case Errors.queryException:
        {
          return "Invalid query.";
        }
    }
  }
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

  Future<void> checkLogin() async {
    if (state != null) {
      return;
    }
    var context = navigatorKey.currentContext;
    if (context != null) {
      var completer = Completer();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        var uriController = TextEditingController();
        var passwordController = TextEditingController();
        var formKey = GlobalKey<FormState>();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Login"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    LoginForm(
                      showLoginButton: false,
                      uriController: uriController,
                      passwordController: passwordController,
                      formKey: formKey,
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Login'),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logging In')));

                        login(Uri.parse(uriController.text),
                                passwordController.text)
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Login successful!')));
                          completer.complete();
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Login failed: ${error.toString()}')));
                          checkLogin().then((_) => completer.complete());
                        });

                        Navigator.pop(context, 'OK');
                      }
                    },
                  )
                ],
              );
            });
      });
      await completer.future;
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
    await checkLogin();
    if (state == null) {
      return Future.error(Errors.notLoggedIn);
    }
    final QueryResult result = await state!.client
        .query(QueryOptions(document: gql(_allLocationsQuery)));
    if (result.hasException) {
      log(result.exception.toString());
      return Future.error(Errors.queryException);
    }
    log("Query result: ${result.data.toString()}");
    return result.data!['allLocations'];
  }
}
