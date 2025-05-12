import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:spacex_app/data/provider/theme_provider.dart';
import 'package:spacex_app/data/provider/home_provider.dart';
import 'package:spacex_app/presentation/screens/launch_detail.dart';
import 'package:spacex_app/core/utils/responsive_helper.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchExplorer extends StatefulWidget {
  const LaunchExplorer({super.key});

  @override
  State<LaunchExplorer> createState() => _LaunchExplorerState();
}

class _LaunchExplorerState extends State<LaunchExplorer> {
  String _searchQuery = '';
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  bool _isLoadingMore = false;
  Timer? _timer;
  Set<String> _favorites = {};
  bool _showFavoritesOnly = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadLaunches();
    _startTimer();
    _loadFavorites();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoadingMore) {
        _loadMoreData();
      }
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('favorites')?.toSet() ?? {};
    });
  }

  Future<void> _toggleFavorite(String launchId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favorites.contains(launchId)) {
        _favorites.remove(launchId);
      } else {
        _favorites.add(launchId);
      }
    });
    await prefs.setStringList('favorites', _favorites.toList());
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  String _getCountdown(String launchDate) {
    try {
      final launchDateTime = DateTime.parse(launchDate);
      final now = DateTime.now();

      if (launchDateTime.isBefore(now)) {
        return 'Launched';
      }

      final difference = launchDateTime.difference(now);
      final days = difference.inDays;
      final hours = difference.inHours.remainder(24);
      final minutes = difference.inMinutes.remainder(60);
      final seconds = difference.inSeconds.remainder(60);

      return '${days}d ${hours}h ${minutes}m ${seconds}s';
    } catch (e) {
      return 'Invalid date';
    }
  }

  loadLaunches() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<HomeProvider>(context, listen: false).getLaunches(context);
    });
  }

  void _loadMoreData() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });

      // Simulate network delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _currentPage++;
            _isLoadingMore = false;
          });
        }
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoadingMore = true;
    });
    
    try {
      await Provider.of<HomeProvider>(context, listen: false).getLaunches(context);
      if (mounted) {
        setState(() {
          _currentPage = 0;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error refreshing data: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  void _resetPagination() {
    if (mounted) {
      setState(() {
        _currentPage = 0;
        _isLoadingMore = false;
      });
    }
  }

  Widget _buildLaunchCard(dynamic launch) {
    final launchDate = launch['launch_date_utc'];
    final isUpcoming = launchDate != null
        ? DateTime.parse(launchDate).isAfter(DateTime.now())
        : false;
    final rocketName = launch['rocket']?['rocket_name'] ?? 'Unknown Rocket';
    final launchYear = launch['launch_year'] ?? 'Unknown Year';
    final details = launch['details'];

    return Semantics(
      button: true,
      label: '$rocketName launch details',
      child: Card(
        margin: EdgeInsets.only(
            bottom: ResponsiveHelper.getAdaptiveSpacing(context)),
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: InkWell(
          onTap: () {
            Get.to(() => LaunchDetail(launchData: launch));
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding:
                EdgeInsets.all(ResponsiveHelper.getAdaptiveSpacing(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        rocketName,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge?.color,
                          fontSize: ResponsiveHelper.getAdaptiveFontSize(
                              context, 18.sp),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Semantics(
                      button: true,
                      label: _favorites.contains(launch['id'])
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                      child: IconButton(
                        icon: Icon(
                          _favorites.contains(launch['id'])
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _favorites.contains(launch['id'])
                              ? Colors.red
                              : Theme.of(context).hintColor,
                        ),
                        onPressed: () => _toggleFavorite(launch['id']),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height: ResponsiveHelper.getAdaptiveSpacing(context) / 2),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size:
                          ResponsiveHelper.getAdaptiveFontSize(context, 16.sp),
                      color: Theme.of(context).hintColor,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      launchYear,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: ResponsiveHelper.getAdaptiveFontSize(
                            context, 14.sp),
                      ),
                    ),
                  ],
                ),
                if (details != null) ...[
                  SizedBox(
                      height: ResponsiveHelper.getAdaptiveSpacing(context) / 2),
                  Text(
                    details.toString(),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize:
                          ResponsiveHelper.getAdaptiveFontSize(context, 14.sp),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (isUpcoming && launchDate != null) ...[
                  SizedBox(
                      height: ResponsiveHelper.getAdaptiveSpacing(context) / 2),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Launch in: ${_getCountdown(launchDate)}',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: ResponsiveHelper.getAdaptiveFontSize(
                            context, 14.sp),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridLayout(List<dynamic> launches, HomeProvider value) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              key: ValueKey<int>(_currentPage),
              controller: _scrollController,
              padding: ResponsiveHelper.getAdaptivePadding(context),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
                childAspectRatio: 1.5,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
              ),
              itemCount: launches.length +
                  (_currentPage < (launches.length / _itemsPerPage).ceil() - 1 ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == launches.length) {
                  return _buildLoadingIndicator();
                }
                return _buildLaunchCard(launches[index]);
              },
            ),
          ),
          _buildPaginationIndicator(
            _currentPage,
            (value.getLaunchesData.length / _itemsPerPage).ceil(),
          ),
        ],
      ),
    );
  }

  Widget _buildListLayout(List<dynamic> launches, HomeProvider value) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              key: ValueKey<int>(_currentPage),
              controller: _scrollController,
              padding: ResponsiveHelper.getAdaptivePadding(context),
              itemCount: launches.length +
                  (_currentPage < (launches.length / _itemsPerPage).ceil() - 1 ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == launches.length) {
                  return _buildLoadingIndicator();
                }
                return _buildLaunchCard(launches[index]);
              },
            ),
          ),
          _buildPaginationIndicator(
            _currentPage,
            (value.getLaunchesData.length / _itemsPerPage).ceil(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading launches...',
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: ResponsiveHelper.getAdaptiveFontSize(context, 16.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationIndicator(int currentPage, int totalPages) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: currentPage > 0 ? 1.0 : 0.5,
            child: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: currentPage > 0 
                    ? Theme.of(context).primaryColor 
                    : Theme.of(context).disabledColor,
              ),
              onPressed: currentPage > 0 
                  ? () {
                      setState(() {
                        _currentPage--;
                      });
                    }
                  : null,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.5),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              'Page ${currentPage + 1} of $totalPages',
              key: ValueKey<int>(currentPage),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: ResponsiveHelper.getAdaptiveFontSize(context, 14.sp),
              ),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: currentPage < totalPages - 1 ? 1.0 : 0.5,
            child: IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: currentPage < totalPages - 1 
                    ? Theme.of(context).primaryColor 
                    : Theme.of(context).disabledColor,
              ),
              onPressed: currentPage < totalPages - 1 
                  ? () {
                      setState(() {
                        _currentPage++;
                      });
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final isLandscape = ResponsiveHelper.isLandscape(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Semantics(
          header: true,
          child: Text(
            'SpaceX Launches',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
        centerTitle: true,
        actions: [
          Semantics(
            button: true,
            label: _showFavoritesOnly
                ? 'Show all launches'
                : 'Show favorite launches',
            child: IconButton(
              icon: Icon(
                _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                setState(() {
                  _showFavoritesOnly = !_showFavoritesOnly;
                  _resetPagination();
                });
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(isTablet ? 100.h : 80.h),
          child: Container(
            padding: ResponsiveHelper.getAdaptivePadding(context),
            child: Semantics(
              textField: true,
              label: 'Search launches by year',
              child: TextField(
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  hintText: 'Search by Year',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon:
                      Icon(Icons.search, color: Theme.of(context).hintColor),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                    _resetPagination();
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          if (value.isLaunchesLoading && value.getLaunchesData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Loading launches...',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: ResponsiveHelper.getAdaptiveFontSize(context, 16.sp),
                    ),
                  ),
                ],
              ),
            );
          }

          var filteredLaunches = value.getLaunchesData.where((launch) {
            final matchesSearch = launch['launch_year'].toString().toLowerCase().contains(_searchQuery);
            final matchesFavorites =
                !_showFavoritesOnly || _favorites.contains(launch['id']);
            return matchesSearch && matchesFavorites;
          }).toList();

          if (filteredLaunches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    image: true,
                    label: 'No launches found icon',
                    child: Icon(
                      _showFavoritesOnly
                          ? Icons.favorite_border
                          : Icons.rocket_launch,
                      size: 64,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  SizedBox(
                      height: ResponsiveHelper.getAdaptiveSpacing(context)),
                  Semantics(
                    label: _showFavoritesOnly
                        ? 'No favorite launches found'
                        : 'No launches found',
                    child: Text(
                      _showFavoritesOnly
                          ? 'No favorite launches found.'
                          : 'No launches found.',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: ResponsiveHelper.getAdaptiveFontSize(
                            context, 16.sp),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final int totalPages = (filteredLaunches.length / _itemsPerPage).ceil();
          final int startIndex = _currentPage * _itemsPerPage;
          
          // Ensure startIndex is within bounds
          if (startIndex >= filteredLaunches.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _resetPagination();
            });
            return const Center(child: CircularProgressIndicator());
          }
          
          final int endIndex = (startIndex + _itemsPerPage) > filteredLaunches.length
                  ? filteredLaunches.length
                  : startIndex + _itemsPerPage;

          final paginatedLaunches = filteredLaunches.sublist(startIndex, endIndex);

          return OrientationBuilder(
            builder: (context, orientation) {
              return isTablet && isLandscape
                  ? _buildGridLayout(paginatedLaunches, value)
                  : _buildListLayout(paginatedLaunches, value);
            },
          );
        },
      ),
    );
  }
}

