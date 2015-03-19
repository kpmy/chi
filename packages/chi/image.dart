library image;

import 'package:color/color.dart';
import 'package:chi/tools.dart';
import 'package:chi/design.dart';
import 'dart:convert';

class Dot {
  int x = 0;
  int y = 0;
  Color col = BLACK;

  Dot(this.x, this.y);
  String toString() => '{x: $x, y: $y, col: "$col"}';
  Map<String, Object> toMap() {
    Map<String, Object> ret = new Map();
    ret["x"] = x;
    ret["y"] = y;
    ret["col"] = col.toString();
    return ret;
  }

  Dot.fromMap(Map<String, Object> m) {
    this.x = m["x"];
    this.y = m["y"];
    this.col = new Color.hex(m["col"]);
  }
}

class Image {
  Map<Tuple2<int, int>, Dot> data = new Map();
  Tuple2<int, int> size;
  Tuple2<int, int> content;

  int get width => size.i1;
  int get height => size.i2;

  Image.import(String js) {
    Map<String, Object> r;
    r = JSON.decode(js);
    String name = r["name"];
    if (name == null || name == "") {
      name = "noname";
    }
    if (r.containsKey("size")) size = new Tuple2.fromList(r["size"]); else size = new Tuple2(50, 40);

    data.clear();
    List<Map<String, Object>> pl = r["data"];
    if (pl != null) {
      //normalize
      Dot min = new Dot(0xFFFFFFFF, 0xFFFFFFFF);
      Dot max = new Dot(0, 0);

      pl.forEach((Map<String, Object> m) {
        Dot p = new Dot.fromMap(m);
        if (p.x <= min.x) min.x = p.x;
        if (p.y <= min.y) min.y = p.y;
        if (p.x >= max.x) max.x = p.x;
        if (p.y >= max.y) max.y = p.y;
      });

      if (min.x == 0xFFFFFFFF) {
        min = null;
        content = size;
      } else {
        content = new Tuple2<int, int>(max.x - min.x + 1, max.y - min.y + 1);
      }
      pl.forEach((Map<String, Object> m) {
        Dot p = new Dot.fromMap(m);
//        if (min != null) {
//          p.x = p.x - min.x;
//          p.y = p.y - min.y;
//        }
        data[new Tuple2(p.x, p.y)] = p;
      });

    }
  }
}
