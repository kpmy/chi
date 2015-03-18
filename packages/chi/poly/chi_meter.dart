library elem;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:chi/tools.dart';
import 'package:chi/app/loop.dart';
import 'package:color/color.dart';

final Color BG_COLOR = new Color.hex("ced6b5");
final Color SHADE_COLOR = new Color.hex("bac1a3");
final Color BLACK = new Color.hex("000000");

@CustomTag("chi-meter")
class ChiMeter extends PolymerElement with ChangeNotifier  implements ChiEventListener {
  int _hm;
  CanvasRenderingContext2D ctx;
  int width;
  int height;
  double _value = 0.0;
  double get value => _value;

  set value(double x) {
    _value = x;
    doDraw();
  }

  @reflectable @published String get property => __$property; String __$property = ""; @reflectable set property(String value) { __$property = notifyPropertyChange(#property, __$property, value); }

  void setValue(Model m) {
    switch (property) {
      case "hunger":
        value = m.full;
        break;
      default:
        throw new ArgumentError.value(property, "", "неизвестный параметр");
    }
  }

  @override
  void listen(event) {
    if (event is AppStart) {
      bus.fire(new ModelComponentRegister());
    } else if (event is ModelComponentInit) {
      if (_hm == null) {
        _hm = event.model.hashCode;
        setValue(event.model);
      }
    } else if (_hm != null) {
      if (event is ModelUpdated) {
        setValue(event.model);
      }
    }
  }

  void doDraw() {
    final int BAR_HEIGHT = height - 4;
    final int BAR_WIDTH = BAR_HEIGHT ~/ 2;
    final int count = -1 + ((width - 8) ~/ (BAR_WIDTH + 1));
    final int _width = count * (BAR_WIDTH + 1) + 3;
    final int val = (count * value).round();

    ctx.clearRect(0, 0, width, height);
    var color = BG_COLOR.toRgbColor();
    ctx.setFillColorRgb(color.r, color.g, color.b);
    ctx.fillRect(0, 0, _width, height);

    color = BLACK.toRgbColor();
    ctx.setFillColorRgb(color.r, color.g, color.b);
    ctx.fillRect(0, 0, _width, 1);
    ctx.fillRect(0, 0, 1, height);
    ctx.fillRect(0, height - 1, _width, 1);
    ctx.fillRect(_width - 1, 0, 1, height);

    int x = 2;
    int y = 2;
    for (int i = 0; i < count; i++) {
      if (i < val) color = BLACK.toRgbColor(); else color = SHADE_COLOR.toRgbColor();

      ctx.setFillColorRgb(color.r, color.g, color.b);
      ctx.fillRect(x, y, BAR_WIDTH, BAR_HEIGHT);
      x = x + BAR_WIDTH + 1;
    }
  }

  void prepare(int w, int h) {
    var root = ($["meter_canvas"] as CanvasElement);
    root.width = w;
    root.height = h;
    width = w;
    height = h;

    ctx = root.context2D;
    ctx.imageSmoothingEnabled = false;
  }

  @override
  void attached() {
    assert(property != "");
    var div = ($["meter_container"] as DivElement);
    prepare(div.clientWidth, div.clientHeight);
    doDraw();
  }

  ChiMeter.created() : super.created() {
    listenTo(this);
  }
}
