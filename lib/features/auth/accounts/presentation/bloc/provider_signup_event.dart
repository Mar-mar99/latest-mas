part of 'provider_signup_bloc.dart';

abstract class ProviderSignupEvent extends Equatable {
  const ProviderSignupEvent();

  @override
  List<Object> get props => [];
}


class ProviderFirstNameChangedEvent extends ProviderSignupEvent {
  final String firstName;
  const ProviderFirstNameChangedEvent({
    required this.firstName,
  });
  @override
  List<Object> get props => [firstName];
}
class ProviderLastNameChangedEvent extends ProviderSignupEvent {
  final String lastName;
  const ProviderLastNameChangedEvent({
    required this.lastName,
  });
  @override
  List<Object> get props => [lastName];
}
class ProviderEmailChangedEvent extends ProviderSignupEvent {
  final String email;
  const ProviderEmailChangedEvent({
    required this.email,
  });
  @override
  List<Object> get props => [email];
}

class ProviderPhoneChangedEvent extends ProviderSignupEvent {
  final String phone;
  const ProviderPhoneChangedEvent({
    required this.phone,
  });
  @override
  List<Object> get props => [phone];
}

class ProviderCodeChangedEvent extends ProviderSignupEvent {
  final String code;
  const ProviderCodeChangedEvent({
    required this.code,
  });
  @override
  List<Object> get props => [code];
}

class ProviderPasswordChangedEvent extends ProviderSignupEvent {
  final String password;
  const ProviderPasswordChangedEvent({
    required this.password,
  });
  @override
  List<Object> get props => [password];
}
class ProviderConfirmPasswordChangedEvent extends ProviderSignupEvent {
  final String confirmPassword;
  const ProviderConfirmPasswordChangedEvent({
    required this.confirmPassword,
  });
  @override
  List<Object> get props => [confirmPassword];
}
class ProviderAddDocumentEvent extends ProviderSignupEvent {
  final File document;
  ProviderAddDocumentEvent({
    required this.document,
  });
   @override
  List<Object> get props => [document];

}
class ProviderRemoveDocumentEvent extends ProviderSignupEvent {
  final File document;
  ProviderRemoveDocumentEvent({
    required this.document,
  });
   @override
  List<Object> get props => [document];

}
class ProviderSubmitEvent extends ProviderSignupEvent{}

