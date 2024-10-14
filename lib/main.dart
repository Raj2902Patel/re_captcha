import 'package:flutter/material.dart';
import 'package:re_captcha/pages/re_captcha.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ReCaptchaPage(),
    );
  }
}
