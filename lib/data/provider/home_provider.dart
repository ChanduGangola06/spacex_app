import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spacex_app/data/provider/cache_provider.dart';
import 'package:spacex_app/data/services/graphql_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/utils/custom_snackbar.dart';

enum DataType { rocket, company, launch }

class HomeProvider extends ChangeNotifier {
  static const int _maxNetworkRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);
  
  final AppCacheProvider _cacheProvider = AppCacheProvider();
  final Connectivity _connectivity = Connectivity();
  bool _isInitialized = false;
  bool _isOffline = false;
  DataType? _lastOperation;
  BuildContext? _lastContext;

  bool _isCompanyLoading = false;
  bool get isCompanyLoadingg => _isCompanyLoading;

  bool _isRocketLoading = false;
  bool get isRocketLoading => _isRocketLoading;

  bool _isLaunchesLoading = false;
  bool get isLaunchesLoading => _isLaunchesLoading;

  bool get isOffline => _isOffline;

  Map _getCompanyData = {};
  Map get getCompanyData => _getCompanyData;

  List _getLaunchesData = [];
  List get getLaunchesData => _getLaunchesData;

  List _getRocketData = [];
  List get getRocketData => _getRocketData;

  HomeProvider() {
    _initCache();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _isOffline = result == ConnectivityResult.none;
      notifyListeners();

      _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
        final wasOffline = _isOffline;
        _isOffline = results.contains(ConnectivityResult.none);
        notifyListeners();

        // If we were offline and now we're online, retry the last operation
        if (wasOffline && !_isOffline && _lastOperation != null && _lastContext != null) {
          retryLastOperation(_lastContext!);
        }
      });
    } catch (e) {
      log("Error checking connectivity: $e");
      _isOffline = true;
      notifyListeners();
    }
  }

  Future<void> retryLastOperation(BuildContext context) async {
    if (_lastOperation == null) return;

    try {
      switch (_lastOperation) {
        case DataType.rocket:
          await getRocket(context);
          break;
        case DataType.company:
          await getCompany(context);
          break;
        case DataType.launch:
          await getLaunches(context);
          break;
        default:
          break;
      }
    } catch (e) {
      log("Error retrying last operation: $e");
      if (context.mounted) {
        CustomSnackBar.showError(context, 'Failed to retry operation. Please try again.');
      }
    }
  }

  Future<bool> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _isOffline = result == ConnectivityResult.none;
      notifyListeners();
      return !_isOffline;
    } catch (e) {
      log("Error checking connectivity: $e");
      _isOffline = true;
      notifyListeners();
      return false;
    }
  }

  Future<void> _initCache() async {
    try {
      await _cacheProvider.init();
      await _loadCachedData();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      log("Error initializing cache: $e");
      _isInitialized = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _loadCachedData() async {
    try {
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
    } catch (e) {
      log("Error loading cached data: $e");
      // Don't rethrow here, as we want to continue even if cache loading fails
    }
  }

  Future<void> loadCacheForTest() async {
    if (!_isInitialized) {
      try {
        await _initCache();
      } catch (e) {
        log("Failed to initialize cache: $e");
        rethrow;
      }
    }
  }

  Future<QueryResult> _executeQueryWithRetry(
    GraphQLClient client,
    QueryOptions options,
    BuildContext context,
  ) async {
    if (!await _checkConnectivity()) {
      throw Exception('No internet connection available');
    }

    int retryCount = 0;
    while (retryCount < _maxNetworkRetries) {
      try {
        final result = await client.query(options);
        if (result.hasException) {
          throw result.exception!;
        }
        _isOffline = false;
        return result;
      } catch (e) {
        retryCount++;
        if (retryCount == _maxNetworkRetries) {
          _isOffline = true;
          notifyListeners();
          throw Exception('Network error after $_maxNetworkRetries attempts: $e');
        }
        log('Retry attempt $retryCount of $_maxNetworkRetries');
        await Future.delayed(_retryDelay * retryCount);
      }
    }
    throw Exception('Unexpected error in query execution');
  }

  Future<void> getRocket(context) async {
    _lastOperation = DataType.rocket;
    _lastContext = context;

    if (!_isInitialized) {
      try {
        await _initCache();
      } catch (e) {
        log("Failed to initialize cache: $e");
        CustomSnackBar.showError(context, 'Failed to initialize cache. Please try again.');
        rethrow;
      }
    }

    try {
      _isRocketLoading = true;
      notifyListeners();

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
      final result = await _executeQueryWithRetry(
        client,
        QueryOptions(
          document: gql('''
              query RocketsQuery {
                rockets {
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
        context,
      );

      if (result.data != null && result.data!['rockets'] != null) {
        _getRocketData = result.data!['rockets'];
        try {
          await _cacheProvider.cacheRockets(_getRocketData);
        } catch (e) {
          log("Failed to cache rocket data: $e");
        }
      }
    } on Exception catch (e) {
      log("Error in getRocket: $e");
      if (_isOffline) {
        CustomSnackBar.showError(context, 'You are offline. Showing cached data if available.');
      } else {
        CustomSnackBar.showError(context, 'Failed to load rocket data. Please try again.');
      }
      rethrow;
    } finally {
      _isRocketLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCompany(context) async {
    _lastOperation = DataType.company;
    _lastContext = context;

    if (!_isInitialized) {
      try {
        await _initCache();
      } catch (e) {
        log("Failed to initialize cache: $e");
        CustomSnackBar.showError(context, 'Failed to initialize cache. Please try again.');
        rethrow;
      }
    }

    try {
      _isCompanyLoading = true;
      notifyListeners();

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
      final result = await _executeQueryWithRetry(
        client,
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
        context,
      );

      if (result.data != null && result.data!['company'] != null) {
        _getCompanyData = result.data!['company'];
        try {
          await _cacheProvider.cacheCompany(Map<String, dynamic>.from(_getCompanyData));
        } catch (e) {
          log("Failed to cache company data: $e");
        }
      }
    } on Exception catch (e) {
      log("Error in getCompany: $e");
      if (_isOffline) {
        CustomSnackBar.showError(context, 'You are offline. Showing cached data if available.');
      } else {
        CustomSnackBar.showError(context, 'Failed to load company data. Please try again.');
      }
      rethrow;
    } finally {
      _isCompanyLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLaunches(context) async {
    _lastOperation = DataType.launch;
    _lastContext = context;

    if (!_isInitialized) {
      try {
        await _initCache();
      } catch (e) {
        log("Failed to initialize cache: $e");
        CustomSnackBar.showError(context, 'Failed to initialize cache. Please try again.');
        rethrow;
      }
    }

    try {
      _isLaunchesLoading = true;
      notifyListeners();

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
      final result = await _executeQueryWithRetry(
        client,
        QueryOptions(
          document: gql('''
            query LaunchesQuery {
              launches {
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
        context,
      );

      if (result.data != null && result.data!['launches'] != null) {
        _getLaunchesData = result.data!['launches'];
        try {
          await _cacheProvider.cacheLaunches(_getLaunchesData);
        } catch (e) {
          log("Failed to cache launches data: $e");
        }
      }
    } on Exception catch (e) {
      log("Error in getLaunches: $e");
      if (_isOffline) {
        CustomSnackBar.showError(context, 'You are offline. Showing cached data if available.');
      } else {
        CustomSnackBar.showError(context, 'Failed to load launches data. Please try again.');
      }
      rethrow;
    } finally {
      _isLaunchesLoading = false;
      notifyListeners();
    }
  }
}
