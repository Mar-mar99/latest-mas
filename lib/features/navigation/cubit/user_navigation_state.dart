// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_navigation_cubit.dart';

class UserNavigationState extends Equatable {
  final NaviagtionUser naviagtionUser;
  final int index;
  const UserNavigationState({
    required this.naviagtionUser,
    required this.index,
  });

  @override
  List<Object> get props => [index,naviagtionUser];
}
