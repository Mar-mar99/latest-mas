import 'package:equatable/equatable.dart';

import '../../../../../core/utils/enums/enums.dart';

class ServiceEntity extends Equatable {
 final int? id;
 final String? name;
 final String? nameAr;
 final String? nameUr;
 final String? image;
 final String? textColor;
 final dynamic? fexedPrice;
 final  dynamic? price;
 final ServicePaymentType? paymentStatus;

  ServiceEntity(
      {this.id,
      this.name,
      this.nameAr,
      this.nameUr,
      this.image,
      this.textColor,
      this.fexedPrice,
      this.price,
      this.paymentStatus});

        @override

        List<Object?> get props => [
     id,
     name,
     nameAr,
     nameUr,
     image,
     textColor,
     fexedPrice,
     paymentStatus
        ];
}
