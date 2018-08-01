import 'dart:ui';



double hueToRGB(double v1,double v2,double vH )             //Function Hue_2_RGB
{
  if ( vH < 0 ) vH += 1;
  if( vH > 1 ) vH -= 1;
  if ( ( 6 * vH ) < 1 ) return ( v1 + ( v2 - v1 ) * 6 * vH );
  if ( ( 2 * vH ) < 1 ) return ( v2 );
  if ( ( 3 * vH ) < 2 ) return ( v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6 );
  return ( v1 );
}

Color colorFromHSL(double h, double s, double l) {
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

    r = 255 * hueToRGB( var_1, var_2, h + ( 1 / 3 ) );
    g = 255 * hueToRGB( var_1, var_2, h );
    b = 255 * hueToRGB( var_1, var_2, h - ( 1 / 3 ) );
  }

  return new Color.fromRGBO(r.round(), g.round(), b.round(), 1.0);
}

