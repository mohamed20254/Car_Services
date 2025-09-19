import 'dart:io';
import 'dart:ui';
import 'package:ecommerce_app/core/Routes/app_routes.dart';
import 'package:ecommerce_app/core/app/class/sharepref.dart';
import 'package:ecommerce_app/core/constant/app_lotti.dart';
import 'package:ecommerce_app/core/constant/images_.dart';
import 'package:ecommerce_app/core/constant/strings.dart';
import 'package:ecommerce_app/generated/l10n.dart';
import 'package:ecommerce_app/logic/cubit/img_paker_cubit.dart';
import 'package:ecommerce_app/logic/cubit/langcubit.dart';
import 'package:ecommerce_app/logic/cubit/themecubit.dart';
import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/model/fav_model.dart';
import 'package:ecommerce_app/presentation/page/cart_screen.dart';
import 'package:ecommerce_app/presentation/page/favorit_screen.dart';
import 'package:ecommerce_app/presentation/page/profil_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

class CustomBlurDrawer extends StatelessWidget {
  const CustomBlurDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isenglish = context.read<LanguageCubit>().state.languageCode == "en";
    return Drawer(
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.white.withOpacity(0.0)),
          ),

          // المحتوى
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _drawerHeader(isenglish),
                Divider(),
                _drawerShortcuts(context, isenglish),
                Divider(),
                Expanded(child: _drawerSettings(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerHeader(isenglish) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<ImageCubit, File?>(
            builder: (context, state) {
              return CircleAvatar(
                radius: 35,
                backgroundImage:
                    state != null
                        ? FileImage(state)
                        : AssetImage(AppImges.nouser),
              );
            },
          ),
          SizedBox(height: 10),
          Text(
            isenglish ? "Welcome!" : 'مرحبًا بك!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            FirebaseAuth.instance.currentUser!.email.toString(),
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _drawerShortcuts(BuildContext context, isenglish) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _drawerIcon(
            context,
            Icons.home_outlined,
            isenglish ? "home" : 'الرئيسية',
            ontap: () {
              Navigator.of(context).pop();
            },
          ),
          _drawerIcon(
            context,
            Icons.shopping_cart_outlined,
            S.of(context).card,
            ontap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => CardScreen()));
            },
          ),
          _drawerIcon(
            context,
            Icons.favorite_border,
            S.of(context).favorit,
            ontap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => FavoritScreen()));
            },
          ),
          _drawerIcon(
            context,
            Icons.receipt_long_sharp,
            isenglish ? "My requests" : 'طلباتي',
            ontap: () {
              Navigator.pushNamed(context, AppRoutes.myRequsetScreen);
            },
          ),
          _drawerIcon(
            context,
            Icons.settings,
            isenglish ? "Setting " : "الاعدادات",
            ontap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => ProfilScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerIcon(
    BuildContext context,
    IconData icon,
    String label, {
    ontap,
  }) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          Icon(icon, size: 28),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _drawerSettings(BuildContext context) {
    final languageCubit = context.watch<LanguageCubit>();
    bool isenglish = languageCubit.state.languageCode == "en";
    return Column(
      children: [
        RowProfile(
          text: S.of(context).dark_mode,
          icon: Icon(Icons.dark_mode),
          sufix: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
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
        ),

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
              SizedBox(width: 10),
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
          },
        ),
        Spacer(),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Lottie.asset(AppLotti.car, fit: BoxFit.fill),
        ),
      ],
    );
  }
}
