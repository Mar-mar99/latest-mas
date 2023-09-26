// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'go_online_bloc.dart';

enum ProviderOnlineState {
  init,
  loading,
  successful,
  noInternet,
  error,
}

class GoOnlineState extends Equatable {
  final ProviderOnlineState providerOnlineState;
  final bool isOnline;
  GoOnlineState({
    required this.providerOnlineState,
    required this.isOnline,
  });
  factory GoOnlineState.empty() {
    return GoOnlineState(
      providerOnlineState: ProviderOnlineState.init,
      isOnline: false,
    );
  }

  @override
  List<Object?> get props => [providerOnlineState, isOnline];

  GoOnlineState copyWith({
    ProviderOnlineState? providerOnlineState,
    bool? isOnline,
  }) {
    return GoOnlineState(
      providerOnlineState: providerOnlineState ?? this.providerOnlineState,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
