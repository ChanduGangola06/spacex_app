import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spacex_app/data/provider/theme_provider.dart';
import 'package:spacex_app/data/provider/home_provider.dart';
import 'package:spacex_app/presentation/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'theme_mode': 'light',
    });
  });

  testWidgets('HomeScreen displays all required elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
              ChangeNotifierProvider(create: (_) => HomeProvider()),
            ],
            child: MaterialApp(
              home: const HomeScreen(),
            ),
          );
        },
      ),
    );

    await tester.pump();

    // Verify app bar title
    expect(find.text('SpaceX Explorer'), findsOneWidget);

    // Verify theme toggle button
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);

    // Verify navigation buttons
    expect(find.text('Launch Data'), findsOneWidget);
    expect(find.text('Rocket Data'), findsOneWidget);
  });

  testWidgets('Theme toggle button changes theme', (WidgetTester tester) async {
    Get.testMode = true;
    
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
              ChangeNotifierProvider(create: (_) => HomeProvider()),
            ],
            child: GetMaterialApp(
              home: const HomeScreen(),
            ),
          );
        },
      ),
    );

    await tester.pump();

    // Find and tap the theme toggle button
    final themeButton = find.byIcon(Icons.dark_mode);
    expect(themeButton, findsOneWidget);
    await tester.tap(themeButton);
    await tester.pump();

    // Verify theme changed
    expect(find.byIcon(Icons.light_mode), findsOneWidget);
  });

  testWidgets('Navigation buttons work correctly', (WidgetTester tester) async {
    Get.testMode = true;
    
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
              ChangeNotifierProvider(create: (_) => HomeProvider()),
            ],
            child: GetMaterialApp(
              home: const HomeScreen(),
            ),
          );
        },
      ),
    );

    await tester.pump();

    // Find and tap the launches button
    final launchesButton = find.text('Launch Data');
    expect(launchesButton, findsOneWidget);
    await tester.tap(launchesButton);
    await tester.pump();

    // Verify navigation
    expect(find.byType(HomeScreen), findsNothing);
  });
}
