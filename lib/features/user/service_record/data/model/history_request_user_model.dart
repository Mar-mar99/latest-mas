import '../../domain/entities/history_request_user_entity.dart';

class HistoryRequestUserModel extends HistoryRequestUserEntity{

  HistoryRequestUserModel(
      {
        super.id,
        super.bookingId,
        super.providerId,
        super.isEmergency,
        super.emergencyTime,
        super.emergencyPercentage,
        super.afterComment,
        super.status,
        super.cancelledBy,
        super.cancelReason,
        super.paid,
        super.startedAt,
        super.finishedAt,
        super.sLatitude,
        super.sLongitude,
        super.staticMap,
        super.totalServiceTimeInSeconds,
        super.totalServiceTime,
        super.emergencyTimeFormat,
        super.emergencyHourlyRate,
        super.emergencyTimePrice,
        super.payment_mode,
        super.s_address,
        super.images,
        super.payment,
        super.imagesAfter,
        super.serviceType,
        super.rating,
        super.provider});

  factory HistoryRequestUserModel.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
     List<String>  imagesAfter = [];
    if (json['images'] != null) {
      images = [];
      imagesAfter = [];
      json['images'].forEach((v) {
        if(v['image_type'] == 'Before') {
          images.add(v['image']);
        }else if(v['image_type'] == 'After'){
          imagesAfter.add(v['image']);
        }
      });
    }else{
      images = [];
      imagesAfter = [];
    }

    return HistoryRequestUserModel(
    id : json['id'],
    bookingId : json['booking_id'],
    providerId : json['provider_id'],
    isEmergency : json['IsEmergency'],
    emergencyTime : json['emergency_time'],
    emergencyPercentage : json['emergency_percentage'],
    afterComment : json['after_comment']??'',
    status : json['status'],
    cancelledBy : json['cancelled_by'],
    cancelReason : json['cancel_reason'],
    paid : json['paid'],
    startedAt : json['started_at'],
    finishedAt : json['finished_at'],
    sLatitude : json['s_latitude'],
    sLongitude : json['s_longitude'],
    staticMap : json['static_map'],
    totalServiceTimeInSeconds : json['total_service_time_in_seconds'],
    totalServiceTime : json['total_service_time'],
    emergencyTimeFormat : json['emergency_time_format'],
    emergencyHourlyRate : json['emergency_hourly_rate'],
    emergencyTimePrice : json['emergency_time_price'],
    payment_mode : json['payment_mode'],
    s_address : json['s_address'],
    images: images,
    imagesAfter:imagesAfter ,
    payment :
    json['payment'] != null ? PaymentModel.fromJson(json['payment']) : null,
    serviceType : json['service_type'] != null
        ? ServiceTypeModel.fromJson(json['service_type'])
        : null,
    rating : json['rating'] != null
        ? RatingModel.fromJson(json['rating'])
        : null,
    provider : json['provider'] != null
        ? ExpertModel.fromJson(json['provider'])
        : null
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['provider_id'] = providerId;
    data['IsEmergency'] = isEmergency;
    data['emergency_time'] = emergencyTime;
    data['emergency_percentage'] = emergencyPercentage;
    data['after_comment'] = afterComment;
    data['status'] = status;
    data['cancelled_by'] = cancelledBy;
    data['cancel_reason'] = cancelReason;
    data['paid'] = paid;
    data['started_at'] = startedAt;
    data['finished_at'] = finishedAt;
    data['s_latitude'] = sLatitude;
    data['s_longitude'] = sLongitude;
    data['static_map'] = staticMap;
    data['total_service_time_in_seconds'] = totalServiceTimeInSeconds;
    data['total_service_time'] = totalServiceTime;
    data['emergency_time_format'] = emergencyTimeFormat;
    data['emergency_hourly_rate'] = emergencyHourlyRate;
    data['emergency_time_price'] = emergencyTimePrice;
    data['images'] = images;
    if (payment != null) {
      data['payment'] = (payment as PaymentModel ).toJson();
    }
    if (serviceType != null) {
      data['service_type'] = (serviceType as ServiceTypeModel).toJson();
    }
    if (provider != null) {
      data['provider'] = (provider  as ExpertModel ).toJson();
    }
    if (rating != null) {
      data['rating'] = (rating as RatingModel) .toJson();
    }
    return data;
  }
}

class PaymentModel extends PaymentEntity{

  PaymentModel(
      {
        super.id,
        super.requestId,
        super.promocodeId,
        super.paymentId,
        super.paymentMode,
        super.fixed,
        super.distance,
        super.commisionRate,
        super.commision,
        super.hourlyRate,
        super.timePrice,
        super.discount,
        super.lcdRate,
        super.localCompanyDiscount,
        super.tax,
        super.taxRate,
        super.charityRate,
        super.charityValue,
        super.wallet,
        super.total});

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
    id : json['id'],
    requestId : json['request_id'],
    promocodeId : json['promocode_id'].toString(),
    paymentId : json['payment_id'],
    paymentMode : json['payment_mode'],
    fixed : json['fixed'],
    distance : json['distance'],
    commisionRate : json['commision_rate'],
    commision : json['commision'],
    hourlyRate : json['hourly_rate'],
    timePrice : json['time_price'],
    discount : json['discount'],
    lcdRate : json['lcd_rate'],
    localCompanyDiscount : json['local_company_discount'],
    tax : json['tax'],
    taxRate : json['tax_rate'],
    charityRate : json['charity_rate'],
    charityValue : json['charity_value'],
    wallet : json['wallet'],
    total : json['total']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['request_id'] = requestId;
    data['promocode_id'] = promocodeId;
    data['payment_id'] = paymentId;
    data['payment_mode'] = paymentMode;
    data['fixed'] = fixed;
    data['distance'] = distance;
    data['commision_rate'] = commisionRate;
    data['commision'] = commision;
    data['hourly_rate'] = hourlyRate;
    data['time_price'] = timePrice;
    data['discount'] = discount;
    data['lcd_rate'] = lcdRate;
    data['local_company_discount'] = localCompanyDiscount;
    data['tax'] = tax;
    data['tax_rate'] = taxRate;
    data['charity_rate'] = charityRate;
    data['charity_value'] = charityValue;
    data['wallet'] = wallet;
    data['total'] = total;
    return data;
  }
}

