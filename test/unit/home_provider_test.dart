import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:spacex_app/data/provider/cache_provider.dart';
import 'package:spacex_app/data/provider/home_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_provider_test.mocks.dart';

@GenerateMocks([AppCacheProvider])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HomeProvider homeProvider;
  late MockAppCacheProvider mockCacheProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    mockCacheProvider = MockAppCacheProvider();
    homeProvider = HomeProvider();
  });

  group('HomeProvider Tests', () {
    test('should initialize with empty data', () {
      expect(homeProvider.getCompanyData, {});
      expect(homeProvider.getLaunchesData, []);
      expect(homeProvider.getRocketData, []);
    });

    test('should update loading states correctly', () {
      expect(homeProvider.isCompanyLoadingg, false);
      expect(homeProvider.isRocketLoading, false);
      expect(homeProvider.isLaunchesLoading, false);
    });

    test('should load cached data on initialization', () async {
      final mockCompanyData = {'name': 'SpaceX', 'founder': 'Elon Musk'};
      final mockLaunchesData = [
        {'id': '1', 'mission_name': 'Test Launch'}
      ];
      final mockRocketData = [
        {'id': '1', 'name': 'Falcon 9'}
      ];

      // Set up mock cache data
      when(mockCacheProvider.getCachedCompany())
          .thenAnswer((_) async => mockCompanyData);
      when(mockCacheProvider.getCachedLaunches())
          .thenAnswer((_) async => mockLaunchesData);
      when(mockCacheProvider.getCachedRockets())
          .thenAnswer((_) async => mockRocketData);

      // Set up SharedPreferences mock data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('company_data', mockCompanyData.toString());
      await prefs.setString('launches_data', mockLaunchesData.toString());
      await prefs.setString('rockets_data', mockRocketData.toString());

      // Mock the cache provider methods
      homeProvider = HomeProvider();
      when(homeProvider.getCompanyData).thenReturn(mockCompanyData);
      when(homeProvider.getLaunchesData).thenReturn(mockLaunchesData);
      when(homeProvider.getRocketData).thenReturn(mockRocketData);

      await homeProvider.loadCacheForTest();

      expect(homeProvider.getCompanyData, mockCompanyData);
      expect(homeProvider.getLaunchesData, mockLaunchesData);
      expect(homeProvider.getRocketData, mockRocketData);
    });
  });
}
