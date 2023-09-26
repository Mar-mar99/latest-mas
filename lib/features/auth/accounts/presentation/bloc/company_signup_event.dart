// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'company_signup_bloc.dart';

abstract class CompanySignupEvent extends Equatable {
  const CompanySignupEvent();

  @override
  List<Object> get props => [];
}


class CompanyTypeChangedEvent extends CompanySignupEvent {
   final CompanyOwnerType companyOwnerType;
  const CompanyTypeChangedEvent({
    required this.companyOwnerType,
  });
  @override
  List<Object> get props => [companyOwnerType];
}

class CompanyNameChangedEvent extends CompanySignupEvent {
  final String companyName;
  const CompanyNameChangedEvent({
    required this.companyName,
  });
  @override
  List<Object> get props => [companyName];
}

class CompanyEmailChangedEvent extends CompanySignupEvent {
  final String email;
  const CompanyEmailChangedEvent({
    required this.email,
  });
  @override
  List<Object> get props => [email];
}

class CompanyAddressChangedEvent extends CompanySignupEvent {
  final String address;
  const CompanyAddressChangedEvent({
    required this.address,
  });
  @override
  List<Object> get props => [address];
}

class CompanyPhoneChangedEvent extends CompanySignupEvent {
  final String phone;
  const CompanyPhoneChangedEvent({
    required this.phone,
  });
  @override
  List<Object> get props => [phone];
}

class CompanyStateChangedEvent extends CompanySignupEvent {
  final List<UAEStateEntity> states;
  const CompanyStateChangedEvent({
    required this.states,
  });
  @override
  List<Object> get props => [states];
}
class CompanyMainBranchChangedEvent extends CompanySignupEvent {
  final UAEStateEntity mainBranch;
  const CompanyMainBranchChangedEvent({
    required this.mainBranch,
  });
  @override
  List<Object> get props => [mainBranch];
}


class CompanyProviderCountChangedEvent extends CompanySignupEvent {
  final int count;
  const CompanyProviderCountChangedEvent({
    required this.count,
  });
  @override
  List<Object> get props => [count];
}

class CompanyPasswordChangedEvent extends CompanySignupEvent {
  final String password;
  const CompanyPasswordChangedEvent({
    required this.password,
  });
  @override
  List<Object> get props => [password];
}

class CompanyConfirmPasswordChangedEvent extends CompanySignupEvent {
  final String confirmPassword;
  const CompanyConfirmPasswordChangedEvent({
    required this.confirmPassword,
  });
  @override
  List<Object> get props => [confirmPassword];
}

class AddDocumentChangedEvent extends CompanySignupEvent {
  final File document;
  AddDocumentChangedEvent({
    required this.document,
  });
   @override
  List<Object> get props => [document];

}


class RemoveDocumentChangedEvent extends CompanySignupEvent {
  final File document;
  RemoveDocumentChangedEvent({
    required this.document,
  });
   @override
  List<Object> get props => [document];

}

class CompanyVerifyByChangedEvent extends CompanySignupEvent {
 final VerifyByType verifyByType;
  CompanyVerifyByChangedEvent({
    required this.verifyByType,
  });
   @override
  List<Object> get props => [verifyByType];

}


class CompanyAgreeChangedEvent extends CompanySignupEvent {
final bool hasAgreed;
  CompanyAgreeChangedEvent({
    required this.hasAgreed,
  });
  @override

  List<Object> get props => [hasAgreed];
}
class CompanySubmitEvent extends CompanySignupEvent{}

