import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

showCustomBottomSheet({
  required BuildContext context,
  required Widget child,
 
}) {
  var basicBody = Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 3,
          width: 35,
          color: Theme.of(context).primaryColor,
          alignment: Alignment.center,
        ),
      ),
      child,
    ],
  );

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return basicBody;
    },
  );
}
