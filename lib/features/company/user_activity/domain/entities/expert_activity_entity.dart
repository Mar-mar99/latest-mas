import 'package:equatable/equatable.dart';

class UserActivityEntity extends Equatable {
  final int? id;
  final String? name;
  final String? mobile;
  final dynamic phoneCode;
  final String? avatar;
  final String? rating;
  final String? email;
  final int? canceled;
  final int? completed;
  final String? revenue;

  factory  UserActivityEntity.empty() {
    return const  UserActivityEntity(
        avatar: '',
        canceled: 0,
        completed: 0,
        email: '',
        id: 0,
        mobile: '',
        name: '',
        phoneCode: '',
        rating: '',
        revenue: '');
  }
 const UserActivityEntity(
      {this.id,
      this.name,
      this.mobile,
      this.phoneCode,
      this.avatar,
      this.rating,
      this.email,
      this.canceled,
      this.completed,
      this.revenue});

  @override
  List<Object?> get props => [
        id,
        name,
        mobile,
        phoneCode,
        avatar,
        rating,
        email,
        canceled,
        completed,
        revenue
      ];
}
