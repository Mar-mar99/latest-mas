// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class OfflineRequestEntity extends Equatable {
  final int? id;
  final String? bookingId;
  final int? userId;
  final dynamic? providerId;
  final int? currentProviderId;
  final int? serviceTypeId;
  final int? isEmergency;
  final dynamic? emergencyTime;
  final dynamic? emergencyPercentage;
  final List<String>? beforeImage;
  final dynamic? beforeComment;
  final List<String>? afterImage;
  final dynamic? afterComment;
  final String? status;
  final String? cancelledBy;
  final dynamic? cancelTime;
  final dynamic? cancelReason;
  final String? paymentMode;
  final int? paid;
  final int? distance;
  final String? sAddress;
  final double? sLatitude;
  final double? sLongitude;
  final Null? dAddress;
  final int? dLatitude;
  final int? dLongitude;
  final String? assignedAt;
  final String? scheduleAt;
  final dynamic? startedAt;
  final dynamic? finishedAt;
  final int? userRated;
  final int? providerRated;
  final int? useWallet;
  final int? reminder;
  final int? pushCount;
  final dynamic? promocodeId;
  final String? notes;
  final dynamic? attributez;
  final int? stateId;
  final dynamic? statusBeforeAccept;
  final String? serviceName;
  final String? acceptenceRole;

  OfflineRequestEntity({
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
    this.notes,
    this.attributez,
    this.stateId,
    this.statusBeforeAccept,
    this.serviceName,
    this.acceptenceRole,
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
      notes,
      attributez,
      stateId,
      statusBeforeAccept,
      serviceName,
      acceptenceRole
  ];
}
