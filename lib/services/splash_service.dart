import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_task/ui/HomeMapScreen.dart';
import 'package:flutter_demo_task/ui/LoginScreen.dart';

class SplashService{
  void isLogin(BuildContext context){
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    
    if(user != null){
      Timer(const Duration(seconds: 2), () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const HomeMapScreen())));
    }else{
      Timer(const Duration(seconds: 2), () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen())));
    }

  }
}