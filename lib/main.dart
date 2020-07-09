import 'package:bookstore/module/splash/splash.dart';
import 'package:bookstore/shared/app_color.dart';
import 'package:flutter/material.dart';

import 'module/checkout/checkout/checkout_page.dart';
import 'module/home/home_page.dart';
import 'module/signin/signin_page.dart';
import 'module/signup/signup_page.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Store',
      theme: ThemeData(
        primarySwatch: AppColor.yellow,
      ),
      //home: SignInPage(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) =>SplashPage(),
        '/home': (context) => HomePage(),
        '/sign-in': (context) =>SignInPage(),
        '/sign-up': (context) =>SignUpPage(),
        '/checkout': (context) => CheckoutPage(),
      },
    );
  }
}