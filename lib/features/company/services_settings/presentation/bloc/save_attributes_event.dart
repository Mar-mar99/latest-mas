// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'save_attributes_bloc.dart';

abstract class SaveAttributesEvent extends Equatable {
  const SaveAttributesEvent();

  @override
  List<Object> get props => [];
}

class AddValueAttributeEvent extends SaveAttributesEvent {
  final int key;
  final String value;
  const AddValueAttributeEvent({
    required this.key,
    required this.value,
  });

}

class ClearAttributesEvent extends SaveAttributesEvent{}

class SubmitAttributesEvent extends SaveAttributesEvent {
  final int providerId;

   final Map<int,String> initValues;
  const SubmitAttributesEvent({
    required this.providerId,
   
    required this.initValues
  });

}
