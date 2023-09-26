// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/features/provider/homepage/domain/use_cases/submit_provider_location_use_case.dart';

part 'submit_location_provider_event.dart';
part 'submit_location_provider_state.dart';

class SubmitLocationProviderBloc
    extends Bloc<SubmitLocationProviderEvent, SubmitLocationProviderState> {
  final SubmitProviderLocationUseCaase submitProviderLocation;
  Timer? timer;

  SubmitLocationProviderBloc({
    required this.submitProviderLocation,
  }) : super(SubmitLocationProviderInitial()) {

    on<StartSubmittingLocation>((event, emit) {
      timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
        print('calling provider location');
        await submitProviderLocation.submitProviderLocation();
      });
    });

    on<StopSubmittingLocation>((event, emit) {
      if (timer != null) {
        timer!.cancel();
      }
    });
  }
}
