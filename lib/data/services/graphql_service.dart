import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spacex_app/core/constants/constants.dart';

class GraphqlService {
  static HttpLink link = HttpLink(
    '$serverUrl/graphql',
    defaultHeaders: {'Authorization': "c168e5be-2176-4eb4-8872-c1880bb5fc75"},
  );

  static GraphQLClient myGQLClient() {
    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  static ValueNotifier<GraphQLClient> clientToQuery() {
    return ValueNotifier(
      GraphQLClient(link: link, cache: GraphQLCache(store: InMemoryStore())),
    );
  }
}
