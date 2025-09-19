part of 'screen_bloc.dart';

@immutable
sealed class ScreenState {}

final class ScreenInitial extends ScreenState {}

final class LoidingStatescreen extends ScreenState {}

final class LoadedStatescreen extends ScreenState {
  final List<PrudctModel> prudictList;

  LoadedStatescreen({required this.prudictList});
}

final class ErrorStatescreen extends ScreenState {
  final String messige;

  ErrorStatescreen({required this.messige});
}
