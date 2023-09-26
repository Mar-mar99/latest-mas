import 'package:flutter/material.dart';

showLoadingDialog(
  BuildContext context,
  { String text="Loading",
  bool showText=true}
) {
  showDialog(
    context: context,
    
    builder: (context) => Dialog(

      insetPadding:const EdgeInsets.all(32),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisSize: MainAxisSize.min, children:  [
         const CircularProgressIndicator(),
         const SizedBox(
            height: 16,
          ),
        if(showText)  Text('$text...'),
        ]),
      ),
    ),
  );
  ;
}
