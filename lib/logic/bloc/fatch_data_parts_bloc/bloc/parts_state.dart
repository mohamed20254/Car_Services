part of 'parts_bloc.dart';

@immutable
sealed class PartsState {}

final class PartsInitial extends PartsState {}

final class LoidingStateparts extends PartsState {}

final class LoadedStateparts extends PartsState {
  final List<PrudctModel> prudictList;

  LoadedStateparts({required this.prudictList});
}

final class ErrorStateparts extends PartsState {
  final String messige;

  ErrorStateparts({required this.messige});
}
