import 'package:flutter/material.dart';

class LaunchDetail extends StatefulWidget {
  var launchData;
  LaunchDetail({super.key, required this.launchData});

  @override
  State<LaunchDetail> createState() => _LaunchDetailState();
}

class _LaunchDetailState extends State<LaunchDetail> {
  @override
  Widget build(BuildContext context) {
    print("The launch Data are: ${widget.launchData['rocket']['rocket_name']}");
    return Scaffold(
      appBar: AppBar(title: Text('Launch Details'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(widget.launchData['rocket']['rocket_name']),
            Text(
              widget.launchData['details'] != null
                  ? widget.launchData['details']
                  : "",
            ),
          ],
        ),
      ),
    );
  }
}
