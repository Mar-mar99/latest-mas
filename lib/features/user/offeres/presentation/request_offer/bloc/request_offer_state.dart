part of 'request_offer_bloc.dart';

 class RequestOfferState extends Equatable {
 final double latitude;
  final double longitude;
  final String address;
  final int serviceType;
   final double distance;
  final ServicePaymentType paymentStatus;
  final PaymentMethod? paymentMethod;
  final int? promoCode;
  final List<File> images;
  final bool isSchedule;
  final DateTime? scheduleTime;
  final DateTime? scheduleDate;
  final int stateId;
  final String? note;
  final FormSubmissionState formSubmissionState;
  final int providerId;
  final int requestId;
  const RequestOfferState({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.serviceType,
    required this.distance,
    required this.paymentStatus,
    this.paymentMethod,
    required this.promoCode,
    this.images = const [],
    required this.isSchedule,
    this.scheduleTime,
    this.scheduleDate,
    required this.stateId,
    this.note,
    required this.formSubmissionState,
    required this.providerId,
    this.requestId = 0,
  });

  factory RequestOfferState.empty() {
    return const RequestOfferState(
        address: '',
        distance: 10,
        longitude: 0,
        latitude: 0,
        promoCode: 0,
        stateId: 0,
        serviceType: 0,
        isSchedule: false,
        paymentStatus: ServicePaymentType.free,
        formSubmissionState: InitialFormState(),
        providerId: 0
        );
  }
  @override
  List<Object> get props => [
        latitude,
        longitude,
        address,
        serviceType,
        distance,
        paymentStatus,
        paymentMethod.toString(),
        promoCode.toString(),
        images,
        isSchedule,
        scheduleTime.toString(),
        scheduleDate.toString(),
        stateId,
        note.toString(),
        formSubmissionState,
        requestId,
        providerId
      ];


  RequestOfferState copyWith({
    double? latitude,
    double? longitude,
    String? address,
    int? serviceType,
    double? distance,
    ServicePaymentType? paymentStatus,
    PaymentMethod? paymentMethod,
    int? promoCode,
    List<File>? images,
    bool? isSchedule,
    DateTime? scheduleTime,
    DateTime? scheduleDate,
    int? stateId,
    String? note,
    FormSubmissionState? formSubmissionState,
    int? providerId,
    int? requestId,
  }) {
    return RequestOfferState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      serviceType: serviceType ?? this.serviceType,
      distance: distance?? this.distance,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      promoCode: promoCode ?? this.promoCode,
      images: images ?? this.images,
      isSchedule: isSchedule ?? this.isSchedule,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      stateId: stateId ?? this.stateId,
      note: note ?? this.note,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
      providerId: providerId ?? this.providerId,
      requestId: requestId ?? this.requestId,
    );
  }
}
