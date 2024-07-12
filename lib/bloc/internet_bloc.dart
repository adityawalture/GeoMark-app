// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geomark/bloc/internetevent_bloc.dart';
import 'package:geomark/bloc/internetstate_bloc.dart';


class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  InternetBloc() : super(InternetInitialState()) {
    on<InternetLossEvent>((event, emit) => emit(InternetLossState()));
    on<InternetConnectedEvent>((event, emit) => emit(InternetConnectedState()));

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        add(InternetConnectedEvent());
      } else {
        add(InternetLossEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
