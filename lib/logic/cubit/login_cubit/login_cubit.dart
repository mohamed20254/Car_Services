import 'package:ecommerce_app/logic/cubit/langcubit.dart';
import 'package:ecommerce_app/presentation/page/auth/vrefi_phone.dart';
import 'package:ecommerce_app/presentation/page/splach_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  bool isselcted = false;
  LoginCubit() : super(LoginInitial());

  void changeobsucur() {
    isselcted = !isselcted;
    emit(ObscurText(isselected: isselcted));
  }

  siginMethoud(
    String signinEmail,
    String signinPassword,
    context,
    isenglish,
  ) async {
    emit(LoginLodingState());

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signinEmail,
        password: signinPassword,
      );
      // if (FirebaseAuth.instance.currentUser!.emailVerified) {
      //   Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => SplashScreen()),
      //     (route) => false,
      //   );
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.phoneNumber != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) => false,
        );
      } else {
        QuickAlert.show(
          showCancelBtn: true,
          cancelBtnText: isenglish ? 'cancel' : "إلغاء",

          cancelBtnTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          context: context,
          widget: const Icon(Icons.send, size: 26, color: Colors.black),
          type: QuickAlertType.warning,
          text:
              isenglish
                  ? 'Please verify your phone number to continue.'
                  : "يرجى التحقق من رقم هاتفك للمتابعة",
          barrierDismissible: false,
          title: isenglish ? 'Phone Not Verified' : "'الهاتف غير مفعل",
          onConfirmBtnTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => VrefiPhone()),
            );
          },
          onCancelBtnTap: () {
            Navigator.pop(context);
          },
        );
      }

      emit(LoginSucsessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        emit(LoginErrorState(messige: "invalid-email"));
      } else if (e.code == 'user-not-found') {
        emit(LoginErrorState(messige: "user-not-found"));
      } else if (e.code == 'wrong-password') {
        emit(LoginErrorState(messige: "wrong-password"));
      } else {
        emit(LoginErrorState(messige: "$e"));
      }
    } catch (e) {
      emit(LoginErrorState(messige: "$e"));
    }
  }

  // Future signInWithGoogle(context) async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   if (googleUser == null) {
  //     return;
  //   }
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   await FirebaseAuth.instance.signInWithCredential(credential);
  //   Navigator.of(
  //     context,
  //   ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  // }

  // Obtain the auth details from the request
}
