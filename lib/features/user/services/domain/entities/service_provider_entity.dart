import 'package:equatable/equatable.dart';

class ServiceProviderEntity extends Equatable {
  final num distance;
  final int id;
  final int companyId;
  final String firstName;
  final String lastName;
  final String name;
  final String email;
  final String phoneCode;
  final String mobile;
  final String avatar;
  final String description;
  final String rating;
  final String status;
  final double latitude;
  final double longitude;
  final int ratingCount;
  final int otp;
  final int verified;
  final dynamic stripeAccId;
  final int isStripeinfoFilled;
  final int isStripeConnected;
  final String type;
  final int providersCount;
  final dynamic commission;
  final dynamic local;
  final String address;
  final String expertActive;
  final String expertOnline;
  final int isBusy;
  final int hideFormList;
  final int stateId;
  final String fixedPrice;
  final String hourlyPrice;
  final int completedRequests;
  final List<Attrs> attrs;
  final bool isFavourite;
  final bool isNew;
  final String cancelationFees;

  ServiceProviderEntity(
      {
     required this.distance,
     required this.id,
     required this.companyId,
     required this.firstName,
     required this.lastName,
     required this.name,
     required this.email,
     required this.phoneCode,
     required this.mobile,
     required this.avatar,
     required this.description,
     required this.rating,
     required this.status,
     required this.latitude,
     required this.longitude,
     required this.ratingCount,
     required this.otp,
     required this.verified,
     required this.stripeAccId,
     required this.isStripeinfoFilled,
     required this.isStripeConnected,
     required this.type,
     required this.providersCount,
     required this.commission,
     required this.local,
     required this.address,
     required this.expertActive,
     required this.expertOnline,
     required this.isBusy,
     required this.hideFormList,
     required this.stateId,
     required this.fixedPrice,
     required this.hourlyPrice,
     required this.completedRequests,
     required this.attrs,
     required this.isFavourite,
     required this.isNew,
     required this.cancelationFees,
     });

  @override
  List<Object?> get props => [
        distance,
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
        isBusy,
        hideFormList,
        stateId,
        fixedPrice,
        hourlyPrice,
        completedRequests,
        attrs,
        isFavourite,
        isNew,
        cancelationFees
      ];
}

class Attrs {
  final String name;
  final String value;

  Attrs({required this.name, required this.value});

}
