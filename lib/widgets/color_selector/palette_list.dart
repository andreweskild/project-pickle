import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide DismissDirection;
import 'package:flutter/rendering.dart';

import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/widgets/color_selector/color_menu_button.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/common/reorderable_list.dart';
import 'package:project_pickle/widgets/common/slide_action.dart';

class PaletteList extends StatefulWidget {
  const PaletteList({ Key key }) : super(key: key);

  @override
  _PaletteListState createState() => _PaletteListState();
}

typedef _SetActiveColorCallback = void Function(int);
typedef _ColorChangeCallback = void Function(Color, int);
typedef _ColorReorderCallback = void Function(int, int);
typedef _ColorRemoveCallback = void Function(int);

class _PaletteModel {
  _PaletteModel({
    this.activeColorIndex,
    this.palette,
    this.reorderCallback,
    this.removeCallback,
    this.addColorCallback,
    this.colorChangeCallback,
    this.setActiveColorCallback,
  });

  final int activeColorIndex;
  final List<Color> palette;
  final _ColorReorderCallback reorderCallback;
  final _ColorRemoveCallback removeCallback;
  final VoidCallback addColorCallback;
  final _SetActiveColorCallback setActiveColorCallback;
  final _ColorChangeCallback colorChangeCallback;
}

class _PaletteListState extends State<PaletteList> {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  

  Widget buildListTile(Color color, int index, bool active, _ColorChangeCallback onColorChanged, _SetActiveColorCallback onToggled) {
    return SlideAction(
      key: Key(color.value.toString() + index.toString()),
      direction: DismissDirection.startToEnd,
      child: ColorMenuButton(
        color: color,
        onColorChanged: (color) => onColorChanged(color, index),
        active: active,
        onToggled: () => onToggled(index),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: StoreConnector<AppState, _PaletteModel>(
        converter: (store) {
          return _PaletteModel(
            activeColorIndex: store.state.activeColorIndex,
            palette: store.state.palette,
            reorderCallback: (oldIndex, newIndex) => store.dispatch(ReorderColorAction(oldIndex, newIndex)),
            removeCallback: (index) => store.dispatch(RemoveColorAction(index)),
            colorChangeCallback: (color, index) => store.dispatch(SetPaletteColorAction(index, color)),
            setActiveColorCallback: (index) => store.dispatch(SetActiveColorIndexAction(index))
          );
        },
        builder: (context, model) {
          return ReorderableList(
            onReorder: model.reorderCallback,
            padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
            children: List.generate(model.palette.length,
              (index) =>
                buildListTile(model.palette[index], index, model.activeColorIndex == index, model.colorChangeCallback, model.setActiveColorCallback),
            ),
            feedbackShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            spacing: 12.0,
          );
        },
      ),
    );
  }
}