library edit;

import 'dart:html';
import 'package:color/color.dart';
import 'package:chi/tools.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

final Color BG_COLOR = new Color.hex("ced6b5");
final Color SHADE_COLOR = new Color.hex("bac1a3");
final Color BLACK = new Color.hex("000000");
final Color GREY50 = new Color.hex("7c806d");
final Color GREY25 = new Color.hex("a5ab91");

const int OUTER_SIDE = INNER_SIDE+2*INNER_MARGIN+2*OUTER_STROKE;
const int INNER_SIDE = 7;
const int INNER_MARGIN = 1;
const int OUTER_MARGIN = 1;
const int OUTER_STROKE = 1;
const DOT = OUTER_SIDE+2*OUTER_MARGIN;

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

class Port {
  CanvasRenderingContext2D ctx;
  CanvasRenderingContext2D via;
  CanvasRenderingContext2D img;

  int width;
  int height;

  Color lastPen;

  Map<Tuple2<int, int>, Point> data = new Map();
  Tuple2<int, int> size = new Tuple2(50, 40);

  void prepare(int w, int h){
    ctx.imageSmoothingEnabled = false;
    ctx.translate(0.5, 0.5);
    ctx.scale(1, 1);

    via.imageSmoothingEnabled = false;
    via.translate(0.5, 0.5);
    via.scale(1, 1);

    img.imageSmoothingEnabled = false;
    img.translate(0.5, 0.5);
    img.scale(1, 1);

    width = w;
    height = h;
  }

  void back(){
    RgbColor color;

    color = BG_COLOR.toRgbColor();
    ctx.lineWidth = OUTER_STROKE;
    ctx.setFillColorRgb(color.r, color.g, color.b);
    ctx.fillRect(0, 0, width, height);

    color = SHADE_COLOR.toRgbColor();
    ctx.setFillColorRgb(color.r, color.g, color.b);
    ctx.setStrokeColorRgb(color.r, color.g, color.b);

    int w = 0;
    int h = 0;
    int y = 2*OUTER_MARGIN;
    while(y<height){
      int x = 2*OUTER_MARGIN;
      w = 0;
      while(x<width){
        ctx.strokeRect(x, y, OUTER_SIDE, OUTER_SIDE);
        ctx.fillRect(x+OUTER_STROKE + INNER_MARGIN, y+OUTER_STROKE+INNER_MARGIN, INNER_SIDE, INNER_SIDE);
        ctx.strokeRect(x+OUTER_STROKE + INNER_MARGIN, y+OUTER_STROKE + INNER_MARGIN, INNER_SIDE, INNER_SIDE);
        w++;
        x = x + DOT;
      }
      h++;
      y = y + DOT;
    }
  }

  void front(){
    // Store the current transformation matrix
     img.save();
     // Use the identity matrix while clearing the canvas
     img.setTransform(1, 0, 0, 1, 0, 0);
     img.clearRect(0, 0, width, height);
     // Restore the transform
     img.restore();

     if(size != null){
       img.setStrokeColorRgb(0xFF, 0, 0);
       img.strokeRect(2 * OUTER_MARGIN, 2 * OUTER_MARGIN, size.i1 * DOT - 2, size.i2 * DOT - 2);
     }

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
           img.setFillColorRgb(color.r, color.g, color.b);
           img.setStrokeColorRgb(color.r, color.g, color.b);
           img.strokeRect(x, y, OUTER_SIDE, OUTER_SIDE);
           img.fillRect(x+OUTER_STROKE + INNER_MARGIN, y+OUTER_STROKE+INNER_MARGIN, INNER_SIDE, INNER_SIDE);
           img.strokeRect(x+OUTER_STROKE + INNER_MARGIN, y+OUTER_STROKE + INNER_MARGIN, INNER_SIDE, INNER_SIDE);
         }
         w++;
         x = x + DOT;
       }
       h++;
       y = y + DOT;
     }
  }

  void limit(int x, int y){
    size = new Tuple2(x, y);
  }

  void move(int x, int y){
    // Store the current transformation matrix
    via.save();
    // Use the identity matrix while clearing the canvas
    via.setTransform(1, 0, 0, 1, 0, 0);
    via.clearRect(0, 0, width, height);
    // Restore the transform
    via.restore();
    var c = new Color.hex("0000ff").toRgbColor();
    via.setStrokeColorRgb(c.r, c.g, c.b);
    via.strokeRect(x*DOT+1, y*DOT+1, DOT, DOT);
    via.strokeRect(x*DOT+1+OUTER_STROKE+INNER_MARGIN, y*DOT+1+OUTER_STROKE+INNER_MARGIN, INNER_SIDE+2*INNER_MARGIN, INNER_SIDE+2*INNER_MARGIN);
    (querySelector("#pos") as SpanElement).text = "$x:$y";
    (querySelector("#size") as SpanElement).text = "$size";
  }

  void leave(){
    via.clearRect(0, 0, width, height);
  }

  void put(int x, int y, [Color col = null]){
    var p = new Tuple2<int, int>(x, y);
    Point tp = data[p];
    if ((tp == null) && (col != SHADE_COLOR)){
      data[p]=new Point(x, y);
      if(col != null){
        data[p].col = col;
      }else{
        data[p].col = BLACK;
      }
      lastPen = data[p].col;
    }else if (col!=null){
      lastPen = col;
      if (col == SHADE_COLOR){
        clear(x, y);
      }else{
        tp.col = col;
      }
    }else if (col==null){
      if(tp.col == BLACK){
        tp.col = GREY50;
        lastPen = tp.col;
      }else if(tp.col == GREY50){
        tp.col = GREY25;
        lastPen = tp.col;
      }else{
        clear(x, y);
      }
    }
  }

  void clear(int x, int y){
      var p = new Tuple2<int, int>(x, y);
      data.remove(p);
      lastPen = SHADE_COLOR;
  }

  void shift(dx, dy){
    Map<Tuple2<int, int>, Point> tmp = new Map();
    data.keys.forEach((t){
      var p = data[t];
      var nt = new Tuple2<int, int>(t.i1 + dx, t.i2+dy);
      var np = new Point(nt.i1, nt.i2);
      np.col = p.col;
      tmp[nt] = np;
    });
    data = tmp;
  }

  String export(){
    if (data.values!=null){
      Map<String, Object> r = new Map();
      List<Map<String, Object>> ret = new List();
      data.values.forEach((Point p){
        ret.add(p.toMap());
      });
      String name = (querySelector("#root_name") as InputElement).value;
      if(name==null || name==""){
        name="noname";
      }
      r["name"]=name;
      r["size"]=size.toList();
      r["data"]=ret;
      return JSON.encode(r);
    }else{
      return "{}";
    }
  }

  void import(String js){
    Map<String, Object> r;
    r = JSON.decode(js);
    String name = r["name"];
    if(name == null || name == ""){
      name = "noname";
    }
    (querySelector("#root_name") as InputElement).value = name;
    if (r.containsKey("size"))
      size = new Tuple2.fromList(r["size"]);
    else
      size = new Tuple2(50, 40);

    data.clear();
    List<Map<String, Object>> pl = r["data"];
    if(pl!=null){
      pl.forEach((Map<String, Object>m){
        Point p = new Point.fromMap(m);
        data[new Tuple2(p.x, p.y)]=p;
      });
    }
  }

  Tuple2<int, int> mapCoord(int x, int y){
    return new Tuple2((x+1) ~/ DOT, (y+1) ~/DOT);
  }
}

