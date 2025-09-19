// ignore: file_names
import 'package:ecommerce_app/core/Routes/app_routes.dart';
import 'package:ecommerce_app/core/constant/link_services.dart';

import 'package:ecommerce_app/generated/l10n.dart';
import 'package:ecommerce_app/helper/api.dart';
import 'package:ecommerce_app/presentation/page/chekout/send_mail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class PaymentPage extends StatefulWidget {
  final int totil;
  final String name;
  final String email;
  final String phone;
  final String subdivisions;
  final String city;
  final String street;
  final String title;
  final String price;
  final String image;
  const PaymentPage({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.subdivisions,
    required this.city,
    required this.street,
    required this.totil,
    required this.title,
    required this.price,
    required this.image,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPayment = "كاش"; // ✅ القيمة الافتراضية

  void _confirmPayment() async {
    // ✅ تنفيذ الإجراء المناسب بناءً على طريقة الدفع المختارة
    if (_selectedPayment == "💵 Cash Payment") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => SendMail(
                image: widget.image,
                price: widget.price,
                title: widget.title,
                name: widget.name,
                subdivisions: widget.subdivisions,
                city: widget.city,
                email: widget.email,
                phone: widget.phone,
                street: widget.street,
              ),
        ),
      );
    } else if (_selectedPayment == "💳 Visa Payment") {
      bool scusecc = false;

      var response = await ApiMethod().post(
        url: LinkServices.senamil.toString(),
        data: {
          "name": widget.name,
          "phone": widget.phone,
          "email": widget.email,
          "Subdivisions": widget.subdivisions,
          "ctiy": widget.city,
          "street": widget.street,
          "propulsion": "Paid",
        },
      );
      if (response['status'] == "sucsses") {
        QuickAlert.show(
          // ignore: use_build_context_synchronously
          context: context,
          //   widget: Lottie.asset(Apploti.Sendmail),
          type: QuickAlertType.success,
          text:
              'Payment has been successfully made. Your order will arrive within two days..',
          barrierDismissible: false,
          title: 'succeed',
          onConfirmBtnTap: () {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
          },
        );
      } else {
        print('Erorrrrrrrrrrrrrrrrrrrrr');
      }
      // PaymentManager.makePayment(widget.totil, "EGP").then((value) async {

      // });
    } else if (_selectedPayment == "Pay_via_PayPal") {
      //  print("🔹 تنفيذ الدفع عبر PayPal...");
      // ضع هنا كود تنفيذ الدفع عبر PayPal
    }
  }

  Widget _buildPaymentButton(String paymentMethod) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedPayment = paymentMethod; // ✅ تحديث الاختيار فقط
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _selectedPayment == paymentMethod ? Colors.blue : Colors.grey[300],
        foregroundColor:
            _selectedPayment == paymentMethod ? Colors.white : Colors.black,
        padding: EdgeInsets.symmetric(vertical: 15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(paymentMethod, style: TextStyle(fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose a payment method")),
      body: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          SizedBox(height: 20),

          // ✅ أزرار اختيار طريقة الدفع
          _buildPaymentButton("💵 Cash Payment"),
          SizedBox(height: 10),

          _buildPaymentButton("💳 Visa Payment"),

          // ✅ زر التأكيد (ينفذ شيء واحد فقط)
          //    _buildPaymentButton("Pay_via_PayPal"),
          SizedBox(height: 50),
          InkWell(
            onTap: _confirmPayment,
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 9, 90, 231),
                    Colors.lightBlueAccent,
                  ],
                ),
              ),
              child: Text(
                S.of(context).pay_now,
                style: GoogleFonts.aBeeZee(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
