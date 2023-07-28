import 'package:equatable/equatable.dart';

abstract class LoadingState extends Equatable{}

class InitialState extends LoadingState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class InProgress extends LoadingState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class Completed extends LoadingState {
  final String data;
  Completed({required this.data});

  @override
  List<Object?> get props => [data];
}

class Error extends LoadingState {
  final String message;
  Error({required this.message});

  @override
  List<Object?> get props => [message];
}