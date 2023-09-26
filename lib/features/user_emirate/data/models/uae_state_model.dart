

import 'package:masbar/features/user_emirate/domain/entities/uae_state_entity.dart';


class UAEStateModel extends UAEStateEntity{

  UAEStateModel({
    required super.id,
    required super.state,
  });


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'state': state,
    };
  }

  factory  UAEStateModel.fromJson(Map<String, dynamic> map) {
    return UAEStateModel(
      id: map['id'] as int,
      state: map['state'] as String,
    );
  }

}
