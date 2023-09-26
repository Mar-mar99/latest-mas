import 'package:equatable/equatable.dart';

class PaymentsMethodEntity extends Equatable {
  int? id;
  String? lastFour;
  String? brand;
  int? isDefault;
  String? cardId;

  PaymentsMethodEntity({
    this.id,
    this.lastFour,
    this.brand,
    this.isDefault,
    this.cardId
  });

  @override
  List<Object?> get props => [id, lastFour, brand, isDefault,cardId];
}
