// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_card_bloc.dart';

abstract class AddCardEvent extends Equatable {
  const AddCardEvent();

  @override
  List<Object> get props => [];
}


class AddEvent extends AddCardEvent {
final StripeCard stripeCard;
  AddEvent({
    required this.stripeCard,
  });
}
