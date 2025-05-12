import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spacex_app/core/constants/constants.dart';

class GraphqlService {
  static HttpLink link = HttpLink('$serverUrl/graphql');

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
