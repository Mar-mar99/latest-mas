import 'package:masbar/core/utils/enums/enums.dart';

extension CompanyOwnerTypeExtension on CompanyOwnerType {
  int getNumeber() {
    switch (this) {
      case CompanyOwnerType.citizen:
        return 0;

      case CompanyOwnerType.nonCitizen:
        return 1;
    }
  }
}

extension VerifyByExtension on VerifyByType {
  String getText() {
    switch (this) {
      case VerifyByType.sms:
        return 'sms';
      case VerifyByType.email:
        return 'email';
    }
  }
}

extension SocialLoginTypeExtension on SocialLoginType {
  String getText() {
    switch (this) {
      case SocialLoginType.google:
        return 'google';
      case SocialLoginType.facebook:
        return 'facebook';
      case SocialLoginType.apple:
        return 'apple';
    }
  }
}

extension TypeAuthExtension on TypeAuth {
  getEnum(String value) {
    switch (value) {
      case 'company':
        return TypeAuth.company;
      case 'provider':
        return TypeAuth.provider;
      case '':
        return TypeAuth.user;
    }
  }
}

extension ServicePaymentTypeExtension on ServicePaymentType{
   String getText() {
    switch (this) {

      case ServicePaymentType.paid:
      return 'Paid';
      case ServicePaymentType.free:
        return 'Free';
    }
  }
}

extension PaymentMethodExtension on PaymentMethod {
  String getText() {
    switch (this) {
      case PaymentMethod.cash:
        return "cash";
      case PaymentMethod.wallet:
        return "Wallet";

    
    }
  }
}
