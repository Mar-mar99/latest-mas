part of 'provider_info_bloc.dart';

abstract class ProviderInfoEvent extends Equatable {
  const ProviderInfoEvent();

  @override
  List<Object> get props => [];
}

class GetProviderInfoAndPending extends ProviderInfoEvent{

}
