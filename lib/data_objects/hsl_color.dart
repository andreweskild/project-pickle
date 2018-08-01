import 'dart:ui';
import 'dart:math' as math;

class HSLColor {
  HSLColor({
    this.h = 1.0,
    this.s = 1.0,
    this.l = 0.5
  });

  HSLColor.from(
    HSLColor color
  ) : this(
    h: color.h,
    s: color.s,
    l: color.l,
  );


  HSLColor.fromRGB(Color color) :
      this.from(_rgbToHsl(color));

  HSLColor copyWith({
    double h,
    double s,
    double l,
  }) {
    return new HSLColor(
      h: h ?? this.h,
      s: s ?? this.s,
      l: l ?? this.l
    );
  }

  double h;
  double s;
  double l;

  double _hueToRGB(double v1,double v2,double vH ) {
    if ( vH < 0 ) vH += 1;
    if( vH > 1 ) vH -= 1;
    if ( ( 6 * vH ) < 1 ) return ( v1 + ( v2 - v1 ) * 6 * vH );
    if ( ( 2 * vH ) < 1 ) return ( v2 );
    if ( ( 3 * vH ) < 2 ) return ( v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6 );
    return ( v1 );
  }

  Color toColor() {
    //H, S and L input range = 0 ÷ 1.0
    //R, G and B output range = 0 ÷ 255
    double var_1, var_2;

    double r, g, b;

    if ( s == 0 )
    {

      r = l * 255.0;
      g = l * 255.0;
      b = l * 255.0;
    }
    else
    {
      if ( l < 0.5 )  {
        var_2 = l * ( 1 + s );
      }
      else {
        var_2 = ( l + s ) - ( s * l );
      }

      var_1 = 2 * l - var_2;

      r = 255 * _hueToRGB( var_1, var_2, h + ( 1 / 3 ) );
      g = 255 * _hueToRGB( var_1, var_2, h );
      b = 255 * _hueToRGB( var_1, var_2, h - ( 1 / 3 ) );
    }

    return new Color.fromRGBO(r.round(), g.round(), b.round(), 1.0);
  }


  static HSLColor _rgbToHsl(Color rgbColor) {
    double r = rgbColor.red.toDouble();
    double g = rgbColor.green.toDouble();
    double b = rgbColor.blue.toDouble();

    r /= 255.0;
    g /= 255.0;
    b /= 255.0;

    double max = math.max(r, math.max(g, b)), min = math.min(r, math.min(g, b));
    double h, s, l = (max + min) / 2.0;

    if (max == min) {
      h = s = 0.0; // achromatic
    } else {
      var d = max - min;
      s = l > 0.5 ? d / (2 - max - min) : d / (max + min);

      if (max == r) {
        h = (g - b) / d + (g < b ? 6.0 : 0.0);
      }
      else if (max == g) {
        h = (b - r) / d + 2.0;
      }
      else if (max == b) {
        h = (r - g) / d + 4.0;
      }

      h /= 6.0;
    }

    return HSLColor(h: h, s: s, l: l);
  }

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + h.hashCode;
    result = 37 * result + s.hashCode;
    result = 37 * result + l.hashCode;
    return result;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! HSLColor) return false;
    HSLColor color = other;
    return (color.h == h &&
        color.s == s &&
        color.l == l);
  }
}

