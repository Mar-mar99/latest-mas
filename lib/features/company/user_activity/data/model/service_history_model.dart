import '../../domain/entities/service_history_entity.dart';

class ServiceHistoryModel extends ServiceHistoryEntity{

  ServiceHistoryModel(
      {
      super.requestId,
      super.providerId,
      super.name,
      super.nameAr,
      super.nameUr,
      super.serviceTextColor,
      super.scheduleAt,
      super.providerName,
      super.providerEmail,
      super.providerAvatar,
      super.providerRating,
      super.userFirstName,
      super.userLastName,
      super.finishedAt,
      super.userEmail,
      super.totalServiceTimeInSeconds,
      super.totalServiceTime,
      super.status,
      super.emergencyTimeFormat,
      super.paymentValue,
      super.emergencyHourlyRate,
      super.emergencyTimePrice,
      super.images});

 factory ServiceHistoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceHistoryModel(
    requestId : json['request_id'],
    providerId : json['provider_id'],
    name  : json['name'],
    nameAr: json['name_ar'],
    nameUr: json['name_ur'],
    serviceTextColor : json['service_text_color'],
    scheduleAt    : json['schedule_at'],
    providerName  : json['ProviderName'],
    providerEmail : json['ProviderEmail'],
    providerAvatar: json['ProviderAvatar'],
    providerRating: json['ProviderRating'],
    userFirstName : json['UserFirstName'],
    userLastName  : json['UserLastName'],
    finishedAt    : json['finished_at']??'',
    userEmail     : json['UserEmail'],
    totalServiceTimeInSeconds : json['total_service_time_in_seconds'],
    totalServiceTime: json['total_service_time'],
    status : json['status']??'SEARCHING',
    emergencyTimeFormat :json['emergency_time_format'],
    paymentValue : json['PaymentValue'] != null ? json['PaymentValue'].toString() : '',
    emergencyHourlyRate: json['emergency_hourly_rate'],
    emergencyTimePrice : json['emergency_time_price'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_id'] = requestId;
    data['provider_id'] = providerId;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['name_ur'] = nameUr;
    data['service_text_color'] = serviceTextColor;
    data['schedule_at'] = scheduleAt;
    data['ProviderName'] = providerName;
    data['ProviderEmail'] = providerEmail;
    data['ProviderAvatar'] = providerAvatar;
    data['ProviderRating'] = providerRating;
    data['UserFirstName'] = userFirstName;
    data['UserLastName'] = userLastName;
    data['finished_at'] = finishedAt;
    data['UserEmail'] = userEmail;
    data['total_service_time_in_seconds'] = totalServiceTimeInSeconds;
    data['total_service_time'] = totalServiceTime;
    data['emergency_time_format'] = emergencyTimeFormat;
    data['emergency_hourly_rate'] = emergencyHourlyRate;
    data['emergency_time_price'] = emergencyTimePrice;

    data['images'] = images;

    return data;
  }
}

