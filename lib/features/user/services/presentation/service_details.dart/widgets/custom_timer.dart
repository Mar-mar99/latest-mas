import 'package:flutter/material.dart';

import '../../../../../../core/ui/widgets/app_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CustomTimer extends StatefulWidget {
  final DateTime startedAt;
   CustomTimer({required this.startedAt});

  @override
  State<CustomTimer> createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  String _hours = "";

  String _minutes = "";

  String _second = "";

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  buildTime(int second) {
    Duration duration = Duration(seconds: second);
    _hours = twoDigits(duration.inHours.remainder(60));
    _minutes = twoDigits(duration.inMinutes.remainder(60));
    _second = twoDigits(duration.inSeconds.remainder(60));
  }

  StopWatchTimer? stopWatchTimer;

 void startTimer(DateTime d) {
    if (stopWatchTimer == null) {
      stopWatchTimer = StopWatchTimer(
          mode: StopWatchMode.countUp,
          presetMillisecond: StopWatchTimer.getMilliSecFromSecond(DateTime.now()
              .toUtc()
              .difference(d.subtract(const Duration(hours: 1)).toUtc())
              .abs()
              .inSeconds,),);
      stopWatchTimer?.onStartTimer();
    }

  }

   @override
  void initState() {
    super.initState();
    startTimer(widget.startedAt);
  }

  @override
  void dispose() async {
    super.dispose();
    if(stopWatchTimer!=null){

     stopWatchTimer!.dispose();
  }}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          AppLocalizations.of(context)?.serviceTime ?? "",
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        StreamBuilder<int>(
          stream: stopWatchTimer?.secondTime,
          initialData: 0,
          builder: (context, snap) {
            final value = snap.data;
            if (value != null) {
              buildTime(value);
            }
            return Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _buildHours(context),
                        _buildMinutes(context),
                        _buildSeconds(context)
                      ],
                    )),
              ],
            );
          },
        ),
        const Divider(),
      ],
    );
  }

  Column _buildSeconds(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppText(
            _second,
            fontSize: 14,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppText(
            AppLocalizations.of(context)?.secondLabel ?? "",
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Column _buildMinutes(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppText(
            _minutes,
            fontSize: 14,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppText(
            AppLocalizations.of(context)?.minutesLabel ?? "",
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Column _buildHours(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppText(
            _hours,
            fontSize: 14,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppText(
            AppLocalizations.of(context)?.hoursLabel ?? "",
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
