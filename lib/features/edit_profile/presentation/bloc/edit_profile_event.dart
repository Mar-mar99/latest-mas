// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class SubmitUserProfileImageEvent extends EditProfileEvent {
  final String firstName;
  final String lastName;
  final int stateId;
  final File avatar;
  SubmitUserProfileImageEvent({
    required this.firstName,
    required this.lastName,
    required this.stateId,
    required this.avatar,
  });
}

class SubmitCompanyProfileImageEvent extends EditProfileEvent {
  final String firstName;
  final String address;
  final int local;
  final int state;
  final File avatar;
  SubmitCompanyProfileImageEvent({
    required this.firstName,
    required this.address,
    required this.local,
    required this.state,
    required this.avatar,
  });

}

class SubmitProviderProfileImageEvent extends EditProfileEvent {
  final String firstName;
  final String lastName;
  final int stateId;
  final File avatar;
  SubmitProviderProfileImageEvent({
    required this.firstName,
    required this.lastName,
    required this.stateId,
    required this.avatar,
  });
}
