import '../../domain/entities/invoice_entity.dart';

class InvoiceModel extends InvoiceEntity {
  InvoiceModel(
      {super.message,
      super.startTime,
      super.endTime,
      super.time,
      super.basicPrice,
      super.hourlyPrice,
      super.timePrice,
      super.emergenctTimePrice,
      super.discount,
      super.tax,
      super.localCompanyDiscount,
      super.commision,
      super.charityValue,
      super.total,
      super.paymentId,
      super.paymentTatus,
      super.shouldPay,
      super.serviceId,
      super.bookingId,
      super.isFreeService,
      super.isLocalCompany,
      super.paymentMode});

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
        message: json['message'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        time: json['Time'],
        basicPrice: json['basicPrice'],
        hourlyPrice: json['hourlyPrice'],
        timePrice: json['timePrice'],
        emergenctTimePrice: json['emergenctTimePrice'],
        discount: json['discount'],
        tax: json['tax'],
        localCompanyDiscount: json['localCompanyDiscount'],
        commision: json['commision'],
        charityValue: json['charity_value'],
        total: json['total'],
        paymentId: json['payment_id'],
        bookingId: json['booking_id'],
        paymentTatus: json['payment_tatus'],
        shouldPay: json['ShouldPay'],
        serviceId: json['service_id'],
        isFreeService: json['isFreeService'],
        isLocalCompany: json['isLocalCompany'] ?? false,
        paymentMode: json['payment_mode']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['Time'] = time;
    data['basicPrice'] = basicPrice;
    data['hourlyPrice'] = hourlyPrice;
    data['booking_id'] = bookingId;
    data['timePrice'] = timePrice;
    data['emergenctTimePrice'] = emergenctTimePrice;
    data['discount'] = discount;
    data['tax'] = tax;
    data['localCompanyDiscount'] = localCompanyDiscount;
    data['commision'] = commision;
    data['charity_value'] = charityValue;
    data['total'] = total;
    data['payment_id'] = paymentId;
    data['payment_tatus'] = paymentTatus;
    data['ShouldPay'] = shouldPay;
    data['service_id'] = serviceId;
    data['isFreeService'] = isFreeService;
    data['isLocalCompany'] = isLocalCompany;
    return data;
  }
}
