import 'package:ecommerce_app/core/Routes/app_routes.dart';
import 'package:ecommerce_app/core/constant/app_lotti.dart';
import 'package:ecommerce_app/core/constant/images_.dart';
import 'package:ecommerce_app/generated/l10n.dart';
import 'package:ecommerce_app/logic/cubit/langcubit.dart';
import 'package:ecommerce_app/presentation/widget/appbar.dart';
import 'package:ecommerce_app/presentation/widget/catocare_contanir.dart';
import 'package:ecommerce_app/presentation/widget/custom_drwer.dart';
import 'package:ecommerce_app/presentation/widget/grad_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isenglish =
        context.read<LanguageCubit>().state.languageCode == "en";
    return Scaffold(
      drawer: CustomBlurDrawer(),

      // Widget helper للأيقونات
      appBar: newMethod(context),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //    Carculslide(),
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.servicescar);
                    },
                    child: Card(
                      elevation: 10,
                      child: Container(
                        height: 160,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              AppImges.homescreen,
                            ), // تأكد أن الصورة موجودة في assets
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    right: 10,
                    child: Column(
                      crossAxisAlignment:
                          isenglish
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                      children: [
                        Text(
                          isenglish ? "Car Services" : "خدمات السيارات",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          isenglish
                              ? "Professional car services for all your needs.\nFast, reliable, and on-demand."
                              : "خدمات سيارات احترافية تلبي جميع احتياجاتك.\nسريعة، موثوقة، وعند الطلب.",
                          style: TextStyle(fontSize: 8, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Center(child: Lottie.asset(AppLotti.home, height: 50)),
              Text(
                S.of(context).Sections,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 5),

              //                                       ==================Catogari ==========================
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.parts);
                    },
                    child: cardCatogris(
                      context,
                      image: AppImges.sparParts,
                      text: S.of(context).Parts,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.screen);
                    },
                    child: cardCatogris(
                      color: const Color.fromARGB(255, 91, 91, 91),
                      context,
                      image: AppImges.screen,
                      text: S.of(context).screens,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.carcare);
                    },
                    child: cardCatogris(
                      context,
                      image: AppImges.carcare,
                      text: S.of(context).Car_Care,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15),
              Text(
                S.of(context).best_seller,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              //                                                 ==========gradView===========
              Gridview(),
            ],
          ),
        ),
      ),
    );
  }
}
