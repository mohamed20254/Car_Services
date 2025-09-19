import 'dart:io';

import 'package:ecommerce_app/core/Routes/app_routes.dart';
import 'package:ecommerce_app/core/app/class/sharepref.dart';
import 'package:ecommerce_app/core/constant/images_.dart';
import 'package:ecommerce_app/core/constant/strings.dart';
import 'package:ecommerce_app/generated/l10n.dart';
import 'package:ecommerce_app/logic/cubit/img_paker_cubit.dart';
import 'package:ecommerce_app/logic/cubit/langcubit.dart';
import 'package:ecommerce_app/logic/cubit/notivication_cubit.dart';
import 'package:ecommerce_app/logic/cubit/themecubit.dart';
import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/model/fav_model.dart';
import 'package:ecommerce_app/model/my_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isenglis =
        context.watch<LanguageCubit>().state.languageCode == "en";
    final Uri url = Uri.parse('https://ecommerce-b2b61.web.app');

    Future<void> llaunchUrl() async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    void openWhatsAppChat(String phone, {String message = ''}) async {
      final Uri whatsappUrl = Uri.parse(
        "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
      );

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch WhatsApp chat';
      }
    }

    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    final languageCubit = context.watch<LanguageCubit>();
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 100),
              SizedBox(
                height: 100,
                width: 100,
                // child: CircleAvatar(
                //   backgroundImage: AssetImage(AppImges.nouser),
                //   backgroundColor: Colors.black,

                // ),
                child: BlocBuilder<ImageCubit, File?>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: () {
                        context.read<ImageCubit>().pickImage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image:
                              state != null
                                  ? DecorationImage(image: FileImage(state))
                                  : DecorationImage(
                                    image: AssetImage(AppImges.nouser),
                                  ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Text(
                " ${FirebaseAuth.instance.currentUser!.email}",
                style: GoogleFonts.aclonica(
                  textStyle: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              SizedBox(height: 5),

              Divider(),

              RowProfile(
                text: S.of(context).dark_mode,
                icon: Icon(Icons.dark_mode),
                sufix: SizedBox(
                  height: 20,
                  child: Switch(
                    value:
                        context.watch<ThemeCubit>().state.brightness ==
                        Brightness.dark,
                    onChanged: (p0) {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                ),
              ),

              Divider(indent: 100, endIndent: 100),

              Row(
                children: [
                  SizedBox(width: 18),
                  Icon(Icons.language_rounded),
                  SizedBox(width: 15),
                  Text(
                    S.of(context).language_tilte,
                    style: GoogleFonts.abhayaLibre(
                      textStyle: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Spacer(),
                  DropdownButton<String>(
                    style: Theme.of(context).textTheme.headlineSmall,
                    value: languageCubit.state.languageCode,

                    items: [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'ar', child: Text('العربية')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        languageCubit.changeLanguage(value);
                      }
                    },
                  ),
                ],
              ),
              Divider(indent: 100, endIndent: 100),
              BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  return RowProfile(
                    text: S.of(context).nativication,
                    icon: Icon(Icons.notifications_active),
                    sufix: SizedBox(
                      height: 20,
                      child: Switch(
                        value: state.isNotificationEnabled,
                        onChanged: (value) async {
                          // تغيير حالة الإشعارات باستخدام Cubit
                          context.read<NotificationCubit>().toggleNotification(
                            value,
                          );

                          // تفعيل أو تعطيل الإشعارات باستخدام FirebaseMessaging
                          if (value) {
                            // طلب إذن الإشعارات
                            firebaseMessaging.requestPermission();
                            // الاشتراك في الموضوع لإرسال الإشعارات
                            firebaseMessaging.subscribeToTopic('news');
                          } else {
                            // إلغاء الاشتراك في الموضوع
                            firebaseMessaging.unsubscribeFromTopic('news');
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
              Divider(indent: 100, endIndent: 100),
              RowProfile(
                onTap: llaunchUrl,
                text: isenglis ? "Apouts as" : "عنا",
                icon: Icon(Icons.insert_chart_outlined_outlined),
                sufix: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 15,
                  color: Colors.blue,
                ),
              ),

              Divider(indent: 100, endIndent: 100),
              RowProfile(
                onTap: () {
                  openWhatsAppChat(
                    "201200262567",
                    message: "Hello, I have a question!",
                  );
                },
                text: isenglis ? "Contact on WhatsApp" : "تواصل معنا",
                icon: Icon(Icons.wechat_sharp),
                sufix: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.blue,
                  size: 16,
                ),
              ),

              Divider(indent: 100, endIndent: 100),

              RowProfile(
                icon: Icon(Icons.logout),
                sufix: Row(
                  children: [
                    Text(
                      S.of(context).log_out,
                      style: GoogleFonts.abhayaLibre(
                        textStyle: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_sharp, size: 10),
                  ],
                ),
                text: S.of(context).log_out,
                colortext: Colors.red,
                onTap: () {
                  showDialog(
                    builder:
                        (context) => CupertinoAlertDialog(
                          title: Text(S.of(context).log_out),
                          content: Text(S.of(context).log_out_from_app),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () {
                                //   context.read<AuthCubit>().exit();
                                Box<CartItem> cart = Hive.box<CartItem>(
                                  Strings.cartbox,
                                );
                                if (cart.isNotEmpty) {
                                  cart.clear();
                                }

                                Box<FavModel> fav = Hive.box<FavModel>(
                                  Strings.favBoc,
                                );
                                if (fav.isNotEmpty) {
                                  fav.clear();
                                }
                                Box<MyRequest> reqyest = Hive.box<MyRequest>(
                                  Strings.myrequest,
                                );
                                if (reqyest.isNotEmpty) {
                                  reqyest.clear();
                                }

                                FirebaseAuth.instance.signOut();
                                SharedPref().clearPreferences();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  AppRoutes.login,
                                  (route) => false,
                                );
                              },
                              child: Text(
                                S.of(context).log_out,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            CupertinoDialogAction(
                              onPressed: () => Navigator.pop(context),
                              child: Text(S.of(context).cancel),
                            ),
                          ],
                        ),
                    context: context,
                  );
                  //   context.read<AuthCubit>().exit();
                  // Box<CartItem> cart = Hive.box<CartItem>(Strings.cartbox);
                  // if (cart.isNotEmpty) {
                  //   cart.clear();
                  // }

                  // Box<FavModel> fav = Hive.box<FavModel>(Strings.favBoc);
                  // if (fav.isNotEmpty) {
                  //   fav.clear();
                  // }

                  // FirebaseAuth.instance.signOut();
                  // SharedPref().clearPreferences();
                  // Navigator.of(
                  //   context,
                  // ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RowProfile extends StatelessWidget {
  final String text;
  final Widget icon;
  final Widget sufix;
  final Color? colortext;

  final void Function()? onTap;

  const RowProfile({
    super.key,
    required this.text,
    required this.icon,
    required this.sufix,
    this.onTap,
    this.colortext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(width: 18),
            icon,
            SizedBox(width: 10),

            Text(
              text,
              style: GoogleFonts.abhayaLibre(
                textStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: colortext,
                ),
              ),
            ),
            Spacer(),
            sufix,
          ],
        ),
      ),
    );
  }
}
