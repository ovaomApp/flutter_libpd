import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UnzipRequest extends Equatable {
  final String filename;
  final String packageName;
  final String resourceType;

  const UnzipRequest({
    required this.filename,
    required this.packageName,
    required this.resourceType,
  });

  @override
  List<Object> get props => [filename, packageName, resourceType];
}
