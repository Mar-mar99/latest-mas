import 'package:equatable/equatable.dart';

class InvoiceEntity extends Equatable {
 final String? message;
 final String? startTime;
 final String? endTime;
 final String? time;
 final String? basicPrice;
 final String? hourlyPrice;
 final String? timePrice;
 final String? emergenctTimePrice;
 final String? discount;
 final String? tax;
 final String? localCompanyDiscount;
 final String? commision;
 final String? charityValue;
 final String? total;
 final int? paymentId;
 final String? paymentTatus;
 final String? bookingId;
 final int? shouldPay;
 final int? serviceId;
 final bool? isFreeService;
 final bool? isLocalCompany;
 final String? paymentMode;

  InvoiceEntity(
      { this.message,
        this.startTime,
        this.endTime,
        this.time,
        this.basicPrice,
        this.hourlyPrice,
        this.timePrice,
        this.emergenctTimePrice,
        this.discount,
        this.tax,
        this.localCompanyDiscount,
        this.commision,
        this.charityValue,
        this.total,
        this.paymentId,
        this.paymentTatus,
        this.shouldPay,
        this.serviceId,
        this.bookingId,
        this.isFreeService,
        this.isLocalCompany,
        this.paymentMode});


  @override

  List<Object?> get props => [
    message,
        startTime,
        endTime,
        time,
        basicPrice,
        hourlyPrice,
        timePrice,
        emergenctTimePrice,
        discount,
        tax,
        localCompanyDiscount,
        commision,
        charityValue,
        total,
        paymentId,
        paymentTatus,
        shouldPay,
        serviceId,
        bookingId,
        isFreeService,
        isLocalCompany,
        paymentMode
  ];
}
