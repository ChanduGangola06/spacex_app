import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_app/data/provider/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          return Container();
        },
      ),
    );
  }
}
