part of 'remove_fav_bloc.dart';

abstract class RemoveFavEvent extends Equatable {
  const RemoveFavEvent();

  @override
  List<Object> get props => [];
}
class RemoveFavProvider extends RemoveFavEvent {
  final int providerId;
  RemoveFavProvider({
    required this.providerId,
  });
}
