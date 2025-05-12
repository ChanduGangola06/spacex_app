import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spacex_app/data/services/graphql_service.dart';

class HomeProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map _getCompanyData = {};
  Map get getCompanyData => _getCompanyData;

  void getCompany() async {
    try {
      _isLoading = true;
      notifyListeners();
      GraphQLClient client = GraphqlService.myGQLClient();
      QueryResult result = await client.query(
        QueryOptions(
          document: gql('''
            query companyQuery {
                company {
                  name
                  summary
                  vehicles
                  valuation
                  headquarters {
                    city
                    state
                    address
                  }
                  employees
                  launch_sites
                  test_sites
                  founder
                  founded
                  cto_propulsion
                  cto
                  coo
                  ceo
                  links {
                    elon_twitter
                    flickr
                    twitter
                    website
                  }
                }
              }
        '''),
        ),
      );

      if (result.data!.isNotEmpty) {
        _getCompanyData = result.data!['company'];
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("Error in Reg catch : ${e}");
      _isLoading = false;
      notifyListeners();
    }
  }

  void getRocket() async {}

  void getLaunches() async {}
}
