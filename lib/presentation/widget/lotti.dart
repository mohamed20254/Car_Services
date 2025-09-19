import 'package:ecommerce_app/core/constant/app_lotti.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Lottiee extends StatelessWidget {
  const Lottiee({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Row(children: [Lottie.asset(AppLotti.rebair, height: 200)]),

          SizedBox(child: Lottie.asset(AppLotti.animation, fit: BoxFit.cover)),
        ],
      ),
    );
  }
}
