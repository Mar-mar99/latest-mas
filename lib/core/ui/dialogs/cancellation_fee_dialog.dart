// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CancellationFee extends StatelessWidget {
  final String amount;
  final Function okHandler;
  final Function cancelHandler;
  const CancellationFee({
    Key? key,
    required this.amount,
    required this.okHandler,
    required this.cancelHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 24),
        child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Warning!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24)),
                    Text(
                        'You will be charged a cancellation fee because this type of service is a subject to a cancellation fee:'),
                    const SizedBox(height: 16),
                    Text(
                      'Fees: $amount%',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCancelBtn(context),
                        const SizedBox(
                          width: 20,
                        ),
                        _buildAgreeToButton(context),
                      ],
                    ),
                  ]),
              Positioned(
                top: -70,
                child: CircleAvatar(
                  child: Icon(Icons.warning, color: Colors.white),
                  backgroundColor: Colors.redAccent,
                  radius: 40,
                ),
              )
            ]),
      ),
    );
  }

  Expanded _buildCancelBtn(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          cancelHandler();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.withOpacity(.5),
        ),
        child: Text(
          'NO',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Expanded _buildAgreeToButton(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {

          okHandler();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        child: Text('I agree'),
      ),
    );
  }
}
