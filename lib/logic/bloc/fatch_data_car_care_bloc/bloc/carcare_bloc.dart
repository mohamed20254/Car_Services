import 'package:ecommerce_app/model/get_all_prudict.dart';
import 'package:ecommerce_app/services/all_prudict.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'carcare_event.dart';
part 'carcare_state.dart';

class CarcareBloc extends Bloc<CarcareEvent, CarcareState> {
  final Servises service;
  CarcareBloc(this.service) : super(CarcareInitial()) {
    on<CarcareEvent>((event, emit) async {
      if (event is Fatchdatabloccarcare) {
        emit(Lodingstatecarcare());
        try {
          await Future.delayed(Duration(seconds: 2));
          final prudict = await service.getAllPrudictcarcare();
          emit(LoadedStatecarcrae(prudictList: prudict));
        } catch (ex) {
          emit(ErrorStatecarcare(messige: " Error"));
        }
      }
    });
  }
}
