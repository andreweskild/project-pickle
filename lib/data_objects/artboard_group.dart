import 'artboard.dart';

class ArtboardGroup {
  ArtboardGroup(
    this.name,
    [this.artboards]
  );

  String name;

  var artboards = <Artboard>[];
}