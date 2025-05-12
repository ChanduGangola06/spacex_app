import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spacex_app/data/services/graphql_service.dart';
import 'package:spacex_app/data/provider/cache_provider.dart';

import '../../core/utils/custom_snackbar.dart';

class HomeProvider extends ChangeNotifier {
  final AppCacheProvider _cacheProvider = AppCacheProvider();

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

  HomeProvider() {
    _initCache();
  }

  Future<void> _initCache() async {
    await _cacheProvider.init();
    await _loadCachedData();
  }

  Future<void> _loadCachedData() async {
    final cachedLaunches = await _cacheProvider.getCachedLaunches();
    if (cachedLaunches != null) {
      _getLaunchesData = cachedLaunches;
      notifyListeners();
    }

    final cachedRockets = await _cacheProvider.getCachedRockets();
    if (cachedRockets != null) {
      _getRocketData = cachedRockets;
      notifyListeners();
    }

    final cachedCompany = await _cacheProvider.getCachedCompany();
    if (cachedCompany != null) {
      _getCompanyData = cachedCompany;
      notifyListeners();
    }
  }

  void getCompany(context) async {
    try {
      _isCompanyLoading = true;
      notifyListeners();

      // Check if we should use cached data
      if (!await _cacheProvider.shouldRefreshData()) {
        final cachedData = await _cacheProvider.getCachedCompany();
        if (cachedData != null) {
          _getCompanyData = cachedData;
          _isCompanyLoading = false;
          notifyListeners();
          return;
        }
      }

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
        await _cacheProvider
            .cacheCompany(Map<String, dynamic>.from(_getCompanyData));
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

      // Check if we should use cached data
      if (!await _cacheProvider.shouldRefreshData()) {
        final cachedData = await _cacheProvider.getCachedRockets();
        if (cachedData != null) {
          _getRocketData = cachedData;
          _isRocketLoading = false;
          notifyListeners();
          return;
        }
      }

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
        await _cacheProvider.cacheRockets(_getRocketData);
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

      // Check if we should use cached data
      if (!await _cacheProvider.shouldRefreshData()) {
        final cachedData = await _cacheProvider.getCachedLaunches();
        if (cachedData != null) {
          _getLaunchesData = cachedData;
          _isLaunchesLoading = false;
          notifyListeners();
          return;
        }
      }

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
                launch_site {
                  site_name
                  site_name_long
                }
                links {
                  video_link
                  wikipedia
                  flickr_images
                }
                launch_date_utc
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
        await _cacheProvider.cacheLaunches(_getLaunchesData);
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

  Future<void> loadCacheForTest() async {
    await _initCache();
  }
}
