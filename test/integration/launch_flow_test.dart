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

  testWidgets('Complete launch flow test', (WidgetTester tester) async {
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

    // Verify initial screen
    expect(find.text('SpaceX Explorer'), findsOneWidget);

    // Navigate to launches
    await tester.tap(find.text('Launch Data'));
    await tester.pump();

    // Verify launches screen
    expect(find.byType(HomeScreen), findsNothing);
  });
}
