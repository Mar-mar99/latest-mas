import 'package:equatable/equatable.dart';

import '../../domain/entities/requets_detail_entity.dart';

class RequestDetailModel extends RequestDetailEntity {

  RequestDetailModel({
    super.id,
    super.bookingId,
    super.userId,
    super.providerId,
    super.currentProviderId,
    super.serviceTypeId,
    super.isEmergency,
    super.emergencyTime,
    super.emergencyPercentage,
    super.beforeComment,
    super.afterComment,
    super.status,
    super.cancelledBy,
    super.cancelTime,
    super.cancelReason,
    super.paymentMode,
    super.paid,
    super.distance,
    super.sAddress,
    super.sLatitude,
    super.sLongitude,
    super.dAddress,
    super.dLatitude,
    super.dLongitude,
    super.assignedAt,
    super.scheduleAt,
    super.startedAt,
    super.finishedAt,
    super.userRated,
    super.providerRated,
    super.useWallet,
    super.reminder,
    super.pushCount,
    super.promocodeId,
    super.staticMap,
    super.currency,
    super.totalServiceTimeInSeconds,
    super.totalServiceTime,
    super.emergencyTimeFormat,
    super.emergencyHourlyRate,
    super.emergencyTimePrice,
    super.imagesBefore,
    super.imagesAfter,
    super.payment,
    super.provider,
    super.rating,
    super.serviceType,
    super.user,
  });

  factory RequestDetailModel.fromJson(Map<String, dynamic> json) {
    List<String> imagesBefore = [];
    List<String> imagesAfter = [];
    if (json['images'] != null) {
      imagesBefore = [];
      imagesAfter = [];
      json['images'].forEach((v) {
        if (v['image_type'] == 'Before') {
          imagesBefore.add(v['image']);
        } else if (v['image_type'] == 'After') {
          imagesAfter.add(v['image']);
        }
      });
    } else {
      imagesBefore = [];
      imagesAfter = [];
    }

    return RequestDetailModel(
        id: json['id'],
        bookingId: json['booking_id'],
        userId: json['user_id'],
        providerId: json['provider_id'],
        currentProviderId: json['current_provider_id'],
        serviceTypeId: json['service_type_id'],
        isEmergency: json['IsEmergency'],
        emergencyTime: json['emergency_time'],
        emergencyPercentage: json['emergency_percentage'],
        beforeComment: json['before_comment'],
        afterComment: json['after_comment'],
        status: json['status'],
        cancelledBy: json['cancelled_by'],
        cancelTime: json['cancel_time'],
        cancelReason: json['cancel_reason'],
        paymentMode: json['payment_mode'],
        paid: json['paid'],
        distance: json['distance'],
        sAddress: json['s_address'],
        sLatitude: json['s_latitude'],
        sLongitude: json['s_longitude'],
        dAddress: json['d_address'],
        dLatitude: json['d_latitude'],
        dLongitude: json['d_longitude'],
        assignedAt: json['assigned_at'],
        scheduleAt: json['schedule_at'],
        startedAt: json['started_at'],
        finishedAt: json['finished_at'],
        userRated: json['user_rated'],
        providerRated: json['provider_rated'],
        useWallet: json['use_wallet'],
        reminder: json['reminder'],
        pushCount: json['push_count'],
        promocodeId: json['promocode_id'].toString(),
        staticMap: json['static_map'],
        currency: json['currency'],
        totalServiceTimeInSeconds: json['total_service_time_in_seconds'],
        totalServiceTime: json['total_service_time'],
        emergencyTimeFormat: json['emergency_time_format'],
        emergencyHourlyRate: json['emergency_hourly_rate'],
        emergencyTimePrice: json['emergency_time_price'],
        imagesAfter: imagesAfter,
        imagesBefore: imagesBefore,
        payment:
            json['payment'] != null ? PaymentModel.fromJson(json['payment']) : null,
        serviceType: json['service_type'] != null
            ? ServiceTypeModel.fromJson(json['service_type'])
            : null,
        user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
        rating: json['rating'] != null ? RatingModel.fromJson(json['rating']) : null,
        provider: json['provider'] != null
            ? ProviderModel.fromJson(json['provider'])
            : null);
  }



}

