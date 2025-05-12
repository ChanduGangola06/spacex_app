import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_app/data/provider/home_provider.dart';
import 'package:spacex_app/presentation/widgets/rocket_card.dart';
import 'package:spacex_app/presentation/widgets/network_status_indicator.dart';

class RocketCatalog extends StatefulWidget {
  const RocketCatalog({Key? key}) : super(key: key);

  @override
  State<RocketCatalog> createState() => _RocketCatalogState();
}

class _RocketCatalogState extends State<RocketCatalog> {
  late final HomeProvider _homeProvider;
  bool _isInitialized = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _homeProvider = HomeProvider();
    _initializeData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  Future<void> _initializeData() async {
    try {
      await _homeProvider.loadCacheForTest();
      if (!mounted) return;
      
      setState(() {
        _isInitialized = true;
      });
      
      // Load initial data
      await _homeProvider.getRocket(context);
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing data: $e')),
      );
    }
  }

  Future<void> _loadMoreData() async {
    if (!_homeProvider.isRocketLoading) {
      try {
        await _homeProvider.getRocket(context);
      } catch (e) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading more data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _homeProvider,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rocket Catalog'),
        ),
        body: Column(
          children: [
            const NetworkStatusIndicator(),
            Expanded(
              child: !_isInitialized
                  ? const Center(child: CircularProgressIndicator())
                  : Consumer<HomeProvider>(
                      builder: (context, provider, child) {
                        if (provider.isRocketLoading && provider.getRocketData.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final rockets = provider.getRocketData;
                        if (rockets.isEmpty) {
                          return const Center(child: Text('No rockets found'));
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            try {
                              await provider.getRocket(context);
                            } catch (e) {
                              if (!mounted) return;
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error refreshing data: $e')),
                              );
                            }
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: rockets.length + (provider.isRocketLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == rockets.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              final rocket = rockets[index];
                              return RocketCard(rocket: rocket);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 