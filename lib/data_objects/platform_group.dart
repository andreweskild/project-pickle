import 'artboard_group.dart';

class PlatformGroup {
  PlatformGroup(
    this.name,
    [this._artboardGroups,
    this.defualtHeight,
    this.defaultWidth,]
  );

  String name;

  int defaultWidth;
  int defualtHeight;

  var _artboardGroups = <String, ArtboardGroup>{};

  void createNewArtboardGroup(String name) {
    _artboardGroups.addAll({name: new ArtboardGroup(name)});
  }

}