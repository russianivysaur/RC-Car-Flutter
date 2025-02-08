import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(const RcApp());
}


class RcApp extends StatelessWidget {
  const RcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }

}

