import 'package:flutter/material.dart';
import 'package:flutter_demo_task/services/splash_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashService splashService = SplashService();

  @override
  void initState() {
    super.initState();
    splashService.isLogin(context);
  }

  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Text Demo App",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),),
      ),
    );
  }
}

