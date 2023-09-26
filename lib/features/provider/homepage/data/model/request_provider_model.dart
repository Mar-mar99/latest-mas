import '../../domain/entities/request_provider_entity.dart';

class RequestProviderModel extends RequestProviderEntity {
  RequestProviderModel(
      {super.id,
      super.bookingId,
      super.userId,
      super.providerId,
      super.currentProviderId,
      super.serviceTypeId,
      super.isEmergency,
      super.emergencyTime,
      super.emergencyPercentage,
      super.beforeImage,
      super.beforeComment,
      super.afterImage,
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

      super.payment,
      super.serviceType,
      super.user,
      super.rating,
      super.notes,});

  factory RequestProviderModel.fromJson(Map<String, dynamic> json) {

     List<String> imagesBefore = [];
    List<String> imagesAfter = [];
    if (json['images'] != null) {
      for (var imageData in json['images']) {
        if (imageData['image_type'] == 'Before') {
          imagesBefore.add(imageData['image']);
        } else if (imageData['image_type'] == 'After') {
          imagesAfter.add(imageData['image']);
        }
      }
    }

    return RequestProviderModel(
        id: json['id'],
        bookingId: json['booking_id'],
        userId: json['user_id'],
        providerId: json['provider_id'],
        currentProviderId: json['current_provider_id'],
        serviceTypeId: json['service_type_id'],
        isEmergency: json['IsEmergency'],
        emergencyTime: json['emergency_time'],
        emergencyPercentage: json['emergency_percentage'],
        beforeImage: imagesBefore,
        beforeComment: json['before_comment'],
        afterImage: imagesAfter,
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
        payment: json['payment']!=null? PaymentModel.fromJson(json['payment']):null,
        serviceType: json['service_type'] != null
            ? ServiceTypeModel.fromJson(json['service_type'])
            : null,
        user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
        rating: json['rating'],

        notes: json['notes']??'',

        );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['user_id'] = userId;
    data['provider_id'] = providerId;
    data['current_provider_id'] = currentProviderId;
    data['service_type_id'] = serviceTypeId;
    data['IsEmergency'] = isEmergency;
    data['emergency_time'] = emergencyTime;
    data['emergency_percentage'] = emergencyPercentage;
    data['before_image'] = beforeImage;
    data['before_comment'] = beforeComment;
    data['after_image'] = afterImage;
    data['after_comment'] = afterComment;
    data['status'] = status;
    data['cancelled_by'] = cancelledBy;
    data['cancel_time'] = cancelTime;
    data['cancel_reason'] = cancelReason;
    data['payment_mode'] = paymentMode;
    data['paid'] = paid;
    data['distance'] = distance;
    data['s_address'] = sAddress;
    data['s_latitude'] = sLatitude;
    data['s_longitude'] = sLongitude;
    data['d_address'] = dAddress;
    data['d_latitude'] = dLatitude;
    data['d_longitude'] = dLongitude;
    data['assigned_at'] = assignedAt;
    data['schedule_at'] = scheduleAt;
    data['started_at'] = startedAt;
    data['finished_at'] = finishedAt;
    data['user_rated'] = userRated;
    data['provider_rated'] = providerRated;
    data['use_wallet'] = useWallet;
    data['reminder'] = reminder;
    data['push_count'] = pushCount;
    data['promocode_id'] = promocodeId;
    data['static_map'] = staticMap;
    data['currency'] = currency;
    data['total_service_time_in_seconds'] = totalServiceTimeInSeconds;
    data['total_service_time'] = totalServiceTime;
    data['emergency_time_format'] = emergencyTimeFormat;
    data['emergency_hourly_rate'] = emergencyHourlyRate;
    data['emergency_time_price'] = emergencyTimePrice;

    data['payment'] = payment;
    if (serviceType != null) {
      data['service_type'] = (serviceType as ServiceTypeModel).toJson();
    }
    if (user != null) {
      data['user'] = (user as UserModel).toJson();
    }
    data['rating'] = rating;
    return data;
  }
}

class ServiceTypeModel extends ServiceTypeEntity {
  ServiceTypeModel(
      {super.id,
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
      id: json['id'],
      name: json['name'],
      providerName: json['provider_name'],
      image: json['image'],
      fixed: json['fixed'],
      price: json['price'],
      description: json['description'],
      status: json['status'],
      nameAr: json['name_ar'],
      nameUr: json['name_ur'],
      descriptionAr: json['description_ar'],
      descriptionUr: json['description_ur'],
      providerNameAr: json['provider_name_ar'],
      providerNameUr: json['provider_name_ur'],
      textColor: json['text_color'],
      paymentStatus: json['payment_status'],
    );
  }

  @override
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

class UserModel extends UserEntity {
  UserModel(
      {super.id,
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
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      paymentMode: json['payment_mode'],
      email: json['email'],
      picture: json['picture'],
      deviceToken: json['device_token'],
      deviceId: json['device_id'],
      deviceType: json['device_type'],
      loginBy: json['login_by'],
      socialUniqueId: json['social_unique_id'],
      mobile: json['mobile'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      stripeCustId: json['stripe_cust_id'],
      walletBalance: json['wallet_balance'],
      rating: json['rating'],
      ratingCount: json['rating_count'],
      otp: json['otp'],
      verified: json['verified'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['payment_mode'] = paymentMode;
    data['email'] = email;
    data['picture'] = picture;
    data['device_token'] = deviceToken;
    data['device_id'] = deviceId;
    data['device_type'] = deviceType;
    data['login_by'] = loginBy;
    data['social_unique_id'] = socialUniqueId;
    data['mobile'] = mobile;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['stripe_cust_id'] = stripeCustId;
    data['wallet_balance'] = walletBalance;
    data['rating'] = rating;
    data['rating_count'] = ratingCount;
    data['otp'] = otp;
    data['verified'] = verified;
    return data;
  }
}

class PaymentModel extends PaymentEntity {
  PaymentModel(
      {super.id,
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
        id: json['id'],
        requestId: json['request_id'],
        promocodeId: json['promocode_id'].toString(),
        paymentId: json['payment_id'],
        paymentMode: json['payment_mode'],
        fixed: json['fixed'],
        distance: json['distance'],
        commisionRate: json['commision_rate'],
        commision: json['commision'],
        hourlyRate: json['hourly_rate'],
        timePrice: json['time_price'],
        discount: json['discount'],
        lcdRate: json['lcd_rate'],
        localCompanyDiscount: json['local_company_discount'],
        tax: json['tax'],
        taxRate: json['tax_rate'],
        charityRate: json['charity_rate'],
        charityValue: json['charity_value'],
        wallet: json['wallet'],
        total: json['total']);
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
