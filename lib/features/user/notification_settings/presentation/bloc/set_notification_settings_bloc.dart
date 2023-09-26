// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:masbar/features/user/notification_settings/domain/use_cases/set_notification_settings_use_case.dart';

import '../../../../../core/errors/failures.dart';
import '../../data/model/notification_settings_model.dart';

part 'set_notification_settings_event.dart';
part 'set_notification_settings_state.dart';

class SetNotificationSettingsBloc
    extends Bloc<SetNotificationSettingsEvent, SetNotificationSettingsState> {
  final SetNotificationSettingsUseCase setNotificationSettingsUseCase;
  SetNotificationSettingsBloc({
    required this.setNotificationSettingsUseCase,
  }) : super(SetNotificationSettingsInitial()) {
    on<SetNotificationEvent>((event, emit) async {
      emit(LoadingSetNotificationSettings());
      final res = await setNotificationSettingsUseCase.call(event.data);
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (data) => emit(
                LoadedSetNotificationSettings(),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(SetNotificationSettingsOfflineState());
        break;

      case NetworkErrorFailure:
        emit(SetNotificationSettingsErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const SetNotificationSettingsErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
