import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spacex_app/screens/rocket_catalog.dart';

import 'launch_explorer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SpaceX Explorer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(() => LaunchExplorer());
              },
              child: Text('Launch Data'),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                Get.to(() => RocketCatalog());
              },
              child: Text('Rocket Data'),
            ),
          ],
        ),
      ),
    );
  }
}
