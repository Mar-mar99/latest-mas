import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../../core/ui/widgets/app_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? timer;
  int time = 1;
  void start() {
    DateTime d = DateTime.now();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (mounted) {
          setState(() {
            time = DateTime.now().difference(d).inSeconds;
          });
        }
      },
    );
  }

  formatedTime() {
    int sec = time % 60;
    int min = (time / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          '${AppLocalizations.of(context)?.timeLabel ?? ""} ',
          bold: true,
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.75),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: AppText(
              '${formatedTime()}',
              color: Theme.of(context).scaffoldBackgroundColor,
              bold: true,
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer!.cancel();
    }
  }
}
