import 'package:equatable/equatable.dart';

class HistoryRequestUserEntity extends Equatable{
final dynamic id;
final dynamic bookingId;
final dynamic providerId;
final dynamic isEmergency;
final dynamic emergencyTime;
final dynamic emergencyPercentage;
final String? afterComment;
final String? status;
final String? cancelledBy;
final dynamic cancelReason;
final dynamic paid;
final String? startedAt;
final String? finishedAt;
final dynamic sLatitude;
final dynamic sLongitude;
final String? staticMap;
final dynamic totalServiceTimeInSeconds;
final String? totalServiceTime;
final String? emergencyTimeFormat;
final dynamic emergencyHourlyRate;
final dynamic emergencyTimePrice;
final dynamic payment_mode;
final dynamic s_address;
final List<String>? images;
final List<String>? imagesAfter;
final PaymentEntity? payment;
final ServiceTypeEntity? serviceType;
final RatingEntity? rating;
final ExpertEntity? provider;

  HistoryRequestUserEntity(
      {this.id,
        this.bookingId,
        this.providerId,
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
        this.staticMap,
        this.totalServiceTimeInSeconds,
        this.totalServiceTime,
        this.emergencyTimeFormat,
        this.emergencyHourlyRate,
        this.emergencyTimePrice,
        this.payment_mode,
        this.s_address,
        this.images,
        this.payment,
        this.imagesAfter,
        this.serviceType,
        this.rating,
        this.provider});

          @override

          List<Object?> get props => [
        id,
        bookingId,
        providerId,
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
        staticMap,
        totalServiceTimeInSeconds,
        totalServiceTime,
        emergencyTimeFormat,
        emergencyHourlyRate,
        emergencyTimePrice,
        payment_mode,
        s_address,
        images,
        payment,
        imagesAfter,
        serviceType,
        rating,
        provider
          ];
}

class PaymentEntity extends Equatable{
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

class ExpertEntity extends Equatable {
final  int? id;
final  int? companyId;
final  String? firstName;
final  String? lastName;
final  String? name;
final  String? email;
final  dynamic phoneCode;
final  String? mobile;
final  String? avatar;
final  dynamic description;
final  String? rating;
final  String? status;
final  dynamic latitude;
final  dynamic longitude;
final dynamic ratingCount;
final dynamic otp;
final dynamic verified;
final dynamic stripeAccId;
final dynamic isStripeinfoFilled;
final dynamic isStripeConnected;
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
expertOnline,
          ];


}

class ServiceTypeEntity extends Equatable {
final int? id;
final String? name;
final String? providerName;
final String? image;
final dynamic fixed;
final dynamic price;
final dynamic description;
final dynamic status;
final dynamic nameAr;
final dynamic nameUr;
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
 paymentStatus,
          ];

}

class RatingEntity extends Equatable{
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
  providerComment,
          ];

}
