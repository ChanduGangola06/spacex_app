import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spacex_app/data/provider/theme_provider.dart';
import 'package:spacex_app/presentation/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays all required elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            home: ChangeNotifierProvider(
              create: (_) => ThemeProvider(),
              child: const HomeScreen(),
            ),
          );
        },
      ),
    );

    // Verify app bar title
    expect(find.text('SpaceX Explorer'), findsOneWidget);

    // Verify theme toggle button
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);

    // Verify navigation buttons
    expect(find.text('Launch Data'), findsOneWidget);
    expect(find.text('Rocket Data'), findsOneWidget);
  });

  testWidgets('Theme toggle button changes theme', (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            home: ChangeNotifierProvider(
              create: (_) => ThemeProvider(),
              child: const HomeScreen(),
            ),
          );
        },
      ),
    );

    // Initial theme should be light
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);

    // Tap theme toggle button
    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pumpAndSettle();

    // Theme should change to dark
    expect(find.byIcon(Icons.light_mode), findsOneWidget);
  });

  testWidgets('Navigation buttons work correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            home: ChangeNotifierProvider(
              create: (_) => ThemeProvider(),
              child: const HomeScreen(),
            ),
          );
        },
      ),
    );

    // Tap Launch Data button
    await tester.tap(find.text('Launch Data'));
    await tester.pumpAndSettle();

    // Verify navigation
    expect(find.byType(HomeScreen), findsNothing);
  });
}
