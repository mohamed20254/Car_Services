// import 'package:flutter/material.dart';
// import 'package:flutter_braintree/flutter_braintree.dart';

// class PaypalManger {
//   void makePayment() async {
//     // إعداد طلب الدفع باستخدام PayPal
//     BraintreeDropInRequest request = BraintreeDropInRequest(
//       tokenizationKey: 'YOUR_BRAINTREE_TOKENIZATION_KEY',
//       paypalRequest: BraintreePayPalRequest(
//         amount: '10.00',
//         currencyCode: 'USD',
//         displayName: 'Your Company Name',
//       ),
//     );

//     // استدعاء نافذة الدفع
//     BraintreeDropInResult? result = await BraintreeDropIn.start(request);

//     if (result != null) {
//       // قم بمعالجة النتيجة هنا
//       print('Payment successful: ${result.paymentMethodNonce}');
//     } else {
//       print('Payment canceled or failed');
//     }
//   }
// }
