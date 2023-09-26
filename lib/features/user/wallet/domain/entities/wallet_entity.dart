import 'package:equatable/equatable.dart';

class WalletEntity extends Equatable{
    int? id;
  String? type;
  String? amount;
  String? description;
  String? createdAt;
  String? receiptUrl;

  WalletEntity(
      { this.id,
        this.type,
        this.amount,
        this.description,
        this.createdAt,
        this.receiptUrl});



  @override

  List<Object?> get props => [
        id,
        type,
        amount,
        description,
        createdAt,
        receiptUrl
  ];
  }
