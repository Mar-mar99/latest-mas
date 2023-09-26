import 'package:equatable/equatable.dart';

class UpcomingRequestUserEntity extends Equatable {
  final dynamic? id;
  final String? bookingId;
  final dynamic? userId;
  final dynamic? providerId;
  final dynamic? currentProviderId;
  final dynamic? serviceTypeId;
  final dynamic? isEmergency;
  final dynamic? emergencyTime;
  final dynamic? emergencyPercentage;
  final dynamic? beforeImage;
  final dynamic? beforeComment;
  final dynamic? afterImage;
  final dynamic? afterComment;
  final String? status;
  final String? cancelledBy;
  final dynamic? cancelTime;
  final dynamic? cancelReason;
  final String? paymentMode;
  final dynamic? paid;
  final dynamic? distance;
  final String? sAddress;
  final double? sLatitude;
  final double? sLongitude;
  final dynamic? dAddress;
  final dynamic? dLatitude;
  final dynamic? dLongitude;
  final String? assignedAt;
  final String? scheduleAt;
  final dynamic? startedAt;
  final dynamic? finishedAt;
  final dynamic? userRated;
  final dynamic? providerRated;
  final dynamic? useWallet;
  final dynamic? reminder;
  final dynamic? pushCount;
  final String? promocodeId;
  final String? staticMap;
  final dynamic? totalServiceTimeInSeconds;
  final String? totalServiceTime;
  final String? emergencyTimeFormat;
  final dynamic? emergencyHourlyRate;
  final dynamic? emergencyTimePrice;
  final List<String>? images;
  final List<String>? imagesAfter;
  final ServiceTypeEntity? serviceType;
  final ExpertEntity? provider;

  UpcomingRequestUserEntity(
      {this.id,
      this.bookingId,
      this.userId,
      this.providerId,
      this.currentProviderId,
      this.serviceTypeId,
      this.isEmergency,
      this.emergencyTime,
      this.emergencyPercentage,
      this.beforeImage,
      this.beforeComment,
      this.afterImage,
      this.afterComment,
      this.status,
      this.cancelledBy,
      this.cancelTime,
      this.cancelReason,
      this.paymentMode,
      this.paid,
      this.distance,
      this.sAddress,
      this.sLatitude,
      this.sLongitude,
      this.dAddress,
      this.dLatitude,
      this.dLongitude,
      this.assignedAt,
      this.scheduleAt,
      this.startedAt,
      this.finishedAt,
      this.userRated,
      this.providerRated,
      this.useWallet,
      this.reminder,
      this.pushCount,
      this.promocodeId,
      this.staticMap,
      this.totalServiceTimeInSeconds,
      this.totalServiceTime,
      this.emergencyTimeFormat,
      this.emergencyHourlyRate,
      this.emergencyTimePrice,
      this.images,
      this.imagesAfter,
      this.serviceType,
      this.provider});

  @override
  List<Object?> get props => [
        id,
        bookingId,
        userId,
        providerId,
        currentProviderId,
        serviceTypeId,
        isEmergency,
        emergencyTime,
        emergencyPercentage,
        beforeImage,
        beforeComment,
        afterImage,
        afterComment,
        status,
        cancelledBy,
        cancelTime,
        cancelReason,
        paymentMode,
        paid,
        distance,
        sAddress,
        sLatitude,
        sLongitude,
        dAddress,
        dLatitude,
        dLongitude,
        assignedAt,
        scheduleAt,
        startedAt,
        finishedAt,
        userRated,
        providerRated,
        useWallet,
        reminder,
        pushCount,
        promocodeId,
        staticMap,
        totalServiceTimeInSeconds,
        totalServiceTime,
        emergencyTimeFormat,
        emergencyHourlyRate,
        emergencyTimePrice,
        images,
        imagesAfter,
        serviceType,
        provider,
      ];
}

class ServiceTypeEntity extends Equatable{
  final dynamic? id;
  final String? name;
  final String? providerName;
  final String? image;
  final dynamic? fixed;
  final dynamic? price;
  final dynamic? description;
  final dynamic? status;
  final String? nameAr;
  final String? nameUr;
  final dynamic? descriptionAr;
  final dynamic? descriptionUr;
  final dynamic? providerNameAr;
  final dynamic? providerNameUr;
  final String? textColor;
  final String? paymentStatus;

  ServiceTypeEntity(
      {
      this.id,
      this.name,
      this.providerName,
      this.image,
      this.fixed,
      this.price,
      this.description,
      this.status,
      this.nameAr,
      this.nameUr,
      this.descriptionAr,
      this.descriptionUr,
      this.providerNameAr,
      this.providerNameUr,
      this.textColor,
      this.paymentStatus});

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

class ExpertEntity extends Equatable{
  final dynamic? id;
  final dynamic? companyId;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String? email;
  final dynamic? phoneCode;
  final String? mobile;
  final String? avatar;
  final dynamic? description;
  final String? rating;
  final String? status;
  final double? latitude;
  final double? longitude;
  final dynamic? ratingCount;
  final dynamic? otp;
  final dynamic? verified;
  final dynamic? stripeAccId;
  final dynamic? isStripeinfoFilled;
  final dynamic? isStripeConnected;
  final String? type;
  final dynamic? providersCount;
  final dynamic? commission;
  final dynamic? local;
  final dynamic? address;
  final String? expertActive;
  final String? expertOnline;

  ExpertEntity(
      {this.id,
      this.companyId,
      this.firstName,
      this.lastName,
      this.name,
      this.email,
      this.phoneCode,
      this.mobile,
      this.avatar,
      this.description,
      this.rating,
      this.status,
      this.latitude,
      this.longitude,
      this.ratingCount,
      this.otp,
      this.verified,
      this.stripeAccId,
      this.isStripeinfoFilled,
      this.isStripeConnected,
      this.type,
      this.providersCount,
      this.commission,
      this.local,
      this.address,
      this.expertActive,
      this.expertOnline});

        @override

        List<Object?> get props => [
      id,
      companyId,
      firstName,
      lastName,
      name,
      email,
      phoneCode,
      mobile,
      avatar,
      description,
      rating,
      status,
      latitude,
      longitude,
      ratingCount,
      otp,
      verified,
      stripeAccId,
      isStripeinfoFilled,
      isStripeConnected,
      type,
      providersCount,
      commission,
      local,
      address,
      expertActive,
      expertOnline
        ];
}
