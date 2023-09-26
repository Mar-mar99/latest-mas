import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel(
      {super.id,
      super.requestId,
      super.userId,
      super.providerId,
      super.userRating,
      super.providerRating,
      super.userComment,
      super.providerComment,
      super.user});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
        id: json['id'],
        requestId: json['request_id'],
        userId: json['user_id'],
        providerId: json['provider_id'],
        userRating: json['user_rating'],
        providerRating: json['provider_rating'],
        userComment: json['user_comment'],
        providerComment: json['provider_comment'],
        user: json['user'] != null ? UserModel.fromJson(json['user']) : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['request_id'] = requestId;
    data['user_id'] = userId;
    data['provider_id'] = providerId;
    data['user_rating'] = userRating;
    data['provider_rating'] = providerRating;
    data['user_comment'] = userComment;
    data['provider_comment'] = providerComment;
    if (user != null) {
      data['user'] = (user as UserModel).toJson();
    }
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
      walletBalance: double.parse((json['wallet_balance'] ?? 0).toString()),
      rating: json['rating'],
      ratingCount: json['rating_count'],
      otp: (json['otp'] ?? '').toString(),
      verified: json['verified'],
    );
  }

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
