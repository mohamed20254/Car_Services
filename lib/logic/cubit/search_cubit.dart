import 'package:ecommerce_app/model/get_all_prudict.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<List<PrudctModel>> {
  List<PrudctModel> allItems = []; // سيتم تمرير القائمة لاحقًا

  SearchCubit() : super([]);

  // دالة لتحميل البيانات عند الحاجة
  void setItems(List<PrudctModel> items) {
    allItems = items;
    emit(allItems); // تحديث الحالة
  }

  void search(String query) {
    if (query.isEmpty) {
      emit(allItems);
    } else {
      emit(
        allItems
            .where(
              (item) => item.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }
}
