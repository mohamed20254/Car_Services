import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/constant/app_lotti.dart';
import 'package:ecommerce_app/logic/cubit/langcubit.dart';
import 'package:ecommerce_app/logic/cubit/my_requset_cubit.dart';
import 'package:ecommerce_app/model/my_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MyRequsetScreen extends StatelessWidget {
  const MyRequsetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isenglish = context.read<LanguageCubit>().state.languageCode == "en";
    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.transparent,
        title: Text(
          isenglish ? "Myrequest" : "طلباتي",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<MyRequsetCubit, List<MyRequest>>(
                builder: (context, state) {
                  try {
                    if (state.isEmpty) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                              ),
                              Icon(Icons.notifications_none_sharp, size: 50),
                              SizedBox(height: 1),
                              Text(
                                isenglish
                                    ? "My request is empty! "
                                    : "لا يوجد طلبات",
                                style: GoogleFonts.aBeeZee(
                                  textStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    //  else if (state == null) {
                    //   return Container();
                    // }
                    else {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: state.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.send,
                                            color: Colors.blueAccent,
                                          ),
                                          Spacer(),
                                          IconButton(
                                            onPressed: () {
                                              context
                                                  .read<MyRequsetCubit>()
                                                  .removeItme(index);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    isenglish
                                        ? Row(
                                          children: [
                                            Text(
                                              "name:",
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                " ${state[index].name}",
                                              ),
                                            ),
                                          ],
                                        )
                                        : Row(
                                          children: [
                                            Text(
                                              "الاسم:",
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "${state[index].name} ",
                                              ),
                                            ),
                                          ],
                                        ),

                                    isenglish
                                        ? Row(
                                          children: [
                                            Text(
                                              "price :",
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text("${state[index].price} EGP "),
                                          ],
                                        )
                                        : Row(
                                          children: [
                                            Text(
                                              "سعر :",
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text("${state[index].price} جنيه "),
                                          ],
                                        ),
                                    isenglish
                                        ? Row(
                                          children: [
                                            Text(
                                              "content: ",
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "${state[index].decen} ",
                                                softWrap: true,
                                              ),
                                            ),
                                          ],
                                        )
                                        : Row(
                                          children: [
                                            Text(
                                              "المحتوي ",
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "${state[index].decar} ",
                                              ),
                                            ),
                                          ],
                                        ),
                                    isenglish
                                        ? Row(
                                          children: [
                                            Text(
                                              " Payment : ",
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text("${state[index].paymenten} "),
                                          ],
                                        )
                                        : Row(
                                          children: [
                                            Text(
                                              " الدفع : ",
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(" ${state[index].paymentar} "),
                                          ],
                                        ),
                                  ],
                                ),
                              ),
                            ),
                            //  ListTile(
                            //   leading: Icon(
                            //     Icons.send_rounded,
                            //     color: Colors.blueAccent,
                            //   ),
                            //   title: Column(
                            //     children: [
                            //       Text(
                            //         "${state[index].name.toString().substring(0, 20)}...",
                            //       ),
                            //       Text(
                            //         state[index].name.toString().substring(
                            //           0,
                            //           20,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            //   trailing: IconButton(
                            //     onPressed: () {
                            //       context.read<MyRequsetCubit>().removeItme(
                            //         index,
                            //       );
                            //     },
                            //     icon: Icon(Icons.delete, color: Colors.red),
                            //   ),
                            // ),
                          );
                        },
                      );
                    }
                  } catch (a) {
                    Text(
                      "bvvbnm,./kjhghjk",
                      style: TextStyle(color: Colors.black),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
