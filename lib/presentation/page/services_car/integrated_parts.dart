import 'package:ecommerce_app/core/Routes/app_routes.dart';
import 'package:ecommerce_app/core/constant/app_lotti.dart';
import 'package:ecommerce_app/core/constant/link_services.dart';
import 'package:ecommerce_app/generated/l10n.dart';
import 'package:ecommerce_app/helper/api.dart';
import 'package:ecommerce_app/logic/cubit/langcubit.dart';
import 'package:ecommerce_app/logic/cubit/location_cubit.dart';
import 'package:ecommerce_app/presentation/widget/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntegratedParts extends StatefulWidget {
  const IntegratedParts({super.key});

  @override
  State<IntegratedParts> createState() => _IntegratedPartsState();
}

class _IntegratedPartsState extends State<IntegratedParts>
    with WidgetsBindingObserver {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController parts = TextEditingController();
  GlobalKey<FormState> form = GlobalKey<FormState>();
  String? selectedcar;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    context.read<LocationCubit>().fetchLocation();

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<LocationCubit>().fetchLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isenglish = context.read<LanguageCubit>().state.languageCode == "en";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isenglish ? "Request spare parts" : "طلب قطعه غيار",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
      body: Form(
        key: form,
        child: Padding(
          padding: EdgeInsets.all(9),
          child: SingleChildScrollView(
            child: BlocConsumer<LocationCubit, LocationState>(
              listener: (context, state) {
                if (state is LocationLoaded) {
                  location.text = state.address;
                } else if (state is LocationError) {
                  location.text = state.message;
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    if (state is LocationLoading) CircularProgressIndicator(),
                    Lottie.asset(AppLotti.intedrated, height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(color: Colors.black, height: 1, width: 50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            isenglish ? 'Enter your data' : "ادخل بياناتك",
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                        Container(color: Colors.black, height: 1, width: 50),
                      ],
                    ),
                    Text(
                      isenglish
                          ? "Enter the name of the spare part and its details."
                          : "اخل اسم قطعه الغيار وتفاصيلها",
                    ),
                    SizedBox(height: 10),
                    CustomTextfield2(
                      controller: parts,
                      label: Text(isenglish ? "this" : "هنا"),
                      prefix: Icon(Icons.speaker_notes),
                    ),
                    SizedBox(height: 10),
                    CustomTextfield2(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return S.of(context).valid_name;
                        }
                        return null;
                      },
                      controller: name,
                      label: Text(isenglish ? "name" : "الاسم"),
                      prefix: Icon(Icons.person),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CustomTextfield2(
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return isenglish
                                ? "Enter your phone"
                                : "ادخل رقم الموبايل";
                          }
                          return null;
                        },
                        controller: phone,
                        label: Text(isenglish ? "Phone" : "رقم الموبايل"),
                        prefix: Icon(Icons.phone),
                      ),
                    ),
                    CustomTextfield2(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return isenglish
                              ? "Enter your location"
                              : "ادخل عنوانك ";
                        }
                        return null;
                      },
                      controller: location,
                      label: Text(isenglish ? "location" : "الموقع"),
                      prefix: Icon(Icons.location_on_sharp),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black45),
                      ),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(Icons.car_crash),
                          SizedBox(width: 15),
                          DropdownButton<String>(
                            hint:
                                isenglish
                                    ? Text("Choose the car type   ")
                                    : Text("اختر نوع السيارة   "),

                            value: selectedcar,
                            onChanged: (value) {
                              selectedcar = value;
                              setState(() {});
                            },
                            items:
                                isenglish
                                    ? carTypesen.map((car) {
                                      return DropdownMenuItem<String>(
                                        value: car,
                                        child: Text(car),
                                      );
                                    }).toList()
                                    : carTypesen.map((car) {
                                      return DropdownMenuItem<String>(
                                        value: car,
                                        child: Text(car),
                                      );
                                    }).toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: () async {
                          if (form.currentState!.validate()) {
                            var response = await ApiMethod().post(
                              url: LinkServices.services,
                              data: {
                                "name": name.text,
                                "phone": phone.text,
                                "location": location.text,
                                "servicesname":
                                    "IntegratedParts && $selectedcar && ${parts.text}",
                              },
                            );
                            if (response['status'] == "sucsses") {
                              showDialog(
                                builder:
                                    (context) => CupertinoAlertDialog(
                                      title: Text(
                                        isenglish ? "succeeded" : "تم الارسال",
                                      ),
                                      content: Text(
                                        isenglish
                                            ? "You will be contacted within 24 hours."
                                            : "سيتم الاتصال بك خلال 24 ساعهقطع غيار",
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          onPressed:
                                              () =>
                                                  Navigator.pushReplacementNamed(
                                                    context,
                                                    AppRoutes.home,
                                                  ),
                                          child: Text("ok"),
                                        ),
                                      ],
                                    ),
                                context: context,
                              );
                            } else {
                              // ignore: avoid_print
                              print('Erorrrrrrrrrrrrrrrrrrrrr');
                            }
                          }
                        },
                        child: Text(
                          isenglish ? "Send" : "ارسال",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<String> carTypesen = [
    'Toyota',
    'Nissan',
    'Honda',
    'Hyundai',
    'Kia',
    'Mercedes',
    'BMW',
    'Audi',
    'Ford',
    'Chevrolet',
    'Jeep',
    'Mazda',
    'Lexus',
    'Tesla',
    'Porsche',
    'Range Rover',
  ];
  List<String> carTypesar = [
    'تويوتا',
    'نيسان',
    'هوندا',
    'هيونداي',
    'كيا',
    'مرسيدس',
    'بي إم دبليو',
    'أودي',
    'فورد',
    'شيفروليه',
    'جيب',
    'مازدا',
    'لكزس',
    'تسلا',
    'بورش',
    'رنج روفر',
  ];
}
