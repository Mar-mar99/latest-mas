import 'package:flutter/material.dart';
import 'package:masbar/core/constants/api_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../enums/enums.dart';

class Helpers {
  static String getExtension(String path) {
    String fileName = path.split('/').last;
    String fileExtension = path.split('.').last;
    String result = "${fileName.substring(0, 3)}.$fileExtension";
    return result;
  }

  static TypeAuth getUserTypeEnum(String value) {
    switch (value) {
      case 'company':
        return TypeAuth.company;
      case 'provider':
        return TypeAuth.provider;
      case '':
        return TypeAuth.user;
      default:
        return TypeAuth.user;
    }
  }

  static getImage(String? image) {
    return image == null || image.isEmpty
        ? ''
        : image.contains('http')
            ? image
            : ApiConstants.STORAGE_URL + image;
  }

  static Future launchPhone(String phone) async {
    var url = "tel:00971$phone";

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  static isThereCurrentDialogShowing(BuildContext context) =>
  ModalRoute.of(context)?.isCurrent != true;

   static List<T> modelBuilder<M, T>(
          List<M> models, T Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, T>((index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
}
