// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'company_signup_bloc.dart';

enum CompanySignupValidation {
  init,
  statesEmpty,
  mainBranchNotSelected,
  hasnotAgreed,
  lessThanTwoDocuments
}

class CompanySignupState extends Equatable {
  final CompanyOwnerType companyOwnerType;
  final String companyName;
  final String email;
  final String phone;
  final List<UAEStateEntity> states;
  final UAEStateEntity mainBranch;
  final int providerCount;
  final String address;
  final String password;
  final String confirmPassword;
  final List<File> documents;
  final VerifyByType verifyByType;
  final bool hasAgreed;
  final FormSubmissionState formSubmissionState;
  final CompanySignupValidation signupValidation;
  CompanySignupState(
      {required this.companyOwnerType,
      required this.companyName,
      required this.email,
      required this.phone,
      required this.states,
      required this.mainBranch,
      required this.providerCount,
      required this.address,
      required this.password,
      required this.confirmPassword,
      required this.documents,
      required this.verifyByType,
      required this.formSubmissionState,
      required this.signupValidation,
      required this.hasAgreed});

  factory CompanySignupState.empty() {
    return CompanySignupState(
      companyOwnerType: CompanyOwnerType.citizen,
      companyName: '',
      email: '',
      phone: '',
      states: [],
      providerCount: 0,
      address: '',
      password: '',
      confirmPassword: '',
      documents: const [],
      mainBranch: UAEStateEntity.empty(),
      hasAgreed: false,
      verifyByType: VerifyByType.email,
      signupValidation: CompanySignupValidation.init,
      formSubmissionState: const InitialFormState(),
    );
  }

  @override
  List<Object> get props => [
        companyOwnerType,
        companyName,
        email,
        phone,
        states,
        providerCount,
        address,
        mainBranch,
        password,
        confirmPassword,
        documents,
        formSubmissionState,
        verifyByType,
        signupValidation,
        hasAgreed
      ];

  CompanySignupState copyWith({
    CompanyOwnerType? companyOwnerType,
    String? companyName,
    String? email,
    String? phone,
    List<UAEStateEntity>? states,
    UAEStateEntity? mainBranch,
    int? providerCount,
    String? address,
    String? password,
    String? confirmPassword,
    List<File>? documents,
    VerifyByType? verifyByType,
    bool? hasAgreed,
    FormSubmissionState? formSubmissionState,
    CompanySignupValidation? signupValidation,
  }) {
    return CompanySignupState(
      companyOwnerType: companyOwnerType ?? this.companyOwnerType,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      states: states ?? this.states,
      mainBranch: mainBranch ?? this.mainBranch,
      providerCount: providerCount ?? this.providerCount,
      address: address ?? this.address,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      documents: documents ?? this.documents,
      verifyByType: verifyByType ?? this.verifyByType,
      hasAgreed: hasAgreed ?? this.hasAgreed,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
      signupValidation: signupValidation ?? this.signupValidation,
    );
  }
}
