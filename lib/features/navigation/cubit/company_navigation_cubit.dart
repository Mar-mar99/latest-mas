import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/utils/enums/navigation_enums.dart';
part 'company_navigation_state.dart';

class CompanyNavigationCubit extends Cubit<CompanyNavigationState> {
  CompanyNavigationCubit()
      : super(const CompanyNavigationState(
            navigationCompany: NavigationCompany.summary,index: 0));

  void getItem(NavigationCompany navigationCompany) {
    switch (navigationCompany) {
      case NavigationCompany.summary:
        emit(const CompanyNavigationState(
            navigationCompany: NavigationCompany.summary,index: 0));
        break;
      case NavigationCompany.notification:
        emit(const CompanyNavigationState(
            navigationCompany: NavigationCompany.notification,index: 1));
        break;
      case NavigationCompany.account:
        emit(const CompanyNavigationState(
            navigationCompany: NavigationCompany.account,index: 2));
        break;
    }
  }
}