Port port = null;

void run(){
  final CanvasElement root = (querySelector('#root_canvas') as CanvasElement);
   final CanvasElement via = (querySelector('#via_canvas') as CanvasElement);
   final CanvasElement img = (querySelector('#img_canvas') as CanvasElement);

   port = new Port();
   port.ctx = root.context2D;
   port.via = via.context2D;
   port.img = img.context2D;
   var div = querySelector("#root_canvas_container");

   var draw = (e){
     root.width = div.clientWidth;
     root.height = div.clientHeight;
     via.width = div.clientWidth;
     via.height = div.clientHeight;
     img.width = div.clientWidth;
     img.height = div.clientHeight;
     port.prepare(root.width, root.height);
     port.back();
     port.front();
   };

   window.onResize.listen(draw);
   div
       ..onMouseMove.listen((MouseEvent e){
     var c = port.mapCoord(e.offset.x, e.offset.y);
     port.move(c.i1, c.i2);
     if(port.lastPen!=null){
       port.put(c.i1, c.i2, port.lastPen);
       port.front();
     }
   })
       ..onMouseOut.listen((MouseEvent e){
     port.leave();
     port.lastPen = null;
   })
       ..onMouseUp.listen((MouseEvent e){
       port.lastPen = null;
   })
       ..onMouseDown.listen((MouseEvent e){
     var c = port.mapCoord(e.offset.x, e.offset.y);
     if(e.button==0){
       port.put(c.i1, c.i2);
     }else if (e.button == 1){
       port.limit(c.i1+1, c.i2+1);
     }else{
       port.clear(c.i1, c.i2);
     }
     port.front();
     e.preventDefault();
   });

   window.onKeyDown.listen((KeyboardEvent e){
     switch(e.keyCode){
       case 37:
         port.shift(-1, 0);
         break;
       case 39:
         port.shift(1, 0);
         break;
       case 40:
         port.shift(0, 1);
         break;
       case 38:
         port.shift(0, -1);
         break;
     }
     port.front();
     e.preventDefault();
   });

   via.onContextMenu.listen((e){e.preventDefault();});
   querySelector("#root_save_button").onClick.listen((e){
     List<String> data = new List();
     data.add(port.export());
     window.open(Url.createObjectUrlFromBlob(new Blob(data, "application/octet-stream")), "");
   });

   querySelector('#file_path')
       ..onChange.listen((e){
     File fi;
     FileUploadInputElement fo = querySelector('#file_path');
       if((fo != null) && (fo.files.length>0)){
         print("get file");
         FileSystem fs;
         fi = fo.files.first;
         Future future = window.requestFileSystem(fi.size).then((fs){
           print("get fs");
           FileEntry fe;
           Future future = fs.root.createFile(fi.name);
           future.then((fe){
             print("get writer");
             FileWriter wr;
             Future future = fe.createWriter();
             future.then((wr){
               print("writer");
               FileReader rd;
               wr.write(fi);
               Future future = HttpRequest.request(fe.toUrl(), mimeType: 'application/octet-stream', responseType: 'arraybuffer').then((req){
                  print("read");
                  Uint8List ul = (req.response as ByteBuffer).asUint8List();
                  String js = UTF8.decode(ul);
                  port.import(js);
                  draw(null);
               });
             });
           });
         });
       }
   });
   draw(null);
}