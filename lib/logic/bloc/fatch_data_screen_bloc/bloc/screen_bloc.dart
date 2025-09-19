import 'package:ecommerce_app/model/get_all_prudict.dart';
import 'package:ecommerce_app/services/all_prudict.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'screen_event.dart';
part 'screen_state.dart';

class ScreenBloc extends Bloc<ScreenEvent, ScreenState> {
  final Servises service;
  ScreenBloc(this.service) : super(LoidingStatescreen()) {
    on<ScreenEvent>((event, emit) async {
      if (event is FatchDataEveentscreen) {
        emit(LoidingStatescreen());
        try {
          await Future.delayed(Duration(seconds: 2));
          final prudict = await service.getAllPrudictscreen();
          emit(LoadedStatescreen(prudictList: prudict));
        } catch (ex) {
          emit(ErrorStatescreen(messige: " Error"));
        }
      }
    });
  }
}