class ExpertModel extends ExpertEntity {

  ExpertModel(
      {
        super.id,
        super.companyId,
        super.firstName,
        super.lastName,
        super.name,
        super.email,
        super.phoneCode,
        super.mobile,
        super.avatar,
        super.description,
        super.rating,
        super.status,
        super.latitude,
        super.longitude,
        super.ratingCount,
        super.otp,
        super.verified,
        super.stripeAccId,
        super.isStripeinfoFilled,
        super.isStripeConnected,
        super.type,
        super.providersCount,
        super.commission,
        super.local,
        super.address,
        super.expertActive,
        super.expertOnline});

  factory ExpertModel.fromJson(Map<String, dynamic> json) {
    return ExpertModel(
    id : json['id'],
    companyId : json['company_id'],
    firstName : json['first_name'],
    lastName : json['last_name'],
    name : json['name'],
    email : json['email'],
    phoneCode : json['phone_code'],
    mobile : json['mobile'],
    avatar : json['avatar'],
    description : json['description'],
    rating : json['rating'],
    status : json['status'],
    latitude  : json['latitude'],
    longitude : json['longitude'],
    ratingCount : json['rating_count'],
    otp : json['otp'],
    verified : json['verified'],
    stripeAccId : json['stripe_acc_id'],
    isStripeinfoFilled : json['is_stripeinfo_filled'],
    isStripeConnected : json['is_stripe_connected'],
    type : json['type'],
    providersCount : json['providers_count'],
    commission : json['commission'],
    local : json['local'],
    address : json['address'],
    expertActive : json['expertActive'],
    expertOnline : json['expertOnline'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['name'] = name;
    data['email'] = email;
    data['phone_code'] = phoneCode;
    data['mobile'] = mobile;
    data['avatar'] = avatar;
    data['description'] = description;
    data['rating'] = rating;
    data['status'] = status;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['rating_count'] = ratingCount;
    data['otp'] = otp;
    data['verified'] = verified;
    data['stripe_acc_id'] = stripeAccId;
    data['is_stripeinfo_filled'] = isStripeinfoFilled;
    data['is_stripe_connected'] = isStripeConnected;
    data['type'] = type;
    data['providers_count'] = providersCount;
    data['commission'] = commission;
    data['local'] = local;
    data['address'] = address;
    data['expertActive'] = expertActive;
    data['expertOnline'] = expertOnline;
    return data;
  }
}

class ServiceTypeModel extends ServiceTypeEntity{
  ServiceTypeModel(
      { super.id,
        super.name,
        super.providerName,
        super.image,
        super.fixed,
        super.price,
        super.description,
        super.status,
        super.nameAr,
        super.nameUr,
        super.descriptionAr,
        super.descriptionUr,
        super.providerNameAr,
        super.providerNameUr,
        super.textColor,
        super.paymentStatus});

factory  ServiceTypeModel.fromJson(Map<String, dynamic> json) {
    return ServiceTypeModel(
    id : json['id'],
    name : json['name'],
    providerName : json['provider_name'],
    image : json['image'],
    fixed : json['fixed'],
    price : json['price'],
    description : json['description'],
    status : json['status'],
    nameAr : json['name_ar'],
    nameUr : json['name_ur'],
    descriptionAr :json['description_ar'],
    descriptionUr :json['description_ur'],
    providerNameAr: json['provider_name_ar'],
    providerNameUr: json['provider_name_ur'],
    textColor : json['text_color'],
    paymentStatus : json['payment_status']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['provider_name'] = providerName;
    data['image'] = image;
    data['fixed'] = fixed;
    data['price'] = price;
    data['description'] = description;
    data['status'] = status;
    data['name_ar'] = nameAr;
    data['name_ur'] = nameUr;
    data['description_ar'] = descriptionAr;
    data['description_ur'] = descriptionUr;
    data['provider_name_ar'] = providerNameAr;
    data['provider_name_ur'] = providerNameUr;
    data['text_color'] = textColor;
    data['payment_status'] = paymentStatus;
    return data;
  }
}

class RatingModel extends RatingEntity {


  RatingModel(
      { super.id,
        super.requestId,
        super.userId,
        super.providerId,
        super.userRating,
        super.providerRating,
        super.userComment,
        super.providerComment});

 factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
    id : json['id'],
    requestId : json['request_id'],
    userId : json['user_id'],
    providerId : json['provider_id'],
    userRating : json['user_rating'],
    providerRating : json['provider_rating'],
    userComment : json['user_comment'],
    providerComment : json['provider_comment']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['request_id'] = requestId;
    data['user_id'] = userId;
    data['provider_id'] = providerId;
    data['user_rating'] = userRating;
    data['provider_rating'] = providerRating;
    data['user_comment'] = userComment;
    data['provider_comment'] = providerComment;
    return data;
  }
}
