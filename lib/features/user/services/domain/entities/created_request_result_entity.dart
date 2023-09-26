import 'package:equatable/equatable.dart';

class CreatedRequestResultEntity extends Equatable {
  final int requestId;

  CreatedRequestResultEntity({
    required this.requestId,
   
  });

  @override
  List<Object?> get props => [
        requestId,
  ];
}
