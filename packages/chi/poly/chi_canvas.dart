library elem;

import 'dart:html';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:color/color.dart';
import 'package:chi/tools.dart';

final Color BG_COLOR = new Color.hex("ced6b5");
final Color SHADE_COLOR = new Color.hex("bac1a3");
final Color BLACK = new Color.hex("000000");
final Color GREY50 = new Color.hex("7c806d");
final Color GREY25 = new Color.hex("a5ab91");

//const int OUTER_SIDE = INNER_SIDE+2*INNER_MARGIN+2*OUTER_STROKE;
const int DEFAULT_INNER_SIDE = 7;
const int INNER_MARGIN = 1;
const int OUTER_MARGIN = 1;
const int OUTER_STROKE = 1;
//const DOT = OUTER_SIDE+2*OUTER_MARGIN;

class Point {
  int x = 0;
  int y = 0;
  Color col = BLACK;

  Point(this.x, this.y);
  String toString() => '{x: $x, y: $y, col: "$col"}';
  Map<String, Object> toMap(){
    Map<String, Object> ret = new Map();
    ret["x"]=x;
    ret["y"]=y;
    ret["col"]=col.toString();
    return ret;
  }

  Point.fromMap(Map<String, Object> m){
    this.x = m["x"];
    this.y = m["y"];
    this.col = new Color.hex(m["col"]);
  }
}

@CustomTag("chi-canvas")
class ChiCanvas extends PolymerElement with ChangeNotifier {
  @reflectable @published int get base => __$base; int __$base = DEFAULT_INNER_SIDE; @reflectable set base(int value) { __$base = notifyPropertyChange(#base, __$base, value); }
  @reflectable @published bool get transparent => __$transparent; bool __$transparent = true; @reflectable set transparent(bool value) { __$transparent = notifyPropertyChange(#transparent, __$transparent, value); }
  @reflectable @published String get href => __$href; String __$href = ""; @reflectable set href(String value) { __$href = notifyPropertyChange(#href, __$href, value); }

  int get INNER_SIDE => base;
  int get OUTER_SIDE => INNER_SIDE+2*INNER_MARGIN+2*OUTER_STROKE;
  int get DOT => OUTER_SIDE+2*OUTER_MARGIN;

  DivElement _div;
  CanvasElement _root;
  CanvasRenderingContext2D _ctx;

  Map<Tuple2<int, int>, Point> data = new Map();

  int width = 0;
  int height = 0;
  int get nx => width ~/ DOT;
  int get ny => height ~/ DOT;

  void back(){
    RgbColor color;

    color = BG_COLOR.toRgbColor();
    _ctx.lineWidth = OUTER_STROKE;
    _ctx.setFillColorRgb(color.r, color.g, color.b);
    _ctx.fillRect(0, 0, width, height);

    color = SHADE_COLOR.toRgbColor();
    _ctx.setFillColorRgb(color.r, color.g, color.b);
    _ctx.setStrokeColorRgb(color.r, color.g, color.b);

    int w = 0;
    int h = 0;
    int y = 2*OUTER_MARGIN;
    while(y<height){
      int x = 2*OUTER_MARGIN;
      w = 0;
      while(x<width){
        _ctx.strokeRect(x, y, OUTER_SIDE, OUTER_SIDE);
        _ctx.fillRect(x+OUTER_STROKE + INNER_MARGIN, y+OUTER_STROKE+INNER_MARGIN, INNER_SIDE, INNER_SIDE);
        _ctx.strokeRect(x+OUTER_STROKE + INNER_MARGIN, y+OUTER_STROKE + INNER_MARGIN, INNER_SIDE, INNER_SIDE);
        w++;
        x = x + DOT;
      }
      h++;
      y = y + DOT;
    }
  }

  void front(){
     int w = 0;
     int h = 0;
     int y = 2*OUTER_MARGIN;
     while(y<height){
       int x = 2*OUTER_MARGIN;
       w = 0;
       while(x<width){
         var p = new Tuple2<int, int>(w, h);
         Point tp = data[p];
         if (tp!=null){
           var color = tp.col.toRgbColor();
           _ctx.setFillColorRgb(color.r, color.g, color.b);
           _ctx.setStrokeColorRgb(color.r, color.g, color.b);
           _ctx.strokeRect(x, y, OUTER_SIDE, OUTER_SIDE);
           _ctx.fillRect(x+OUTER_STROKE + INNER_MARGIN, y+OUTER_STROKE+INNER_MARGIN, INNER_SIDE, INNER_SIDE);
           _ctx.strokeRect(x+OUTER_STROKE + INNER_MARGIN, y+OUTER_STROKE + INNER_MARGIN, INNER_SIDE, INNER_SIDE);
         }
         w++;
         x = x + DOT;
       }
       h++;
       y = y + DOT;
     }
  }

  void import(String js){
    Map<String, Object> r;
    r = JSON.decode(js);
    String name = r["name"];
    if(name == null || name == ""){
      name = "noname";
    }
    data.clear();
    List<Map<String, Object>> pl = r["data"];
    if(pl!=null){
      pl.forEach((Map<String, Object>m){
        Point p = new Point.fromMap(m);
        data[new Tuple2(p.x, p.y)]=p;
      });
    }
  }

  void prepare(int w, int h){
    _root.width = 1+(w ~/ DOT) * DOT;
    _root.height = 1+(h ~/ DOT) * DOT;
    _ctx.imageSmoothingEnabled = false;
    _ctx.translate(0.5, 0.5);
    _ctx.scale(1, 1);

    width = w;
    height = h;

    if(href!=""){
      Future load = HttpRequest.request(href, mimeType: 'application/octet-stream', responseType: 'arraybuffer');
        load.then((req){
              Uint8List ul = (req.response as ByteBuffer).asUint8List();
              String js = UTF8.decode(ul);
              import(js);
              front();
          },
          onError: (e){
            window.alert("$href not found $e");
          });
    }
    //print("$href ~ $nx:$ny::$base");
  }

  @override
  void attached(){
    prepare(_div.clientWidth, _div.clientHeight);
    if (!transparent)
       back();
    front();
  }

  ChiCanvas.created() : super.created(){
    _div = ($['root_canvas_container'] as DivElement);
    _root = ($['root_canvas'] as CanvasElement);
    _ctx = _root.context2D;
  }
}