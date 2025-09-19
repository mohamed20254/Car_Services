import 'package:ecommerce_app/core/constant/app_lotti.dart';
import 'package:ecommerce_app/logic/bloc/fatch_data_bloc/fatch_data_bloc.dart';
import 'package:ecommerce_app/logic/cubit/my_requset_cubit.dart';
import 'package:ecommerce_app/logic/cubit/search_cubit.dart';
import 'package:ecommerce_app/model/my_request.dart';
import 'package:ecommerce_app/presentation/page/my_requset_Screen.dart';
import 'package:ecommerce_app/presentation/page/services_car/Maintenan_car/welcome_bage.dart';
import 'package:ecommerce_app/presentation/widget/custom_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

PreferredSizeWidget newMethod(BuildContext context) {
  return AppBar(
    elevation: 3,
    shadowColor: Colors.black,

    // flexibleSpace: Container(
    //   decoration: BoxDecoration(
    //     gradient: LinearGradient(
    //       colors: const [
    //         Color.fromARGB(255, 255, 255, 255),

    //         Color.fromARGB(255, 255, 254, 254),
    //       ],
    //       begin: Alignment.topLeft,
    //       end: Alignment.bottomRight,
    //     ),
    //   ),
    // ),

    // iconTheme: const IconThemeData(color: Colors.white),
    title: SizedBox(
      height: 50,
      child: Stack(
        children: [
          Positioned(
            top: 18,
            left: 1,
            child: Text(
              "Auoto Express ",
              style: GoogleFonts.aBeeZee(
                fontSize: 18,
                // color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: 70,
            top: 10,

            child: Text(
              " Maintennce ",
              style: GoogleFonts.aBeeZee(
                fontSize: 10,
                // color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),

    actions: [
      BlocBuilder<MyRequsetCubit, List<MyRequest>>(
        builder: (context, state) {
          return InkWell(
            onTap:
                () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MyRequsetScreen()),
                ),
            child: Badge(
              label: state.isEmpty ? Text("0") : Text(state.length.toString()),
              child: Icon(Icons.notifications_active),
            ),
          );
        },
      ),
      BlocBuilder<FatchDataBloc, FatchDataState>(
        builder: (context, state) {
          if (state is LoadedState) {
            return InkWell(
              onTap: () {
                context.read<SearchCubit>().setItems(state.prudictList);
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.search),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.search, color: Colors.black),
          );
        },
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => WelcomePage()));
          },
          child: SizedBox(height: 30, child: Lottie.asset(AppLotti.logosparts)),
        ),
      ),
    ],
  );
}
