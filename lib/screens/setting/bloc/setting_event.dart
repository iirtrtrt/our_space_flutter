part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();
}

class SettingEditEvent extends SettingEvent {
  final String username;

  const SettingEditEvent({
    required this.username,
  });

  @override
  List<Object?> get props => [];
}
