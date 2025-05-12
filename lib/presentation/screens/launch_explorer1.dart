import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_app/data/provider/home_provider.dart';
import 'package:spacex_app/presentation/widgets/launch_card.dart';

class LaunchExplorer extends StatefulWidget {
  const LaunchExplorer({Key? key}) : super(key: key);

  @override
  State<LaunchExplorer> createState() => _LaunchExplorerState();
}

class _LaunchExplorerState extends State<LaunchExplorer> {
  final HomeProvider _homeProvider = HomeProvider();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _homeProvider.loadCacheForTest();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceX Launches'),
      ),
      body: !_isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Consumer<HomeProvider>(
              builder: (context, provider, child) {
                if (provider.isLaunchesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final launches = provider.getLaunchesData;
                if (launches.isEmpty) {
                  return const Center(child: Text('No launches found'));
                }

                return ListView.builder(
                  itemCount: launches.length,
                  itemBuilder: (context, index) {
                    final launch = launches[index];
                    return LaunchCard(launch: launch);
                  },
                );
              },
            ),
    );
  }
} 