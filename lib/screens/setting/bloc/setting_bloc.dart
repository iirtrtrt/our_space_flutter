import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:our_space/exceptions/form_exceptions.dart';
import 'package:our_space/exceptions/secure_storage_exceptions.dart';
import 'package:our_space/model/user_model.dart';
import 'package:our_space/repository/setting_repository.dart';
import 'package:our_space/utils/secure_storage.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final SettingRepository repository;

  SettingBloc({required this.repository}) : super(SettingEmptyState()) {
    on<SettingEditEvent>((event, emit) async {
      emit(SettingLoadingState());
      try {
        final json = await SecureStorage.storage.read(
          key: SecureStorage.userKey,
        );

        final User currentUser;
        if (json != null) {
          currentUser = User.fromJson(jsonDecode(json));
        } else {
          throw SecureStorageNotFoundException();
        }
        // print(currentUser.id);
        // print(event.username);
        final updatedUser = await repository.updateUserInfo(
          id: currentUser.id,
          username: event.username,
        );
        emit(SettingUpdatedState(updatedUser));
      } on FormGeneralException catch (e) {
        emit(SettingErrorState(e));
      } on FormFieldsException catch (e) {
        emit(SettingErrorState(e));
      } catch (e) {
        emit(SettingErrorState(
          FormGeneralException(message: 'Unidentified error'),
        ));
      }
    });
  }
}
