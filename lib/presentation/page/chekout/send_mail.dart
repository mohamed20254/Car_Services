import 'package:ecommerce_app/core/Routes/app_routes.dart';
import 'package:ecommerce_app/core/constant/link_services.dart';

import 'package:ecommerce_app/helper/api.dart';
import 'package:ecommerce_app/logic/cubit/my_requset_cubit.dart';
import 'package:ecommerce_app/model/my_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class SendMail extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String subdivisions;
  final String city;
  final String street;
  final String title;
  final String price;
  final String image;
  const SendMail({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.subdivisions,
    required this.city,
    required this.street,
    required this.title,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Icon(Icons.mail, color: Colors.blue, size: 30),
            SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Your request will be sent, and you will receive a response within 24 hours. We wish you a happy day.",
                style: GoogleFonts.aBeeZee(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 60,
                    width: 120,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: <Color>[
                          const Color.fromARGB(255, 243, 33, 33),
                          const Color.fromARGB(255, 1, 12, 31),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          "back",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () async {
                    var response = await ApiMethod().post(
                      url: LinkServices.senamil.toString(),
                      data: {
                        "name": name,
                        "phone": phone,
                        "email": email,
                        "Subdivisions": subdivisions,
                        "ctiy": city,
                        "street": street,
                        "propulsion": "UnPaid",
                      },
                    );
                    if (response['status'] == "sucsses") {
                      QuickAlert.show(
                        // ignore: use_build_context_synchronously
                        context: context,
                        //   widget: Lottie.asset(Apploti.Sendmail),
                        type: QuickAlertType.success,
                        text: 'You will be answered within 24 hours thank you.',
                        barrierDismissible: false,
                        title: 'succeed',
                        onConfirmBtnTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.home,
                            (route) => false,
                          );
                        },
                      );
                      MyRequest items = MyRequest(
                        title,
                        "Payment has not been made.",
                        "The product has been ordered and someone will contact you to confirm your order.",
                        price,
                        "لم يتم الدفع",
                        "تم طلب المنتج وسوف يتواصل معك احد لتاكيد طلبك",
                      );

                      context.read<MyRequsetCubit>().add(items, context);
                    } else {
                      // ignore: avoid_print
                      print('Erorrrrrrrrrrrrrrrrrrrrr');
                    }
                  },
                  child: Container(
                    height: 60,
                    width: 120,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: <Color>[Colors.blue, Colors.blueAccent],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "send",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.send, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
