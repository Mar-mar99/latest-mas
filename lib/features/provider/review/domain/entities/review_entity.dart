import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable{
final  int? id;
final  int? requestId;
final  int? userId;
final  int? providerId;
final  int? userRating;
final  int? providerRating;
final  String? userComment;
final  String? providerComment;
final  UserEntity? user;

  ReviewEntity(
      { this.id,
        this.requestId,
        this.userId,
        this.providerId,
        this.userRating,
        this.providerRating,
        this.userComment,
        this.providerComment,
        this.user});



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
        user
  ];
}

class UserEntity extends Equatable{
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
 final String? socialUniqueId;
 final String? mobile;
 final double? latitude;
 final double? longitude;
 final String? stripeCustId;
 final double? walletBalance;
 final String? rating;
 final int? ratingCount;
 final String? otp;
 final int? verified;

  UserEntity(
      { this.id,
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
