// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:color/color.dart';

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

class Tuple2<T1, T2> {
  T1 i1;
  T2 i2;

  Tuple2(this.i1, this.i2);

  String toString() => '[$i1, $i2]';

  int get hashCode {
      int result = 17;
      result = 37 * result + i1.hashCode;
      result = 37 * result + i2.hashCode;
      return result;
    }

    // You should generally implement operator == if you
    // override hashCode.
    bool operator ==(other) {
      if (other is! Tuple2) return false;
      Tuple2 t = other;
      return (t.i1 == i1 &&
          t.i2 == i2);
    }
}

class Point {
  int x = 0;
  int y = 0;
  Color col = BLACK;

  Point(this.x, this.y);
  String toString() => '{x: $x, y: $y, col: $col}';
}

class Port {
  CanvasRenderingContext2D ctx;
  CanvasRenderingContext2D via;
  CanvasRenderingContext2D img;

  int width;
  int height;

  Map<Tuple2<int, int>, Point> data = new Map();

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
  }

  void leave(){
    via.clearRect(0, 0, width, height);
  }

  void put(int x, int y){
    var p = new Tuple2<int, int>(x, y);
    Point tp = data[p];
    if (tp == null){
      data[p]=new Point(x, y);
    }else{
      if(tp.col == BLACK){
        tp.col = GREY50;
      }else if(tp.col == GREY50){
        tp.col = GREY25;
      }else{
        data.remove(p);
      }
    }
  }

  void clear(int x, int y){
      var p = new Tuple2<int, int>(x, y);
      data.remove(p);
  }

  String export(){
    if (data.values!=null){
      return data.values.toString();
    }else{
      return "";
    }
  }
}

Port port = null;

void main() {
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
    port.move((e.offset.x+1) ~/ DOT, (e.offset.y+1) ~/DOT);
  })
      ..onMouseOut.listen((MouseEvent e){
    port.leave();
  })
      ..onMouseDown.listen((MouseEvent e){
    if(e.button==0){
      port.put((e.offset.x+1) ~/ DOT, (e.offset.y+1) ~/DOT);
    }else{
      port.clear((e.offset.x+1) ~/ DOT, (e.offset.y+1) ~/DOT);
    }
    port.front();
    (querySelector("#root_data") as TextAreaElement).value = port.export();
    e.preventDefault();
  });
  via.onContextMenu.listen((e){e.preventDefault();});
  draw(null);
}
