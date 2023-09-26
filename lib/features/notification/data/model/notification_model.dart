import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel(
      {super.id,
      super.requestId,
      super.userId,
      super.providerId,
      super.notification,
      super.type,
      super.readByUser,
      super.readDate});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json['id'] ?? 0,
        requestId:json['request_id']!=null ? json['request_id'] is int ? ((json['request_id'] ?? 0)): int.parse(json['request_id']) :0,
        userId: json['user_id']??0,
        providerId: int.parse((json['provider_id'] ?? 0).toString()),
        notification: json['notification'] ?? '',
        type: json['ntype'] ?? json['TYPE']?? '',
        readByUser: json['readByUser'] ?? 0,
        readDate: json['readDate'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['request_id'] = requestId;
    data['user_id'] = userId;
    data['provider_id'] = providerId;
    data['notification'] = notification;
    data['ntype'] = type;
    data['readByUser'] = readByUser;
    data['readDate'] = readDate;
    return data;
  }
}
