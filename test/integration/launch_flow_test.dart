import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spacex_app/data/provider/theme_provider.dart';
import 'package:spacex_app/presentation/screens/home_screen.dart';
import 'package:spacex_app/presentation/screens/launch_explorer.dart';

void main() {
  testWidgets('Complete launch flow test', (WidgetTester tester) async {
    // Start at home screen
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

    // Verify home screen elements
    expect(find.text('SpaceX Explorer'), findsOneWidget);
    expect(find.text('Launch Data'), findsOneWidget);

    // Navigate to launch explorer
    await tester.tap(find.text('Launch Data'));
    await tester.pumpAndSettle();

    // Verify launch explorer screen
    expect(find.text('SpaceX Launches'), findsOneWidget);
    expect(find.byType(LaunchExplorer), findsOneWidget);

    // Test search functionality
    await tester.enterText(find.byType(TextField), '2023');
    await tester.pumpAndSettle();

    // Test favorites functionality
    final favoriteButton = find.byIcon(Icons.favorite_border).first;
    await tester.tap(favoriteButton);
    await tester.pumpAndSettle();

    // Toggle favorites view
    final favoritesButton = find.byIcon(Icons.favorite).first;
    await tester.tap(favoritesButton);
    await tester.pumpAndSettle();

    // Navigate back to home screen
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Verify return to home screen
    expect(find.text('SpaceX Explorer'), findsOneWidget);
  });
}
