part of 'carcare_bloc.dart';

@immutable
sealed class CarcareState {}

final class CarcareInitial extends CarcareState {}

final class Lodingstatecarcare extends CarcareState {}

final class LoadedStatecarcrae extends CarcareState {
  final List<PrudctModel> prudictList;

  LoadedStatecarcrae({required this.prudictList});
}

final class ErrorStatecarcare extends CarcareState {
  final String messige;

  ErrorStatecarcare({required this.messige});
}
