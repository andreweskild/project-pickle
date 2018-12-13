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
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: ColorMenuButton(
                color: model.palette[index],
                onColorChanged: (color) => model.colorChangeCallback(color, index),
                active: model.activeColorIndex == index,
                onToggled: () => model.setActiveColorCallback(index),
              ),
            ),
            Positioned.fill(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: (){},
                ),
              ),
            )
          ],
        ),
      );
    }
    else {
      return InkWell(
        onTap: (){},
        child: ColorMenuButton(
          key: Key(model.palette[index].value.toString() + index.toString()),
          color: model.palette[index],
          onColorChanged: (color) => model.colorChangeCallback(color, index),
          active: model.activeColorIndex == index,
          onToggled: () => model.setActiveColorCallback(index),
        ),
      );
    }

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
                buildListTile(index, model),
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