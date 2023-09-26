import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/utils/enums/navigation_enums.dart';

part 'user_navigation_state.dart';

class UserNavigationCubit extends Cubit<UserNavigationState> {
  UserNavigationCubit()
      : super(const UserNavigationState(
          naviagtionUser: NaviagtionUser.explore,
          index: 2,
        ));

  void getItem(NaviagtionUser naviagtionUser) {
    switch (naviagtionUser) {


      case NaviagtionUser.favorite:
        emit(const UserNavigationState(
            naviagtionUser: NaviagtionUser.favorite, index: 0));
        break;
      case NaviagtionUser.notification:
        emit(const UserNavigationState(
            naviagtionUser: NaviagtionUser.notification, index: 1));
        break;
           case NaviagtionUser.explore:
        emit(const UserNavigationState(
            naviagtionUser: NaviagtionUser.explore, index: 2));
        break;
         case NaviagtionUser.offers:
         emit(const UserNavigationState(
            naviagtionUser: NaviagtionUser.offers, index: 3));
        break;
      case NaviagtionUser.account:
        emit(const UserNavigationState(
            naviagtionUser: NaviagtionUser.account, index: 4));
        break;

    }
  }
}
