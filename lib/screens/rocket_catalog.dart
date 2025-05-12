import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:spacex_app/screens/rocket_detail.dart';

import '../data/provider/home_provider.dart';

class RocketCatalog extends StatefulWidget {
  const RocketCatalog({super.key});

  @override
  State<RocketCatalog> createState() => _RocketCatalogState();
}

class _RocketCatalogState extends State<RocketCatalog> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rocket List'), centerTitle: true),
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.getRocketData.length,
            itemBuilder: (context, index) {
              var rockets = value.getRocketData[index];
              return Container(
                margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black45),
                ),
                child: ListTile(
                  onTap: () {
                    Get.to(() => RocketDetail(rocketData: rockets));
                  },
                  title: Text(rockets['name']),
                  subtitle: Text(rockets['description'], maxLines: 2),
                  trailing: Text(rockets['country']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
