// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_fav_bloc.dart';

abstract class AddFavEvent extends Equatable {
  const AddFavEvent();

  @override
  List<Object> get props => [];
}
class AddFavProvider extends AddFavEvent {
  final int providerId;
  AddFavProvider({
    required this.providerId,
  });
}
