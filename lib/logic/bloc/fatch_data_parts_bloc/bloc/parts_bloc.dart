import 'package:ecommerce_app/model/get_all_prudict.dart';
import 'package:ecommerce_app/services/all_prudict.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'parts_event.dart';
part 'parts_state.dart';

class PartsBloc extends Bloc<PartsEvent, PartsState> {
  final Servises service;
  PartsBloc(this.service) : super(LoidingStateparts()) {
    on<PartsEvent>((event, emit) async {
      if (event is FatchDataEveentparts) {
        emit(LoidingStateparts());
        try {
          await Future.delayed(Duration(seconds: 2));
          final prudict = await service.getAllPrudictparts();
          emit(LoadedStateparts(prudictList: prudict));
        } catch (ex) {
          emit(ErrorStateparts(messige: " Error"));
        }
      }
    });
  }
}
