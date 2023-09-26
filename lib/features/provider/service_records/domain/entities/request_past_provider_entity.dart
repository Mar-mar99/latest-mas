import 'package:equatable/equatable.dart';

class RequestPastProviderEntity extends Equatable {
  final dynamic id;
  final dynamic? bookingId;
  final dynamic? providerId;
  final dynamic? serviceTypeId;
  final dynamic? isEmergency;
  final dynamic? emergencyTime;
  final dynamic? emergencyPercentage;
  final dynamic? afterComment;
  final dynamic? status;
  final dynamic? cancelledBy;
  final dynamic? cancelReason;
  final dynamic? paid;
  final dynamic? startedAt;
  final dynamic? finishedAt;
  final dynamic? sLatitude;
  final dynamic? sLongitude;
  final dynamic? userId;
  final dynamic? staticMap;
  final dynamic? totalServiceTimeInSeconds;
  final dynamic? totalServiceTime;
  final dynamic? emergencyTimeFormat;
  final dynamic? emergencyHourlyRate;
  final dynamic? emergencyTimePrice;
  final dynamic? paymentMode;
  final dynamic? s_address;
  final bool? isLocalCompany;
  final List<String>? images;
  final List<String>? imagesAfter;
  final PaymentEntity? payment;
  final ServiceTypeEntity? serviceType;
  final UserEntity? user;
  final RatingEntity? rating;
  final ExpertEntity? provider;

  RequestPastProviderEntity({
    this.id,
    this.bookingId,
    this.providerId,
    this.serviceTypeId,
    this.isEmergency,
    this.emergencyTime,
    this.emergencyPercentage,
    this.afterComment,
    this.status,
    this.cancelledBy,
    this.cancelReason,
    this.paid,
    this.startedAt,
    this.finishedAt,
    this.sLatitude,
    this.sLongitude,
    this.userId,
    this.staticMap,
    this.totalServiceTimeInSeconds,
    this.totalServiceTime,
    this.emergencyTimeFormat,
    this.emergencyHourlyRate,
    this.emergencyTimePrice,
    this.images,
    this.payment,
    this.serviceType,
    this.user,
    this.isLocalCompany,
    this.rating,
    this.provider,
    this.paymentMode,
    this.s_address,
    this.imagesAfter,
  });


  @override
  List<Object?> get props => [
        id,
        bookingId,
        providerId,
        serviceTypeId,
        isEmergency,
        emergencyTime,
        emergencyPercentage,
        afterComment,
        status,
        cancelledBy,
        cancelReason,
        paid,
        startedAt,
        finishedAt,
        sLatitude,
        sLongitude,
        userId,
        staticMap,
        totalServiceTimeInSeconds,
        totalServiceTime,
        emergencyTimeFormat,
        emergencyHourlyRate,
        emergencyTimePrice,
        images,
        payment,
        serviceType,
        user,
        isLocalCompany,
        rating,
        provider,
        paymentMode,
        s_address,
        imagesAfter,
      ];
}

class ServiceTypeEntity extends Equatable {
  final int? id;
  final dynamic? name;
  final dynamic? providerName;
  final dynamic? image;
  final dynamic? fixed;
  final dynamic? price;
  final dynamic? description;
  final dynamic? status;
  final dynamic? nameAr;
  final dynamic? nameUr;
  final dynamic? descriptionAr;
  final dynamic? descriptionUr;
  final dynamic? providerNameAr;
  final dynamic? providerNameUr;
  final dynamic? textColor;
  final dynamic? paymentStatus;

  ServiceTypeEntity(
      {this.id,
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

class UserEntity extends Equatable {
  final dynamic? id;
  final dynamic? firstName;
  final dynamic? lastName;
  final dynamic? paymentMode;
  final dynamic? email;
  final dynamic? picture;
  final dynamic? deviceToken;
  final dynamic? deviceId;
  final dynamic? deviceType;
  final dynamic? loginBy;
  final dynamic? socialUniqueId;
  final dynamic? mobile;
  final dynamic? latitude;
  final dynamic? longitude;
  final dynamic? stripeCustId;
  final dynamic? walletBalance;
  final dynamic? rating;
  final dynamic? ratingCount;
  final dynamic? otp;
  final dynamic? verified;

  UserEntity(
      {this.id,
      this.firstName,
      this.lastName,
      this.paymentMode,
      this.email,
      this.picture,
      this.deviceToken,
      this.deviceId,
      this.deviceType,
      this.loginBy,
      this.socialUniqueId,
      this.mobile,
      this.latitude,
      this.longitude,
      this.stripeCustId,
      this.walletBalance,
      this.rating,
      this.ratingCount,
      this.otp,
      this.verified});


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

class ExpertEntity extends Equatable {
final dynamic? id;
final dynamic? companyId;
final dynamic? firstName;
final dynamic? lastName;
final dynamic? name;
final dynamic? email;
final dynamic? phoneCode;
final dynamic? mobile;
final dynamic? avatar;
final dynamic? description;
final dynamic? rating;
final dynamic? status;
final dynamic? latitude;
final dynamic? longitude;
final dynamic? ratingCount;
final dynamic? otp;
final dynamic? verified;
final dynamic? stripeAccId;
final dynamic? isStripeinfoFilled;
final dynamic? isStripeConnected;
final dynamic? type;
final dynamic? providersCount;
final dynamic? commission;
final dynamic? local;
final dynamic? address;
final dynamic? expertActive;
final dynamic? expertOnline;

  ExpertEntity(
      {
      this.id,
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

class PaymentEntity extends Equatable {
 final dynamic id;
 final dynamic requestId;
 final dynamic promocodeId;
 final dynamic paymentMode;
 final dynamic paymentId;
 final dynamic fixed;
 final dynamic distance;
 final dynamic commisionRate;
 final dynamic commision;
 final dynamic hourlyRate;
 final dynamic timePrice;
 final dynamic discount;
 final dynamic lcdRate;
 final dynamic localCompanyDiscount;
 final dynamic tax;
 final dynamic taxRate;
 final dynamic charityRate;
 final dynamic charityValue;
 final dynamic wallet;
 final dynamic total;

  PaymentEntity(
      {
      this.id,
      this.requestId,
      this.promocodeId,
      this.paymentId,
      this.paymentMode,
      this.fixed,
      this.distance,
      this.commisionRate,
      this.commision,
      this.hourlyRate,
      this.timePrice,
      this.discount,
      this.lcdRate,
      this.localCompanyDiscount,
      this.tax,
      this.taxRate,
      this.charityRate,
      this.charityValue,
      this.wallet,
      this.total});


  @override

  List<Object?> get props =>[
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

class RatingEntity  extends Equatable{
 final dynamic id;
 final dynamic requestId;
 final dynamic userId;
 final dynamic providerId;
 final dynamic userRating;
 final dynamic providerRating;
 final dynamic userComment;
 final dynamic providerComment;

  RatingEntity(
      {this.id,
      this.requestId,
      this.userId,
      this.providerId,
      this.userRating,
      this.providerRating,
      this.userComment,
      this.providerComment});


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
