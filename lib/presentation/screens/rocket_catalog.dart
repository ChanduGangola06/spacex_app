import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:spacex_app/data/provider/home_provider.dart';
import 'package:spacex_app/presentation/screens/rocket_detail.dart';
import 'package:spacex_app/core/utils/responsive_helper.dart';

class RocketCatalog extends StatefulWidget {
  const RocketCatalog({super.key});

  @override
  State<RocketCatalog> createState() => _RocketCatalogState();
}

class _RocketCatalogState extends State<RocketCatalog> {
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadRockets();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreRockets();
    }
  }

  void _loadRockets() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).getRocket(context);
    });
  }

  void _loadMoreRockets() {
    Provider.of<HomeProvider>(context, listen: false).getRocket(context);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final isLandscape = ResponsiveHelper.isLandscape(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Semantics(
          header: true,
          child: const Text(
            'Rocket Catalog',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(isTablet ? 100.h : 80.h),
          child: Container(
            padding: ResponsiveHelper.getAdaptivePadding(context),
            child: Semantics(
              textField: true,
              label: 'Search rockets by name',
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search by Name',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          var filteredRockets = value.getRocketData.where((rocket) {
            return rocket['name']
                .toString()
                .toLowerCase()
                .contains(_searchQuery);
          }).toList();

          if (filteredRockets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    image: true,
                    label: 'No rockets found icon',
                    child: Icon(
                      Icons.rocket_launch,
                      size: 64.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(
                      height: ResponsiveHelper.getAdaptiveSpacing(context)),
                  Semantics(
                    label: 'No rockets found',
                    child: Text(
                      'No rockets found.',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: ResponsiveHelper.getAdaptiveFontSize(
                            context, 16.sp),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return value.isRocketLoading && filteredRockets.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : OrientationBuilder(
                  builder: (context, orientation) {
                    return isTablet && isLandscape
                        ? _buildGridLayout(filteredRockets)
                        : _buildListLayout(filteredRockets);
                  },
                );
        },
      ),
    );
  }

  Widget _buildGridLayout(List<dynamic> rockets) {
    return GridView.builder(
      controller: _scrollController,
      padding: ResponsiveHelper.getAdaptivePadding(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
        childAspectRatio: 1.5,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: rockets.length + 1,
      itemBuilder: (context, index) {
        if (index == rockets.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return _buildRocketCard(rockets[index]);
      },
    );
  }

  Widget _buildListLayout(List<dynamic> rockets) {
    return ListView.builder(
      controller: _scrollController,
      padding: ResponsiveHelper.getAdaptivePadding(context),
      itemCount: rockets.length + 1,
      itemBuilder: (context, index) {
        if (index == rockets.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return _buildRocketCard(rockets[index]);
      },
    );
  }

  Widget _buildRocketCard(dynamic rocket) {
    return Semantics(
      button: true,
      label: '${rocket['name']} rocket details',
      child: Card(
        margin: EdgeInsets.only(
            bottom: ResponsiveHelper.getAdaptiveSpacing(context)),
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: InkWell(
          onTap: () {
            Get.to(() => RocketDetail(rocketData: rocket));
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
                        rocket['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.getAdaptiveFontSize(
                              context, 18.sp),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: rocket['active']
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        rocket['active'] ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: rocket['active'] ? Colors.green : Colors.red,
                          fontSize: ResponsiveHelper.getAdaptiveFontSize(
                              context, 14.sp),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height: ResponsiveHelper.getAdaptiveSpacing(context) / 2),
                Row(
                  children: [
                    Icon(
                      Icons.rocket,
                      size:
                          ResponsiveHelper.getAdaptiveFontSize(context, 16.sp),
                      color: Colors.grey[400],
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      rocket['type'],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: ResponsiveHelper.getAdaptiveFontSize(
                            context, 14.sp),
                      ),
                    ),
                  ],
                ),
                if (rocket['description'] != null) ...[
                  SizedBox(
                      height: ResponsiveHelper.getAdaptiveSpacing(context) / 2),
                  Text(
                    rocket['description'],
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize:
                          ResponsiveHelper.getAdaptiveFontSize(context, 14.sp),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
