// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_create_request_bloc.dart';

class UserCreateRequestState extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  final int serviceType;
  final ServicePaymentType paymentStatus;
  final PaymentMethod? paymentMethod;
  final bool withPromo;
  final PromoCodeEntity? promoCode;
  final List<File> images;
  final double distance;
  final bool isSchedule;
  final DateTime? scheduleTime;
  final DateTime? scheduleDate;
  final int stateId;
  final String stateName;
  final String? note;
  final Map<int, dynamic> selectedAttributes;
  final ProviderStatus providerStatus;
  final FormSubmissionState formSubmissionState;
  final int selectedProviderId;
  final int requestId;
  final CreatedRequestResultEntity? createdRequestResultEntity;
  UserCreateRequestState(
      {required this.latitude,
      required this.longitude,
      required this.address,
      required this.serviceType,
      required this.paymentStatus,
      this.paymentMethod,
      required this.withPromo,
      this.promoCode,
      this.images = const [],
      required this.distance,
      required this.isSchedule,
      this.scheduleTime,
      this.scheduleDate,
      required this.stateId,
      required this.stateName,
      this.note,
      required this.selectedAttributes,
      required this.providerStatus,
      required this.formSubmissionState,
      this.selectedProviderId = 0,
      this.requestId = 0,
      this.createdRequestResultEntity});
  factory UserCreateRequestState.empty() {
    return UserCreateRequestState(
      address: '',
      longitude: 0,
      latitude: 0,
      distance: 10,
      stateId: 0,
      stateName: '',
      serviceType: 0,
      isSchedule: false,
      withPromo:false,
      paymentStatus: ServicePaymentType.free,
      selectedAttributes: const {},
      formSubmissionState: const InitialFormState(),
      providerStatus: ProviderStatus.online,
    );
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
        stateName,
        note.toString(),
        selectedAttributes,
        providerStatus,
        formSubmissionState,
        createdRequestResultEntity.toString(),
        selectedProviderId,
        withPromo,
        requestId,
      ];

  @override
  bool get stringify => true;

  UserCreateRequestState copyWith({
    double? latitude,
    double? longitude,
    String? address,
    int? serviceType,
    ServicePaymentType? paymentStatus,
    PaymentMethod? paymentMethod,
    bool? withPromo,
    PromoCodeEntity? promoCode,
    List<File>? images,
    double? distance,
    bool? isSchedule,
    DateTime? scheduleTime,
    DateTime? scheduleDate,
    int? stateId,
    String? stateName,
    String? note,
    Map<int, dynamic>? selectedAttributes,
    ProviderStatus? providerStatus,
    FormSubmissionState? formSubmissionState,
    CreatedRequestResultEntity? createdRequestResultEntity,
    int? requestId,
    int? selectedProviderId,
  }) {
    return UserCreateRequestState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      serviceType: serviceType ?? this.serviceType,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      withPromo:withPromo??this.withPromo,
      promoCode: promoCode ?? this.promoCode,
      images: images ?? this.images,
      distance: distance ?? this.distance,
      isSchedule: isSchedule ?? this.isSchedule,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      stateId: stateId ?? this.stateId,
      stateName: stateName ?? this.stateName,
      note: note ?? this.note,
      providerStatus: providerStatus ?? this.providerStatus,
      selectedAttributes: selectedAttributes ?? this.selectedAttributes,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
      createdRequestResultEntity:
          createdRequestResultEntity ?? this.createdRequestResultEntity,
      requestId: requestId ?? this.requestId,
      selectedProviderId: selectedProviderId ?? this.selectedProviderId,
    );
  }
}
