part of 'add_fav_bloc.dart';

abstract class AddFavState extends Equatable {
  const AddFavState();

  @override
  List<Object> get props => [];
}

class AddFavInitial extends AddFavState {}

class LoadingAddFav extends AddFavState {}

class LoadedAddFav extends AddFavState {

}

class AddFavOfflineState extends AddFavState {}

class AddFavErrorState extends AddFavState {
  final String message;
  const AddFavErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
