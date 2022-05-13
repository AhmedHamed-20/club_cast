import 'dart:async';

import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/screens/splash_onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

import '../../../data_layer/cash/cash.dart';
import '../../components/constant/constant.dart';
import '../../layout/layout_screen.dart';
import '../user_screen/login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 500000000), () async {
      Widget startApp;

      if (await CachHelper.getData(key: 'token') != null) {
        startApp = LayoutScreen();
      } else {
        token = '';
        startApp = CachHelper.getData(key: 'isPassed') == true
            ? LoginScreen()
            : const OnBoarding();
      }
      navigatePushANDRemoveRout(context: context, navigateTo: startApp);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Container(
          decoration: BoxDecoration(),
        ),
      ),
    );
  }
}
