// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'request_fav_provider_bloc.dart';

class RequestFavProviderState extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  final int serviceType;
   final double distance;
  final ServicePaymentType paymentStatus;
  final PaymentMethod? paymentMethod;
  final PromoCodeEntity? promoCode;
  final bool withPromo;
  final List<File> images;
  final bool isSchedule;
  final DateTime? scheduleTime;
  final DateTime? scheduleDate;
  final int stateId;
  final String? note;
  final FormSubmissionState formSubmissionState;
  final int providerId;
  final int requestId;
  const RequestFavProviderState({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.serviceType,
    required this.distance,
    required this.paymentStatus,
    required this.withPromo,
    this.paymentMethod,
    this.promoCode,
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

  factory RequestFavProviderState.empty() {
    return const RequestFavProviderState(
        address: '',
        distance: 10,
        longitude: 0,
        latitude: 0,
        stateId: 0,
        serviceType: 0,
        isSchedule: false,
        withPromo:false,
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
        withPromo,
        formSubmissionState,
        requestId,
        providerId
      ];


  RequestFavProviderState copyWith({
    double? latitude,
    double? longitude,
    String? address,
    int? serviceType,
    double? distance,
    ServicePaymentType? paymentStatus,
    PaymentMethod? paymentMethod,
    PromoCodeEntity? promoCode,
    bool? withPromo,
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
    return RequestFavProviderState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      serviceType: serviceType ?? this.serviceType,
      distance: distance?? this.distance,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      withPromo:withPromo??this.withPromo,
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
