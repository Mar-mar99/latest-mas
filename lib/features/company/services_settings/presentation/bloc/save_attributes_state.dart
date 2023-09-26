part of 'save_attributes_bloc.dart';

enum SaveAttributeStatus { init, emptyValue, loading, done, offline, error }

class SaveAttributesState extends Equatable {
  final Map<int, dynamic> data;
  final SaveAttributeStatus saveAttribute;
  final String errorMessage;

  const SaveAttributesState({
    required this.data,
    required this.saveAttribute,
    this.errorMessage='',
  });

  factory SaveAttributesState.empty() {
    return const SaveAttributesState(
      data: {},
      saveAttribute: SaveAttributeStatus.init,

    );
  }

  @override
  List<Object> get props => [data, saveAttribute,errorMessage];

  SaveAttributesState copyWith({
    Map<int, dynamic>? data,
    SaveAttributeStatus? saveAttribute,
    String? errorMessage
  }) {
    print('copy with $data');
    return SaveAttributesState(
      data: data ?? this.data,
      saveAttribute: saveAttribute ?? this.saveAttribute,
      errorMessage: errorMessage??this.errorMessage
    );
  }
}
