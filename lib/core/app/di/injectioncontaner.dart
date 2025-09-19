import 'package:ecommerce_app/logic/cubit/login_cubit/login_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setUpingegtion() async {
  await _incore();
}

Future<void> _incore() async {
  sl.registerFactory(LoginCubit.new);
}
