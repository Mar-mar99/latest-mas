part of 'edit_profile_bloc.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class LoadingEditProfile extends EditProfileState {}

class DoneEditProfile extends EditProfileState {}

class EditProfileOfflineState extends EditProfileState {}

class EditProfileErrorState extends EditProfileState {
  final String message;
  const EditProfileErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
