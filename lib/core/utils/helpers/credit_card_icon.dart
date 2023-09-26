import '../../../features/user/payment_methods/domain/entities/payment_method_entity.dart';

String getBrandIcon({PaymentsMethodEntity? card}) {
    switch ( card?.brand) {
      case "American Express":
        return 'assets/images/cc/amex.jpg';
      case "Diners Club":
        return 'assets/images/cc/diners.jpg';
      case "Discover":
        return 'assets/images/cc/discover.jpg';
      case "JCB":
        return 'assets/images/cc/jcb.jpg';
      case "Visa":
        return 'assets/images/cc/visa.jpg';
      case "MasterCard":
        return 'assets/images/cc/mastercard.jpg';
      case "UnionPay":
        return 'assets/images/cc/unionpay.jpg';
      default:
        return 'assets/images/cc/generic.jpg';
    }
  }
