// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class RequestDetailsEntity extends Equatable {
 final int? id;
 final String? bookingId;
 final int? userId;
 final int? providerId;
 final int? currentProviderId;
 final int? serviceTypeId;
 final int? isEmergency;
 final dynamic emergencyTime;
 final dynamic emergencyPercentage;
 final dynamic beforeImage;
 final dynamic beforeComment;
 final dynamic afterImage;
 final String? afterComment;
 final String? status;
 final String? cancelledBy;
 final dynamic cancelTime;
 final dynamic cancelReason;
 final String? paymentMode;
 final int? paid;
 final dynamic? distance;
 final String? sAddress;
 final double? sLatitude;
 final double? sLongitude;
 final dynamic dAddress;
 final dynamic dLatitude;
 final dynamic dLongitude;
 final String? assignedAt;
 final dynamic scheduleAt;
 final String? startedAt;
 final String? finishedAt;
 final dynamic? userRated;
 final dynamic? providerRated;
 final dynamic? useWallet;
 final dynamic? reminder;
 final dynamic? pushCount;
 final dynamic promocodeId;
 final String? staticMap;
 final dynamic? totalServiceTimeInSeconds;
 final String? totalServiceTime;
 final String? emergencyTimeFormat;
 final dynamic emergencyHourlyRate;
 final dynamic? emergencyTimePrice;
 final List<dynamic>? images;
 final PaymentEntity? payment;
 final ServiceTypeEntity? serviceType;
 final ExpertEntity? provider;
 final dynamic rating;
 final UserEntity? user;
final String? cancelationFees;
final String notes;
  RequestDetailsEntity({
    this.id,
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
    this.payment,
    this.serviceType,
    this.provider,
    this.rating,
    this.user,
    this.cancelationFees,
    this.notes='',
  });

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
    payment,
    serviceType,
    provider,
    rating,
    cancelationFees,
    notes
  ];
}

class PaymentEntity extends Equatable{
 final int? id;
 final int? requestId;
 final dynamic promocodeId; /// if not null then we have promo
 final dynamic paymentId;
 final dynamic paymentMode; ///ok
 final dynamic? fixed; ///ok base price
 final dynamic? distance;
 final dynamic? commisionRate;
 final dynamic? commision;
 final dynamic? hourlyRate; ///ok
 final dynamic? timePrice;
 final dynamic? discount; ///ok
 final dynamic? lcdRate;
 final dynamic? localCompanyDiscount;
 final dynamic? tax;///ok
 final dynamic? taxRate;
 final dynamic? charityRate;
 final dynamic? charityValue;
 final dynamic? wallet;
 final dynamic? total; ///ok

  PaymentEntity(
      {this.id,
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

class ServiceTypeEntity extends Equatable {
 final int? id;
 final String? name;
 final String? providerName;
 final String? image;
 final int? fixed;
 final int? price;
 final dynamic description;
 final int? status;
 final String? nameAr;
 final String? nameUr;
 final dynamic descriptionAr;
 final dynamic descriptionUr;
 final dynamic providerNameAr;
 final dynamic providerNameUr;
 final String? textColor;
 final String? paymentStatus;

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

class ExpertEntity extends Equatable{
 final int? id;
 final int? companyId;
 final String? firstName;
 final String? lastName;
 final String? name;
 final String? email;
 final dynamic phoneCode;
 final String? mobile;
 final String? avatar;
 final dynamic description;
 final String? rating;
 final String? status;
 final double? latitude;
 final double? longitude;
 final int? ratingCount;
 final int? otp;
 final int? verified;
 final dynamic stripeAccId;
 final int? isStripeinfoFilled;
 final int? isStripeConnected;
 final String? type;
 final dynamic providersCount;
 final dynamic commission;
 final dynamic local;
 final dynamic address;
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

class UserEntity extends Equatable {
 final int? id;
 final String? firstName;
 final String? lastName;
 final String? paymentMode;
 final String? email;
 final String? picture;
 final String? deviceToken;
 final String? deviceId;
 final String? deviceType;
 final String? loginBy;
 final dynamic socialUniqueId;
 final String? mobile;
 final dynamic latitude;
 final dynamic longitude;
 final String? stripeCustId;
 final dynamic? walletBalance;
 final String? rating;
 final int? ratingCount;
 final int? otp;
 final int? verified;

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
