// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class RequestProviderEntity extends Equatable {
  final int? id;
  final String? bookingId;
  final int? userId;
  final int? providerId;
  final int? currentProviderId;
  final int? serviceTypeId;
  final int? isEmergency;
  final String? emergencyTime;
  final String? emergencyPercentage;
  final List<String>? beforeImage;
  final String? beforeComment;
  final List<String>? afterImage;
  final String? afterComment;
  final String? status;
  final String? cancelledBy;
  final String? cancelTime;
  final String? cancelReason;
  final String? paymentMode;
  final int? paid;
  final int? distance;
  final String? sAddress;
  final double? sLatitude;
  final double? sLongitude;
  final String? dAddress;
  final int? dLatitude;
  final int? dLongitude;
  final String? assignedAt;
  final String? scheduleAt;
  final String? startedAt;
  final String? finishedAt;
  final int? userRated;
  final int? providerRated;
  final int? useWallet;
  final int? reminder;
  final int? pushCount;
  final String? promocodeId;
  final String? staticMap;
  final String? currency;
  final int? totalServiceTimeInSeconds;
  final String? totalServiceTime;
  final String? emergencyTimeFormat;
  final String? emergencyHourlyRate;
  final int? emergencyTimePrice;

  final PaymentEntity? payment;
  final ServiceTypeEntity? serviceType;
  final UserEntity? user;
  final String? rating;
  final String? notes;

  RequestProviderEntity({
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
    this.currency,
    this.totalServiceTimeInSeconds,
    this.totalServiceTime,
    this.emergencyTimeFormat,
    this.emergencyHourlyRate,
    this.emergencyTimePrice,

    this.payment,
    this.serviceType,
    this.user,
    this.rating,
    this.notes,
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
        currency,
        totalServiceTimeInSeconds,
        totalServiceTime,
        emergencyTimeFormat,
        emergencyHourlyRate,
        emergencyTimePrice,

        payment,
        serviceType,
        user,
        rating,
        notes
      ];
}

class ServiceTypeEntity extends Equatable {
  final int? id;
  final String? name;
  final String? providerName;
  final String? image;
  final int? fixed;
  final int? price;
  final String? description;
  final int? status;
  final String? nameAr;
  final String? nameUr;
  final String? descriptionAr;
  final String? descriptionUr;
  final String? providerNameAr;
  final String? providerNameUr;
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

class UserEntity extends Equatable {
  final dynamic? id;
  final String? firstName;
  final String? lastName;
  final String? paymentMode;
  final String? email;
  final String? picture;
  final String? deviceToken;
  final String? deviceId;
  final String? deviceType;
  final String? loginBy;
  final String? socialUniqueId;
  final String? mobile;
  final String? latitude;
  final String? longitude;
  final String? stripeCustId;
  final dynamic? walletBalance;
  final String? rating;
  final dynamic? ratingCount;
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

