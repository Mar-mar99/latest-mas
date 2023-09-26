// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'provider_navigation_cubit.dart';

class ProviderNavigationState extends Equatable {
  final NavigationProvider navigationProvider;
  final int index;
  const ProviderNavigationState({
    required this.navigationProvider,
 required   this.index,
});

  @override
  List<Object> get props => [navigationProvider,index];
}


