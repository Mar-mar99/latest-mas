// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


import '../../../../../core/errors/failures.dart';
import '../../data/model/provider_notification_settings_model.dart';
import '../../domain/use_cases/set_provider_notification_settings_use_case.dart';

part 'set_provider_notification_settings_event.dart';
part 'set_provider_notification_settings_state.dart';

class SetProviderNotificationSettingsBloc
    extends Bloc<SetNotificationSettingsEvent, SetProviderNotificationSettingsState> {
  final SetProviderNotificationSettingsUseCase setNotificationSettingsUseCase;
  SetProviderNotificationSettingsBloc({
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
