import 'package:equatable/equatable.dart';

class ServiceHistoryEntity extends Equatable{
 final int? requestId;
 final int? providerId;
 final String? name;
 final String? nameAr;
 final String? nameUr;
 final String? serviceTextColor;
 final String? scheduleAt;
 final String? providerName;
 final String? providerEmail;
 final String? providerAvatar;
 final String? providerRating;
 final String? userFirstName;
 final String? userLastName;
 final String? finishedAt;
 final String? userEmail;
 final int? totalServiceTimeInSeconds;
 final String? totalServiceTime;
 final String? status;
 final String? emergencyTimeFormat;
 final String? paymentValue;
 final dynamic emergencyHourlyRate;
 final int? emergencyTimePrice;
 final List<String>? images;

  ServiceHistoryEntity(
      {this.requestId,
      this.providerId,
      this.name,
      this.nameAr,
      this.nameUr,
      this.serviceTextColor,
      this.scheduleAt,
      this.providerName,
      this.providerEmail,
      this.providerAvatar,
      this.providerRating,
      this.userFirstName,
      this.userLastName,
      this.finishedAt,
      this.userEmail,
      this.totalServiceTimeInSeconds,
      this.totalServiceTime,
      this.status,
      this.emergencyTimeFormat,
      this.paymentValue,
      this.emergencyHourlyRate,
      this.emergencyTimePrice,
      this.images});

        @override

        List<Object?> get props => [
      requestId,
      providerId,
      name,
      nameAr,
      nameUr,
      serviceTextColor,
      scheduleAt,
      providerName,
      providerEmail,
      providerAvatar,
      providerRating,
      userFirstName,
      userLastName,
      finishedAt,
      userEmail,
      totalServiceTimeInSeconds,
      totalServiceTime,
      status,
      emergencyTimeFormat,
      paymentValue,
      emergencyHourlyRate,
      emergencyTimePrice,
      images
        ];


}
