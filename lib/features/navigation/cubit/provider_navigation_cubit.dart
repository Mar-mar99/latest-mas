import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/utils/enums/navigation_enums.dart';
part 'provider_navigation_state.dart';

class ProviderNavigationCubit extends Cubit<ProviderNavigationState> {
  ProviderNavigationCubit()
      : super(const ProviderNavigationState(
            navigationProvider: NavigationProvider.homepage,index: 0));

  void getItem(NavigationProvider navigationProvider) {
    switch (navigationProvider) {
      case NavigationProvider.homepage:
        emit(const ProviderNavigationState(
            navigationProvider: NavigationProvider.homepage,index: 0));
        break;
      case NavigationProvider.notification:
        emit(const ProviderNavigationState(
            navigationProvider: NavigationProvider.notification,index: 1));
        break;
      case NavigationProvider.account:
        emit(const ProviderNavigationState(
            navigationProvider: NavigationProvider.account,index: 2));
        break;
    }
  }
}