class PaymentModel extends PaymentEntity {

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
    requestId   : json['request_id'],
    promocodeId : json['promocode_id'].toString(),
    paymentId   : json['payment_id'],
    paymentMode : json['payment_mode'],
    fixed : json['fixed'],
    distance : json['distance'],
    commisionRate : json['commision_rate'],
    commision  : json['commision'],
    hourlyRate : json['hourly_rate'],
    timePrice  : json['time_price'],
    discount   : json['discount'],
    lcdRate    : json['lcd_rate'],
    localCompanyDiscount : json['local_company_discount'],
    tax : json['tax'],
    taxRate : json['tax_rate'],
    charityRate  : json['charity_rate'],
    charityValue : json['charity_value'],
    wallet: json['wallet'],
    total : json['total'],
    );
  }

  @override

  List<Object?> get props => [
      id,
      requestId,
      promocodeId,
      paymentId,
      paymentMode,
      fixed,
      distance,
      commisionRate,
      commision,
      hourlyRate,
      timePrice,
      discount,
      lcdRate,
      localCompanyDiscount,
      tax,
      taxRate,
      charityRate,
      charityValue,
      wallet,
      total
  ];
}

class ServiceTypeModel extends ServiceTypeEntity {

  ServiceTypeModel(
      {
      super.id,
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

 factory ServiceTypeModel.fromJson(Map<String, dynamic> json) {
  return ServiceTypeModel(
    id   : json['id'],
    name : json['name'],
    providerName : json['provider_name'],
    image : json['image'],
    fixed : json['fixed'],
    price : json['price'],
    description : json['description'],
    status : json['status'],
    nameAr : json['name_ar'],
    nameUr : json['name_ur'],
    descriptionAr  : json['description_ar'],
    descriptionUr  : json['description_ur'],
    providerNameAr : json['provider_name_ar'],
    providerNameUr : json['provider_name_ur'],
    textColor : json['text_color'],
    paymentStatus : json['payment_status'],
  );
  }

  @override

  List<Object?> get props => [
     id,
     name,
     providerName,
     image,
     fixed,
     price,
     description,
     status,
     nameAr,
     nameUr,
     descriptionAr,
     descriptionUr,
     providerNameAr,
     providerNameUr,
     textColor,
     paymentStatus
  ];
}

class UserModel extends UserEntity {
  UserModel(
      {
      super.id,
      super.firstName,
      super.lastName,
      super.paymentMode,
      super.email,
      super.picture,
      super.deviceToken,
      super.deviceId,
      super.deviceType,
      super.loginBy,
      super.socialUniqueId,
      super.mobile,
      super.latitude,
      super.longitude,
      super.stripeCustId,
      super.walletBalance,
      super.rating,
      super.ratingCount,
      super.otp,
      super.verified});

 factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
      id : json['id'],
    firstName : json['first_name'],
    lastName  : json['last_name'],
    paymentMode : json['payment_mode'],
    email : json['email'],
    picture : json['picture'],
    deviceToken : json['device_token'],
    deviceId   : json['device_id'],
    deviceType : json['device_type'],
    loginBy : json['login_by'],
    socialUniqueId : json['social_unique_id'],
    mobile    : json['mobile'],
    latitude  : json['latitude'],
    longitude : json['longitude'],
    stripeCustId  : json['stripe_cust_id'],
    walletBalance : json['wallet_balance'],
    rating : json['rating'],
    ratingCount : json['rating_count'],
    otp : json['otp'],
    verified : json['verified'],
  );
  }


  @override

  List<Object?> get props => [
      id,
      firstName,
      lastName,
      paymentMode,
      email,
      picture,
      deviceToken,
      deviceId,
      deviceType,
      loginBy,
      socialUniqueId,
      mobile,
      latitude,
      longitude,
      stripeCustId,
      walletBalance,
      rating,
      ratingCount,
      otp,
      verified
  ];
}

class RatingModel extends RatingEntity {

  RatingModel(
      {
      super.id,
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
    requestId  : json['request_id'],
    userId     : json['user_id'],
    providerId : json['provider_id'],
    userRating : json['user_rating'],
    providerRating  : json['provider_rating'],
    userComment     : json['user_comment'],
    providerComment : json['provider_comment'],
  );
  }

  @override

  List<Object?> get props => [
      id,
      requestId,
      userId,
      providerId,
      userRating,
      providerRating,
      userComment,
      providerComment
  ];


}

class ProviderModel extends ProviderEntity {

  ProviderModel(
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

 factory ProviderModel.fromJson(Map<String, dynamic> json) {
  return ProviderModel(
    id : json['id'],
    companyId : json['company_id'],
    firstName : json['first_name'],
    lastName  : json['last_name'],
    name  : json['name'],
    email : json['email'],
    phoneCode : json['phone_code'],
    mobile    : json['mobile'],
    avatar    : json['avatar'],
    description : json['description'],
    rating    : json['rating'],
    status    : json['status'],
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
