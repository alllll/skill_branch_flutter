import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc() : super(ConnectivityInitialState());

  @override
  Stream<ConnectivityState> mapEventToState(
    ConnectivityEvent event,
  ) async* {
    if (event is ConnectivityOnEvent) {
      yield ConnectivityOnState();
    }
    if (event is ConnectivityOffEvent) {
      yield ConnectivityOffState();
    }
  }
}
