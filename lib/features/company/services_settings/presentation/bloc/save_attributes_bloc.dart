import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';

import '../../domain/use_cases/save_attributes_use_case.dart';

part 'save_attributes_event.dart';
part 'save_attributes_state.dart';

class SaveAttributesBloc
    extends Bloc<SaveAttributesEvent, SaveAttributesState> {
  final SaveAttributesUseCase saveAttributesUseCase;
  SaveAttributesBloc({
    required this.saveAttributesUseCase,
  }) : super(SaveAttributesState.empty()) {
    on<AddValueAttributeEvent>((event, emit) {
      var newData = state.data;
      newData[event.key] = event.value;

      print('new Data $newData');
      emit(state.copyWith(
          data: Map.from(newData), saveAttribute: SaveAttributeStatus.init));
    });

    on<ClearAttributesEvent>((event, emit) {
      emit(state.copyWith(data: {}, saveAttribute: SaveAttributeStatus.init));
    });

    on<SubmitAttributesEvent>((event, emit) async {
      emit(state.copyWith(saveAttribute: SaveAttributeStatus.loading));

      List<Map<String, dynamic>> attributes = [];


      for (var element in event.initValues.keys) {
        //user has enetered a value
        if (state.data.containsKey(element)) {
          //value not empty
          if ((state.data[element] as String).isNotEmpty) {
            attributes.add({
              "provider_id": event.providerId,
              "attribute_id": element,
              "attribute_value": state.data[element]
            });
          } else {
            //value entered is empty
            emit(state.copyWith(saveAttribute: SaveAttributeStatus.emptyValue));
            return;
          }
        } else {
          //empty init value
          if (event.initValues[element]!.isEmpty) {
            emit(state.copyWith(saveAttribute: SaveAttributeStatus.emptyValue));
            return;
          } else {
            //has init value
            attributes.add({
              "provider_id": event.providerId,
              "attribute_id": element,
              "attribute_value": event.initValues[element]
            });
          }
        }
      }

      final res = await saveAttributesUseCase.call(attributes: attributes);
      res.fold((f) {
        _mapFailureToState(emit, f);
      },
          (r) => emit(state
              .copyWith(data: {}, saveAttribute: SaveAttributeStatus.done,),),);
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(state.copyWith(
          saveAttribute: SaveAttributeStatus.offline,
        ));
        break;

      case NetworkErrorFailure:
        emit(state.copyWith(
            saveAttribute: SaveAttributeStatus.error,
            errorMessage: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(state.copyWith(
            saveAttribute: SaveAttributeStatus.error,
            errorMessage: (f as NetworkErrorFailure).message));
        break;
    }
  }
}
