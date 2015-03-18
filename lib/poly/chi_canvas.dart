library elem;

import 'dart:html';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:color/color.dart';
import 'package:chi/tools.dart';
import 'package:chi/image.dart';
import 'package:chi/design.dart';

class Frame {
  int order;
  Image img;

  Frame.elem(ChiFrame f){
    this.img = f.img;
    this.order = f.order;
  }
}

@CustomTag("chi-canvas")
class ChiCanvas extends PolymerElement implements ChiEventListener {

  //вычисляются теперь
  //const int OUTER_SIDE = INNER_SIDE+2*INNER_MARGIN+2*OUTER_STROKE;
  //const DOT = OUTER_SIDE+2*OUTER_MARGIN;

  static final int DEFAULT_INNER_SIDE = 7;
  static final int INNER_MARGIN = 1;
  static final int OUTER_MARGIN = 1;
  static final int OUTER_STROKE = 1;

  @published int base = DEFAULT_INNER_SIDE;
  @published bool transparent = true;
  @published int top = 0;
  @published int left = 0;
  @published int duration = Duration.MILLISECONDS_PER_SECOND;

  int get INNER_SIDE => base;
  int get OUTER_SIDE => INNER_SIDE + 2 * INNER_MARGIN + 2 * OUTER_STROKE;
  int get DOT => OUTER_SIDE + 2 * OUTER_MARGIN;
  int get TOP => top;
  int get LEFT => left;

  DivElement _div;
  CanvasElement _root;
  CanvasRenderingContext2D _ctx;

  Map<int, Frame> frames = new Map();

  int width = 0;
  int height = 0;
  int get nx => width ~/ DOT;
  int get ny => height ~/ DOT;

  void clear(){
    _ctx.clearRect(0, 0, width, height);
  }

  void back() {
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
    int y = 2 * OUTER_MARGIN;
    while (y < height) {
      int x = 2 * OUTER_MARGIN;
      w = 0;
      while (x < width) {
        _ctx.strokeRect(x, y, OUTER_SIDE, OUTER_SIDE);
        _ctx.fillRect(x + OUTER_STROKE + INNER_MARGIN, y + OUTER_STROKE + INNER_MARGIN, INNER_SIDE, INNER_SIDE);
        _ctx.strokeRect(x + OUTER_STROKE + INNER_MARGIN, y + OUTER_STROKE + INNER_MARGIN, INNER_SIDE, INNER_SIDE);
        w++;
        x = x + DOT;
      }
      h++;
      y = y + DOT;
    }
  }

  void front(Image img) {
    int w = 0;
    int h = 0;

    _ctx.setStrokeColorRgb(0xFF, 0, 0);
    _ctx.strokeRect(2 * OUTER_MARGIN + LEFT * DOT, 2 * OUTER_MARGIN + TOP * DOT, img.width * DOT - 2, img.height * DOT - 2);

    int y = 2 * OUTER_MARGIN + TOP * DOT;
    while (y < height && h < img.height) {
      int x = 2 * OUTER_MARGIN + LEFT * DOT;
      w = 0;
      while (x < width && w < img.width) {
        var p = new Tuple2<int, int>(w, h);
        Dot tp = img.data[p];
        if (tp != null) {
          var color = tp.col.toRgbColor();
          _ctx.setFillColorRgb(color.r, color.g, color.b);
          _ctx.setStrokeColorRgb(color.r, color.g, color.b);
          _ctx.strokeRect(x, y, OUTER_SIDE, OUTER_SIDE);
          _ctx.fillRect(x + OUTER_STROKE + INNER_MARGIN, y + OUTER_STROKE + INNER_MARGIN, INNER_SIDE, INNER_SIDE);
          _ctx.strokeRect(x + OUTER_STROKE + INNER_MARGIN, y + OUTER_STROKE + INNER_MARGIN, INNER_SIDE, INNER_SIDE);
        }
        w++;
        x = x + DOT;
      }
      h++;
      y = y + DOT;
    }
  }

  void registerFrame(ChiFrame f){
    assert(f.img!=null);
    frames[f.order]= new Frame.elem(f);
    if(frames.containsKey(0)){
      front(frames[0].img);
    }
  }

  void prepare(int w, int h) {
    _root.width = 1 + (w ~/ DOT) * DOT;
    _root.height = 1 + (h ~/ DOT) * DOT;
    _ctx.imageSmoothingEnabled = false;
    _ctx.translate(0.5, 0.5);
    _ctx.scale(1, 1);

    width = w;
    height = h;
  }

  void redrawLater(int frameIdx){
    window.animationFrame.then((num n){
      int laterIdx = 0;
      if (!transparent) back(); else clear();
      if(frames.containsKey(frameIdx)){
        Frame f = frames[frameIdx];
        front(f.img);
        Frame next = frames[f.order+1];
        if(next != null)
          laterIdx = next.order;
      }
      var delay = new Duration(seconds: 1);
      if(frames.length>0)
        delay = new Duration(milliseconds: duration ~/ frames.length);
      new Future.delayed(delay, (){
        redrawLater(laterIdx);
      });
    });
  }

  @override
  void attached() {
    prepare(_div.clientWidth, _div.clientHeight);
    redrawLater(0);
  }

  @override
  void listen(event) {
  }

  ChiCanvas.created() : super.created() {
    _div = ($['root_canvas_container'] as DivElement);
    _root = ($['root_canvas'] as CanvasElement);
    _ctx = _root.context2D;
    listenTo(this);
  }
}

@CustomTag("chi-frame")
class ChiFrame extends PolymerElement{
  @published String href = "";
  @published int order = 0;
  Image img;

  void attached() {
    if (href != "") {
          Future load = HttpRequest.request(href, mimeType: 'application/octet-stream', responseType: 'arraybuffer');
          load.then((req) {
            Uint8List ul = (req.response as ByteBuffer).asUint8List();
            String js = UTF8.decode(ul);
            img = new Image.import(js);
            var canvas = (this.parent.shadowRoot.host as ChiCanvas);
            canvas.registerFrame(this);
          }, onError: (e) {
            window.alert("$href not found $e");
            throw new Exception("image $href not found");
          });
        }
  }

  ChiFrame.created() : super.created();
}