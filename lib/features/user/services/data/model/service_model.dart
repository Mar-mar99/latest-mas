import '../../../../../core/utils/enums/enums.dart';
import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {


  ServiceModel(
      {
      super.id,
      super.name,
      super.nameAr,
      super.nameUr,
      super.image,
      super.textColor,
      super.fexedPrice,
      super.paymentStatus});

factory  ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
    id : json['id'],
    name : json['name'],
    nameAr : json['name_ar'],
    nameUr : json['name_ur'],
    image : json['image'],
    textColor : json['text_color'],
    fexedPrice : json['price'],
    paymentStatus : json['payment_status']=='paid' ? ServicePaymentType.paid:ServicePaymentType.free
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['name_ur'] = nameUr;
    data['image'] = image;
    data['text_color'] = textColor;
    data['price'] = fexedPrice;
    data['payment_status'] = paymentStatus;
    return data;
  }
}
