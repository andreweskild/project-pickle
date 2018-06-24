import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/utilities/color.dart';

class ColorSelectionCard extends StatefulWidget {
  ColorSelectionCard({
    Key key,
  }) : super(key: key);

  @override
  _ColorSelectionCardState createState() => new _ColorSelectionCardState();
}


class _ColorSelectionCardState extends State<ColorSelectionCard> {
  double hue = 0.6;
  double saturation = 1.0;
  double lightness = 0.5;

  Color color;

  Color textColor;

  @override
  void initState() {
    color = colorFromHSL(hue, saturation, lightness);
    updateTextColor();
    super.initState();
  }

  void updateColor({double h, double s, double l}) {
    setState(() {
      if (h != null) hue = h;
      if (s != null) saturation = s;
      if (l != null) lightness = l;
      color = colorFromHSL(hue, saturation, lightness);
      updateTextColor();
    }); 
  }

  void updateTextColor() {
    if (color.computeLuminance() > 0.5) {
      textColor = Colors.black;
    }
    else {
      textColor = Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: new Card(
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(16.0)),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Material(
              elevation: 1.0,
              color: color,
              borderRadius: new BorderRadius.only(topLeft: new Radius.circular(16.0), topRight: new Radius.circular(16.0)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 48.0),
                child: new ListTile(
                  title: Text(
                    "Color", 
                    textAlign: TextAlign.end,
                    style: new TextStyle(color: textColor),
                  ),
                  leading: new IconButton(
                    icon: new Icon(Icons.arrow_forward, color: textColor,),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: new Column(
                children: <Widget>[
                  new Slider(
                    onChanged: (value) { 
                      updateColor(h: value);
                    },
                    value: hue,
                    min: 0.0,
                    max: 1.0,
                  ),
                  new Slider(
                    onChanged: (value) { 
                      updateColor(s: value);
                    },
                    value: saturation,
                    min: 0.0,
                    max: 1.0,
                  ),
                  new Slider(
                    onChanged: (value) { 
                      updateColor(l: value);
                    },
                    value: lightness,
                    min: 0.0,
                    max: 1.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}