part of 'remove_fav_bloc.dart';

abstract class RemoveFavState extends Equatable {
  const RemoveFavState();

  @override
  List<Object> get props => [];
}

class RemoveFavInitial extends RemoveFavState {}

class LoadingRemoveFav extends RemoveFavState {}

class LoadedRemoveFav extends RemoveFavState {

}

class RemoveFavOfflineState extends RemoveFavState {}

class RemoveFavErrorState extends RemoveFavState {
  final String message;
  const RemoveFavErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
