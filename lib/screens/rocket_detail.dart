import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RocketDetail extends StatefulWidget {
  var rocketData;
  RocketDetail({super.key, required this.rocketData});

  @override
  State<RocketDetail> createState() => _RocketDetailState();
}

class _RocketDetailState extends State<RocketDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rocket Details'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(widget.rocketData['name']),
              SizedBox(height: 10.h),
              Text(widget.rocketData['description']),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Expanded(
                      child: Text(
                        "Rocket Company: ${widget.rocketData['company']}",
                      ),
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: Text(
                        "Rocket Country: ${widget.rocketData['country']}",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
