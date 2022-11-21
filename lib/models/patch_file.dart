import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class PatchFile extends Equatable {
  final String name;
  final String path;

  const PatchFile(this.name, this.path);

  factory PatchFile.absolutePath(String absolutePath) {
    final chunk = absolutePath.split('/');
    final filename = chunk.removeLast();
    final path = chunk.join('/');
    return PatchFile(filename, '$path/');
  }

  @override
  List<Object> get props => [name, path];
}
