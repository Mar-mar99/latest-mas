// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delete_promo_bloc.dart';

abstract class DeletePromoEvent extends Equatable {
  const DeletePromoEvent();

  @override
  List<Object> get props => [];
}

class DeleteEvent extends DeletePromoEvent {
  final int id;
  DeleteEvent({
    required this.id,
  });
}
