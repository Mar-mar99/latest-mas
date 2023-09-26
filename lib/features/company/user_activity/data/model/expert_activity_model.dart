import '../../domain/entities/expert_activity_entity.dart';

class UserActivityModel extends UserActivityEntity{


  UserActivityModel(
      {
      super.id,
      super.name,
      super.mobile,
      super.phoneCode,
      super.avatar,
      super.rating,
      super.email,
      super.canceled,
      super.completed,
      super.revenue});

 factory UserActivityModel.fromJson(Map<String, dynamic> json) {
  return UserActivityModel(
    id : json['id'],
    name : json['name'],
    mobile : json['mobile'],
    phoneCode : json['phone_code'],
    avatar : json['avatar'],
    rating : json['rating'],
    email  : json['email'],
    canceled  : json['Canceled'],
    completed : json['Completed'],
    revenue   : json['Revenue'],
  );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['mobile'] = mobile;
    data['phone_code'] = phoneCode;
    data['avatar'] = avatar;
    data['rating'] = rating;
    data['email'] = email;
    data['Canceled'] = canceled;
    data['Completed'] = completed;
    data['Revenue'] = revenue;
    return data;
  }
}
