import 'package:flutter/material.dart';

class Notivigation extends StatelessWidget {
  final String messige;
  const Notivigation({super.key, required this.messige});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(messige)));
  }
}
