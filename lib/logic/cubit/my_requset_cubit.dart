import 'package:ecommerce_app/core/constant/strings.dart';
import 'package:ecommerce_app/model/my_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class MyRequsetCubit extends Cubit<List<MyRequest>> {
  final myRequset = Hive.box<MyRequest>(Strings.myrequest);
  MyRequsetCubit() : super([]) {
    ubdate();
  }

  ubdate() {
    emit(myRequset.values.toList());
  }

  void add(MyRequest items, BuildContext context) {
    bool isadd = false;
    for (var item in myRequset.values) {
      if (item.name == items.name) {
        isadd = true;
        break;
      }
    }
    if (isadd) {
    } else {
      myRequset.add(items);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          duration: Duration(seconds: 1),
          content: Text("sucsess", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    ubdate();
  }

  void removeItme(item) {
    myRequset.deleteAt(item);
    ubdate();
  }
}
