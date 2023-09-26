// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_request_bloc.dart';

class CreateRequestState extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  final int serviceType;
  final ServicePaymentType paymentStatus;
  final PaymentMethod? paymentMethod;
  final PromoCodeEntity? promoCode;
  final bool withPromo;
  final List<File> images;
  final double distance;
  final bool isSchedule;
  final DateTime? scheduleTime;
  final DateTime? scheduleDate;
  final int stateId;
  final String? note;
  final Map<int, dynamic> selectedAttributes;
  final FormSubmissionState formSubmissionState;
  final CreatedRequestResultEntity? createdRequestResultEntity;
  CreateRequestState({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.serviceType,
    required this.paymentStatus,
    required this.distance,
    required this.isSchedule,
    required this.selectedAttributes,
    required this.formSubmissionState,
    required this.stateId,
    this.paymentMethod,
    required this.withPromo,
    this.promoCode,
    this.images = const [],
    this.scheduleTime,
    this.scheduleDate,
    this.note,
    this.createdRequestResultEntity
  });
  factory CreateRequestState.empty() {
    return CreateRequestState(
        address: '',
        longitude: 0,
        latitude: 0,
        distance: 10,
        stateId: 0,
        serviceType: 0,
        isSchedule: false,
        withPromo:false,
        paymentStatus: ServicePaymentType.free,
        selectedAttributes: const {},
        formSubmissionState: const InitialFormState());
  }
  @override
  List<Object> get props => [
        latitude,
        longitude,
        address,
        serviceType,
        paymentStatus,
        paymentMethod.toString(),
        promoCode.toString(),
        images.toString(),
        distance,
        isSchedule,
        scheduleTime.toString(),
        scheduleDate.toString(),
        stateId,
        note.toString(),
        selectedAttributes,
        formSubmissionState,
        createdRequestResultEntity.toString(),
        withPromo
      ];

  @override
  bool get stringify => true;

  CreateRequestState copyWith({
    double? latitude,
    double? longitude,
    String? address,
    int? serviceType,
    ServicePaymentType? paymentStatus,
    PaymentMethod? paymentMethod,
    PromoCodeEntity? promoCode,
    bool? withPromo,
    List<File>? images,
    double? distance,
    bool? isSchedule,
    DateTime? scheduleTime,
    DateTime? scheduleDate,
    int? stateId,
    String? note,
    Map<int, dynamic>? selectedAttributes,
    FormSubmissionState? formSubmissionState,
    CreatedRequestResultEntity? createdRequestResultEntity,
  }) {
    return CreateRequestState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      serviceType: serviceType ?? this.serviceType,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      promoCode: promoCode ?? this.promoCode,
      withPromo:withPromo??this.withPromo,
      images: images ?? this.images,
      distance: distance ?? this.distance,
      isSchedule: isSchedule ?? this.isSchedule,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      stateId: stateId ?? this.stateId,
      note: note ?? this.note,
      selectedAttributes: selectedAttributes ?? this.selectedAttributes,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
      createdRequestResultEntity: createdRequestResultEntity ?? this.createdRequestResultEntity,
    );
  }
}
