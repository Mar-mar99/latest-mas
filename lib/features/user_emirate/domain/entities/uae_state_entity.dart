import 'dart:convert';

import 'package:equatable/equatable.dart';

class UAEStateEntity extends Equatable{
  final int id;
  final String state;
  UAEStateEntity({
    required this.id,
    required this.state,
  });
factory UAEStateEntity.empty(){
  return UAEStateEntity(id: -1, state: '');
}

  @override

  List<Object?> get props =>[id,state];
}
