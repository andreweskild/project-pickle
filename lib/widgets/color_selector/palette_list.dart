import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide DismissDirection;
import 'package:flutter/rendering.dart';

import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/widgets/color_selector/color_menu_button.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/common/reorderable_list.dart';
import 'package:project_pickle/widgets/common/deletable.dart';

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
    this.palette,
    this.reorderCallback,
    this.removeCallback,
    this.addColorCallback,
    this.colorChangeCallback,
  });

  final List<Color> palette;
  final _ColorReorderCallback reorderCallback;
  final _ColorRemoveCallback removeCallback;
  final VoidCallback addColorCallback;
  final _ColorChangeCallback colorChangeCallback;

}

class _ColorModel {
  _ColorModel({
    this.active,
    this.color,
    this.setActiveColorCallback,
    this.colorChangeCallback
  });

  final bool active;
  final Color color;
  final _SetActiveColorCallback setActiveColorCallback;
  final _ColorChangeCallback colorChangeCallback;


  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + active.hashCode;
    result = 37 * result + color.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! _ColorModel) return false;
    _ColorModel model = other;
    return (model.active == active &&
            model.color == color);
  }
}

class _PaletteListState extends State<PaletteList> {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  

  Widget buildListTile(int index, _PaletteModel model) {
    // don't allow deleting of last color in palette
    if(model.palette.length > 1) {
      return Deletable(
        key: Key(model.palette[index].value.toString() + index.toString()),
        direction: DismissDirection.startToEnd,
        onDeleted: (direction) => model.removeCallback(index),
        background: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFFFBABA),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.75,
              heightFactor: 1.0,
              child: Icon(Icons.delete_outline, color: Color(0xFFDC5353)),
            )
        ),
        child: StoreConnector<AppState, _ColorModel>(
          distinct: true,
          converter: (store) {
            return _ColorModel(
              active: index == store.state.activeColorIndex,
              color: store.state.palette[index],
              setActiveColorCallback: (index) => store.dispatch(SetActiveColorIndexAction(index)),
              colorChangeCallback: (newColor, colorIndex) => store.dispatch(SetPaletteColorAction(colorIndex, newColor)),
            );
          },
          builder: (context, colorModel) {
            return ColorMenuButton(
              color: colorModel.color,
              onColorChanged: (color) => colorModel.colorChangeCallback(color, index),
              active: colorModel.active,
              onToggled: () => colorModel.setActiveColorCallback(index),
            );
          } 
        ),
      );
    }
    else {
      return StoreConnector<AppState, _ColorModel>(
          key: Key(model.palette[index].value.toString() + index.toString()),
          distinct: true,
          converter: (store) {
            return _ColorModel(
              active: index == store.state.activeColorIndex,
              color: store.state.palette[index],
              setActiveColorCallback: (index) => store.dispatch(SetActiveColorIndexAction(index)),
              colorChangeCallback: (newColor, colorIndex) => store.dispatch(SetPaletteColorAction(colorIndex, newColor)),
            );
          },
          builder: (context, colorModel) {
            return ColorMenuButton(
              color: colorModel.color,
              onColorChanged: (color) => colorModel.colorChangeCallback(color, index),
              active: colorModel.active,
              onToggled: () => colorModel.setActiveColorCallback(index),
            );
          } 
        );
    }

  }

  int _previousPaletteCount;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _PaletteModel>(
      converter: (store) {
        return _PaletteModel(
          palette: store.state.palette,
          reorderCallback: (oldIndex, newIndex) => store.dispatch(ReorderColorAction(oldIndex, newIndex)),
          removeCallback: (index) => store.dispatch(RemoveColorAction(index)),
          colorChangeCallback: (color, index) => store.dispatch(SetPaletteColorAction(index, color))
        );
      },
      ignoreChange: (state) => _previousPaletteCount == state.palette.length,
      // TODO: add ignoreChange method to check if palette has changed since last build
      builder: (context, model) {
        _previousPaletteCount = model.palette.length;
        return Scrollbar(
          child: ReorderableList(
            onReorder: model.reorderCallback,
            padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
            children: List.generate(model.palette.length,
              (index) =>
                buildListTile(index, model),
            ),
            feedbackDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            spacing: 12.0,
          ),
        );
      },
    );
  }
}