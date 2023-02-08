part of 'setting_bloc.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingEmptyState extends SettingState {}

class SettingLoadingState extends SettingState {}

class SettingUpdatedState extends SettingState {
  final User user;

  const SettingUpdatedState(this.user);

  @override
  List<Object> get props => [user];
}

class SettingErrorState extends SettingState {
  final Exception exception;

  const SettingErrorState(this.exception);

  @override
  List<Object> get props => [exception];
}
