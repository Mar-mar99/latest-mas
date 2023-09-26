import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/use_cases/get_documents_use_case.dart';
part 'get_documents_event.dart';
part 'get_documents_state.dart';

class GetDocumentsBloc extends Bloc<GetDocumentsEvent, GetDocumentsState> {
  final GetDocumentsUsecase getDocumentsUsecase;
  GetDocumentsBloc({required this.getDocumentsUsecase})
      : super(GetDocumentsInitial()) {
    on<LoadDocumentsEvent>((event, emit) async {
      emit(LoadingGetDocumentsState());
      final res = await getDocumentsUsecase.call();
      res.fold((f) {
         _mapFailureToState(emit, f);
      }, (documents) => emit(LoadedDocumentsState(documents: documents)));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetDocumentsOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetDocumentsErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const GetDocumentsErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
