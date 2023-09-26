import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/notification_settings_entity.dart';
import '../../domain/use_cases/get_notification_settings_use_case.dart';

part 'get_notification_settings_event.dart';
part 'get_notification_settings_state.dart';

class GetNotificationSettingsBloc
    extends Bloc<GetNotificationSettingsEvent, GetNotificationSettingsState> {
  final GetNotificationSettingsUseCase getNotificationSettingsUseCase;
  GetNotificationSettingsBloc({required this.getNotificationSettingsUseCase})
      : super(GetNotificationSettingsInitial()) {
    on<FetchNotificationSettingsEvent>((event, emit) async {
      emit(LoadingGetNotificationSettings());
      final res = await getNotificationSettingsUseCase();
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (data) => emit(
                LoadedGetNotificationSettings(data: data),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetNotificationSettingsOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetNotificationSettingsErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const GetNotificationSettingsErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
