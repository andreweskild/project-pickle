import 'platform_group.dart';

class Project {
  Project(
    this.name,
    [this._platformGroups]
  );

  String name;

  var _platformGroups = <String, PlatformGroup>{};

  void createNewArtboardGroup(String name) {
    _platformGroups.addAll({name: new PlatformGroup(name)});
  }
}