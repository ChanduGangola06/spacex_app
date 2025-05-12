import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:spacex_app/data/provider/home_provider.dart';
import 'package:spacex_app/screens/launch_detail.dart';

class LaunchExplorer extends StatefulWidget {
  const LaunchExplorer({super.key});

  @override
  State<LaunchExplorer> createState() => _LaunchExplorerState();
}

class _LaunchExplorerState extends State<LaunchExplorer> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadLaunches();
  }

  loadLaunches() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<HomeProvider>(context, listen: false).getLaunches(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Launch Launches'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.h),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by Year',
                border: OutlineInputBorder(),
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
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          // Filter launches based on the search query
          var filteredLaunches =
              value.getLaunchesData.where((launch) {
                print("Processing launch: $launch");
                return launch['launch_year'].contains(_searchQuery);
              }).toList();
          print("Filtered launches: $filteredLaunches");

          if (filteredLaunches.isEmpty) {
            return Center(child: Text('No launches found.'));
          }

          return value.isLaunchesLoading
              ? Center()
              : RefreshIndicator(
                onRefresh: () async {},
                child: ListView.builder(
                  itemCount: value.getLaunchesData.length,
                  itemBuilder: (context, index) {
                    var launches = filteredLaunches[index];
                    return ListTile(
                      onTap: () {
                        Get.to(() => LaunchDetail(launchData: launches));
                      },
                      title: Text(launches['rocket']['rocket_name']),
                      leading: Text(launches['launch_year']),
                      subtitle:
                          launches['details'] != null
                              ? Text(launches['details'].toString())
                              : Text(""),
                    );
                  },
                ),
              );
        },
      ),
    );
  }
}
