import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spacex_app/data/services/graphql_service.dart';

import '../../core/utils/custom_snackbar.dart';

class HomeProvider extends ChangeNotifier {
  bool _isCompanyLoading = false;
  bool get isCompanyLoadingg => _isCompanyLoading;

  bool _isRocketLoading = false;
  bool get isRocketLoading => _isRocketLoading;

  bool _isLaunchesLoading = false;
  bool get isLaunchesLoading => _isLaunchesLoading;

  Map _getCompanyData = {};
  Map get getCompanyData => _getCompanyData;

  List _getLaunchesData = [];
  List get getLaunchesData => _getLaunchesData;

  List _getRocketData = [];
  List get getRocketData => _getRocketData;

  void getCompany(context) async {
    try {
      _isCompanyLoading = true;
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
        _isCompanyLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log("Error in Reg catch : $e");
      CustomSnackBar.showError(context, 'Something went wrong');
      _isCompanyLoading = false;
      notifyListeners();
    }
  }

  void getRocket(context) async {
    try {
      _isRocketLoading = true;
      notifyListeners();
      GraphQLClient client = GraphqlService.myGQLClient();
      QueryResult result = await client.query(
        QueryOptions(
          document: gql('''
              query RocketsQuery {
                rockets(limit: 50, offset: 1) {
                  id
                  name
                  description
                  country
                  company
                  boosters
                  active
                  cost_per_launch
                  diameter {
                    meters
                  }
                  engines {
                    engine_loss_max
                    layout
                    number
                    type
                    version
                  }
                  first_flight
                  first_stage {
                    burn_time_sec
                    engines
                    fuel_amount_tons
                    reusable
                  }
                  payload_weights {
                    id
                    name
                    kg
                  }
                  second_stage {
                    burn_time_sec
                    engines
                    fuel_amount_tons
                  }
                  stages
                  success_rate_pct
                  type
                  wikipedia
                }
              }
          '''),
        ),
      );
      if (result.data!.isNotEmpty) {
        _getRocketData = result.data!['rockets'];
        _isRocketLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log("Error in Reg catch : $e");
      CustomSnackBar.showError(context, 'Something went wrong');
      _isRocketLoading = false;
      notifyListeners();
    }
  }

  void getLaunches(context) async {
    var offset = 1;
    try {
      _isLaunchesLoading = true;
      notifyListeners();
      GraphQLClient client = GraphqlService.myGQLClient();
      QueryResult result = await client.query(
        QueryOptions(
          document: gql('''
            query LaunchesQuery {
              launches(offset: $offset) {
                id
                details
                launch_year
                launch_success
                links {
                  video_link
                }
                launch_date_local
                rocket {
                  rocket {
                    id
                    name
                    type
                    active
                  }
                  rocket_name
                  rocket_type
                }
                upcoming
              }
            }
        '''),
        ),
      );

      if (result.data!.isNotEmpty) {
        _getLaunchesData = result.data!['launches'];
        _isLaunchesLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log("Error in Reg catch : $e");
      CustomSnackBar.showError(context, 'Something went wrong');
      _isLaunchesLoading = false;
      notifyListeners();
    }
  }
}
