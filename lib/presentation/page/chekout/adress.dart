import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ecommerce_app/generated/l10n.dart';
import 'package:ecommerce_app/logic/cubit/langcubit.dart';
import 'package:ecommerce_app/presentation/page/chekout/Paymen_tPage.dart';
import 'package:ecommerce_app/presentation/widget/auth/costom_buttom.dart';
import 'package:ecommerce_app/presentation/widget/auth/costum_textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Adress extends StatelessWidget {
  final int totil;
  final String image;
  final String title;
  const Adress({
    super.key,
    required this.totil,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController subdivisions = TextEditingController();
    TextEditingController city = TextEditingController();
    TextEditingController zip = TextEditingController();
    bool isenglish = context.watch<LanguageCubit>().state.languageCode == "en";

    String? validateFullName(String? value) {
      if (value == null || value.trim().isEmpty) {
        return "Please enter your full name";
      }

      // Ensure the name contains at least two words
      List<String> names = value.trim().split(" ");
      if (names.length < 2) {
        return "Enter at least first name and last name";
      }

      // Ensure the name contains only Arabic letters and spaces
      // final arabicRegex = RegExp(r'^[\u0600-\u06FF\s]+$');
      // if (!arabicRegex.hasMatch(value)) {
      //   return "Name must contain only Arabic letters";
      // }

      return null;
    }

    final forme = GlobalKey<FormState>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Form(
            key: forme,
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 100),
                      Text(
                        isenglish ? " Adress" : " العنوان",
                        //    textAlign: TextAlign.center,
                        style: GoogleFonts.abrilFatface(
                          fontSize: 25,
                          textStyle: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  Divider(indent: 50, endIndent: 50),

                  CostemTextFiled(
                    controller: name,
                    validator: validateFullName,
                    hint: isenglish ? "full Name" : " الاسم الكامل ",
                    label: isenglish ? "full Name" : " الاسم الكامل ",
                    obscureText: false,
                    icon: Icon(Icons.nest_cam_wired_stand),
                  ),
                  SizedBox(height: 10),
                  CostemTextFiled(
                    controller: email,
                    validator: (valuo) {
                      if (valuo == null ||
                          valuo.isEmpty ||
                          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(valuo)) {
                        return S.of(context).valid_email;
                      }
                      return null;
                    },
                    hint: isenglish ? "email" : "الايميل",
                    label: isenglish ? "email" : "الايميل",
                    obscureText: false,
                    icon: Icon(Icons.email),
                  ),
                  SizedBox(height: 10),
                  CostemTextFiled(
                    controller: phone,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "can't be Empty";
                      } else if (val.length < 11) {
                        return isenglish
                            ? 'cant be phone <11'
                            : "لا يمكن أن يكون الهاتف أقل من 11";
                      } else if (val.length > 11) {
                        return isenglish
                            ? 'cant be phone >11'
                            : 'لا يمكن أن يكون الهاتف أكثر من 11';
                      }
                      return null;
                    },
                    hint: isenglish ? "phone" : "هاتف",
                    label: isenglish ? "phone" : "هاتف",
                    obscureText: false,
                    icon: Icon(Icons.email),
                  ),
                  SizedBox(height: 10),

                  CostemTextFiled(
                    controller: subdivisions,
                    validator: (valuo) {
                      if (valuo == null || valuo.isEmpty) {
                        return isenglish
                            ? "Please enter Governorate "
                            : "يرجى إدخال المحافظة";
                      }
                      final numberRegex = RegExp(r'[0-9]');
                      if (numberRegex.hasMatch(valuo)) {
                        return isenglish
                            ? "The text should not contain numbers."
                            : "يجب ألا يحتوي النص على أرقام";
                      }
                      return null;
                    },
                    hint: isenglish ? "Governorate" : "محافظة",
                    label: isenglish ? "Governorate" : "محافظة",
                    obscureText: false,
                  ),
                  SizedBox(height: 10),
                  CostemTextFiled(
                    controller: city,
                    validator: (valuo) {
                      if (valuo == null || valuo.isEmpty) {
                        return isenglish
                            ? "Please enter ctiy "
                            : "يرجى إدخال المدينة";
                      }
                      final numberRegex = RegExp(r'[0-9]');
                      if (numberRegex.hasMatch(valuo)) {
                        return isenglish
                            ? "The text should not contain numbers."
                            : "يجب ألا يحتوي النص على أرقام";
                      }
                      return null;
                    },
                    hint: isenglish ? "ctiy" : "المدينة",
                    label: isenglish ? "ctiy" : "المدينة",
                    obscureText: false,
                  ),
                  SizedBox(height: 10),
                  CostemTextFiled(
                    controller: zip,
                    validator: (valuo) {
                      if (valuo == null || valuo.isEmpty) {
                        return isenglish
                            ? "Please enter street "
                            : "يرجى إدخال الشارع";
                      }
                      final numberRegex = RegExp(r'[0-9]');
                      if (numberRegex.hasMatch(valuo)) {
                        return isenglish
                            ? "The text should not contain numbers."
                            : "يجب ألا يحتوي النص على أرقام";
                      }
                      return null;
                    },
                    hint: isenglish ? "street" : "الشارع",
                    label: isenglish ? "street" : "الشارع",
                    obscureText: false,
                  ),
                  CustomButtomAuth(
                    onTap: () {
                      if (forme.currentState!.validate()) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => PaymentPage(
                                  image: image,
                                  price: totil.toString(),
                                  title: title,
                                  totil: totil,

                                  subdivisions: subdivisions.text,
                                  city: city.text,
                                  email: email.text,
                                  name: name.text,
                                  phone: phone.text,
                                  street: zip.text,
                                ),
                          ),
                        );
                      }
                    },
                    text: Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    widgett: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Dropdewnt2 extends StatelessWidget {
  final List<String> list;
  const Dropdewnt2({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        // Add Horizontal padding using menuItemStyleData.padding so it matches
        // the menu padding when button's width is not specified.
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: UnderlineInputBorder(),
        // Add more decoration..
      ),
      hint: const Text('Select Your Gender', style: TextStyle(fontSize: 14)),
      items:
          list
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select gender.';
        }
        return null;
      },
      onChanged: (value) {
        //Do something when selected item is changed.
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          //  border: Border.symmetric(horizontal: BorderSide(color: Colors.black)),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
