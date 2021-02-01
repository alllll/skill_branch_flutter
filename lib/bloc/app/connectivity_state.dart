part of 'connectivity_bloc.dart';

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

class ConnectivityInitialState extends ConnectivityState {}

class ConnectivityOnState extends ConnectivityState {}

class ConnectivityOffState extends ConnectivityState {}
