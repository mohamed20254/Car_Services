import 'package:ecommerce_app/core/Routes/app_routes.dart';
import 'package:ecommerce_app/core/constant/app_lotti.dart';
import 'package:ecommerce_app/core/constant/link_services.dart';
import 'package:ecommerce_app/logic/cubit/langcubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lottie/lottie.dart';

class FilteredByPhonePage extends StatefulWidget {
  final String phoneToFilter; // رقم الهاتف المراد البحث عنه

  const FilteredByPhonePage({required this.phoneToFilter});

  @override
  _FilteredByPhonePageState createState() => _FilteredByPhonePageState();
}

class _FilteredByPhonePageState extends State<FilteredByPhonePage> {
  List<dynamic> _filteredRequests = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndFilterData();
  }

  Future<void> _fetchAndFilterData() async {
    final response = await http.get(Uri.parse(LinkServices.getsendrequst));

    if (response.statusCode == 200) {
      List<dynamic> allRequests = json.decode(response.body);

      // ✅ فلترة الطلبات حسب رقم الهاتف
      List<dynamic> filtered =
          allRequests.where((request) {
            final phone = request['phone']?.toString() ?? "";
            return phone == widget.phoneToFilter;
          }).toList();

      setState(() {
        _filteredRequests = filtered;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("فشل في تحميل البيانات")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRoutes.home,
                              (route) => false,
                            );
                          },
                          icon: Icon(Icons.arrow_back),
                        ),
                        Spacer(),
                        state == Locale("en")
                            ? Text(
                              "  Number Requests : ${widget.phoneToFilter} ",
                              style: Theme.of(context).textTheme.titleSmall,
                            )
                            : Text(
                              "طلبات الرقم: ${widget.phoneToFilter} ",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                      ],
                    ),

                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _fetchAndFilterData();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 28, 25, 231),
                                  Colors.lightBlueAccent,
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.refresh,
                                  size: 17,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Refresh",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 150,
                      child: Stack(
                        children: [
                          Lottie.asset(AppLotti.plesewait),
                          Positioned.fill(
                            top: 40,
                            child: Lottie.asset(
                              AppLotti.wait,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),

                    _loading
                        ? Center(child: CircularProgressIndicator())
                        : _filteredRequests.isEmpty
                        ? Center(child: Text("لا توجد طلبات بهذا الرقم"))
                        : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _filteredRequests.length,
                          itemBuilder: (context, index) {
                            final request = _filteredRequests[index];
                            return Card(
                              child: Container(
                                decoration: BoxDecoration(),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        "problem: ${request['problem']}",
                                      ),
                                      subtitle: Text(
                                        "status: ${request['state']}",
                                      ),
                                      trailing: Text("📅 ${request['name']}"),
                                    ),
                                    state == Locale("en")
                                        ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Please wait and we will get back to you within 10 minutes",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.labelLarge,
                                          ),
                                        )
                                        : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "الرجاء الانتظار سيتم الرد عليك خلال 10 دقاءق ",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.labelLarge,
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
