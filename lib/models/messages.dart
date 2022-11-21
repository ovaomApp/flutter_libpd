import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class FloatMessage extends Equatable {
  final double value;
  final String receiver;

  const FloatMessage({
    required this.value,
    required this.receiver,
  });

  @override
  List<Object> get props => [value, receiver];
}

@immutable
class BangMessage extends Equatable {
  final String receiver;

  const BangMessage({
    required this.receiver,
  });

  @override
  List<Object> get props => [receiver];
}

@immutable
class SymbolMessage extends Equatable {
  final String value;
  final String receiver;

  const SymbolMessage({
    required this.value,
    required this.receiver,
  });

  @override
  List<Object> get props => [value, receiver];
}

@immutable
class ListMessage extends Equatable {
  final List<dynamic> value;
  final String receiver;

  const ListMessage({
    required this.value,
    required this.receiver,
  });

  @override
  List<Object> get props => [value, receiver];
}

@immutable
class ArgumentMessage extends Equatable {
  final String value;
  final List<dynamic> arguments;
  final String receiver;

  const ArgumentMessage({
    required this.value,
    required this.arguments,
    required this.receiver,
  });

  @override
  List<Object> get props => [value, arguments, receiver];
}
