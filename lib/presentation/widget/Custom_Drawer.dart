import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Drawerr extends StatelessWidget {
  const Drawerr({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// ignore: camel_case_types

// ignore: camel_case_types
class listile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final void Function()? onTapp;
  const listile({super.key, this.leading, this.title, this.onTapp});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapp,

      // color: Colors.white,
      child: ListTile(leading: leading, title: title),
    );
  }
}

void showLogoutDialog(context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(onPressed: () {}, child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                // هنا يمكنك إضافة منطق الخروج (مثل مسح الجلسة أو تسجيل الخروج)
                FirebaseAuth.instance.signOut();
                var sharedPref;
                sharedPref.clear();
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.signOut();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully!')),
                );
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
  );
}
