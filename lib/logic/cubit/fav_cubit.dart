import 'package:ecommerce_app/core/constant/strings.dart';
import 'package:ecommerce_app/model/fav_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class FavCubit extends Cubit<List<FavModel>> {
  final favbox = Hive.box<FavModel>(Strings.favBoc);
  FavCubit() : super([]) {
    ubdate();
  }

  ubdate() {
    emit(favbox.values.toList());
  }

  void addFav(FavModel items, BuildContext context) {
    bool isadd = false;
    for (var item in favbox.values) {
      if (item.name == items.name) {
        isadd = true;
        break;
      }
    }
    if (isadd) {
      favbox.values.firstWhere((element) => element.id == items.id).delete();
    } else {
      favbox.add(items);
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
    favbox.deleteAt(item);
    ubdate();
  }
}
