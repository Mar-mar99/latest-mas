import '../../domain/entities/offline_request_entity.dart';

class OfflineRequestModel extends OfflineRequestEntity {
  OfflineRequestModel(
      {super.id,
      super.bookingId,
      super.userId,
      super.providerId,
      super.currentProviderId,
      super.serviceTypeId,
      super.isEmergency,
      super.emergencyTime,
      super.emergencyPercentage,
      super.beforeImage,
      super.beforeComment,
      super.afterImage,
      super.afterComment,
      super.status,
      super.cancelledBy,
      super.cancelTime,
      super.cancelReason,
      super.paymentMode,
      super.paid,
      super.distance,
      super.sAddress,
      super.sLatitude,
      super.sLongitude,
      super.dAddress,
      super.dLatitude,
      super.dLongitude,
      super.assignedAt,
      super.scheduleAt,
      super.startedAt,
      super.finishedAt,
      super.userRated,
      super.providerRated,
      super.useWallet,
      super.reminder,
      super.pushCount,
      super.promocodeId,
      super.notes,
      super.attributez,
      super.stateId,
      super.statusBeforeAccept,
      super.serviceName,
      super.acceptenceRole});

  factory OfflineRequestModel.fromJson(Map<String, dynamic> json) {
      List<String> imagesBefore = [];
    List<String> imagesAfter = [];
   if (json['images'] != null) {
      for (var imageData in json['images']) {
        if (imageData['image_type'] == 'Before') {
          imagesBefore.add(imageData['image']);
        } else if (imageData['image_type'] == 'After') {
          imagesAfter.add(imageData['image']);
        }
      }
    }
    return OfflineRequestModel(
      id: json['id'],
      bookingId: json['booking_id'],
      userId: json['user_id'],
      providerId: json['provider_id'],
      currentProviderId: json['current_provider_id'],
      serviceTypeId: json['service_type_id'],
      isEmergency: json['IsEmergency'],
      emergencyTime: json['emergency_time'],
      emergencyPercentage: json['emergency_percentage'],
      beforeImage: imagesBefore,
      beforeComment: json['before_comment'],
      afterImage: imagesAfter,
      afterComment: json['after_comment'],
      status: json['status'],
      cancelledBy: json['cancelled_by'],
      cancelTime: json['cancel_time'],
      cancelReason: json['cancel_reason'],
      paymentMode: json['payment_mode'],
      paid: json['paid'],
      distance: json['distance'],
      sAddress: json['s_address'],
      sLatitude: json['s_latitude'],
      sLongitude: json['s_longitude'],
      dAddress: json['d_address'],
      dLatitude: json['d_latitude'],
      dLongitude: json['d_longitude'],
      assignedAt: json['assigned_at'],
      scheduleAt: json['schedule_at'],
      startedAt: json['started_at'],
      finishedAt: json['finished_at'],
      userRated: json['user_rated'],
      providerRated: json['provider_rated'],
      useWallet: json['use_wallet'],
      reminder: json['reminder'],
      pushCount: json['push_count'],
      promocodeId: json['promocode_id'],
      notes: json['notes'],
      attributez: json['attributez'],
      stateId: json['state_id'],
      statusBeforeAccept: json['status_before_accept'],
      serviceName: json['ServiceName'],
      acceptenceRole: json['ACCEPTANCE_ROLE']
    );
  }
}
