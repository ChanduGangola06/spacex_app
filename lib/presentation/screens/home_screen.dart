import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:spacex_app/data/provider/theme_provider.dart';
import 'package:spacex_app/presentation/screens/rocket_catalog.dart';
import 'package:spacex_app/presentation/screens/launch_explorer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'SpaceX Explorer',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          Semantics(
            button: true,
            label: 'Toggle theme',
            child: IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                themeProvider.setThemeMode(
                  themeProvider.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                );
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(() => const LaunchExplorer());
              },
              child: Text('Launch Data'),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const RocketCatalog());
              },
              child: Text('Rocket Data'),
            ),
          ],
        ),
      ),
    );
  }
}
