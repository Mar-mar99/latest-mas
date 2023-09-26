import 'package:masbar/features/company/manage_providers/domain/entities/provider_entity.dart';

class ProviderModel extends ProviderEntity{


  ProviderModel(
      {
      super.id,
      super.firstName,
      super.lastName,
      super.email,
      super.phoneCode,
      super.mobile,
      super.active,
      super.image,
      super.expertMobile,
      super.type});
factory  ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
    id :json['id']??'',
    firstName : json['first_name'],
    lastName :json['last_name'],
    email :json['email'],
    phoneCode : json['phone_code']??'',
    mobile : json['mobile']??'',
    active : json['Active'],
    expertMobile : json['expert_mobile']??'',
    type : json['Active'] != null ? 0 : 1,
    image : ''//json['image']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_code'] = phoneCode;
    data['mobile'] = mobile;
    data['Active'] = active;
    data['image'] = image;
    return data;
  }

}
