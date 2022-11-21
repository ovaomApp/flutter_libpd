import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class PlaybackConfiguration extends Equatable {
  final int? sampleRate;
  final int? inputNumberOfChannels;
  final int? outputNumberOfChannels;
  final bool inputEnabled;

  const PlaybackConfiguration({
    this.sampleRate,
    this.inputNumberOfChannels,
    this.outputNumberOfChannels,
    required this.inputEnabled,
  });

  @override
  List<Object?> get props => [
        sampleRate,
        inputNumberOfChannels,
        outputNumberOfChannels,
        inputEnabled,
      ];
}
