import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:spacex_app/data/provider/home_provider.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  var expanded = false;
  final double _bigFontSize = kIsWeb ? 234 : 160;
  final transitionDuration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<HomeProvider>(context, listen: false).getCompany(context);
      Provider.of<HomeProvider>(context, listen: false).getRocket(context);
      
      Get.offAll(() => HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              duration: transitionDuration,
              curve: Curves.fastOutSlowIn,
              style: TextStyle(
                color: Theme.of(context).splashColor,
                fontSize: !expanded ? _bigFontSize : 50,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
              ),
              child: Text(
                'Space ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            AnimatedCrossFade(
              firstCurve: Curves.fastOutSlowIn,
              crossFadeState:
                  !expanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
              duration: transitionDuration,
              firstChild: Container(),
              secondChild: _logoRemainder(),
              alignment: Alignment.centerLeft,
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoRemainder() {
    return Text(
      'X',
      style: TextStyle(
        color: Theme.of(context).splashColor,
        fontSize: 50,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
