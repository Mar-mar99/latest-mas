import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
 final int? id;
 final dynamic? requestId;
 final int? userId;
 final int? providerId;
 final String? notification;
 final String? type;
 final int? readByUser;
 final String? readDate;

  const NotificationEntity(
      {this.id,
      this.requestId,
      this.userId,
      this.providerId,
      this.notification,
      this.type,
      this.readByUser,
      this.readDate});

  @override
  List<Object?> get props => [
        id,
        requestId,
        userId,
        providerId,
        notification,
        type,
        readByUser,
        readDate,
      ];
}
