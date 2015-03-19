library animate;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:chi/poly/chi_canvas.dart';
import 'package:chi/tools.dart';

@CustomTag("chi-default-animation")
class ChiAnimation extends PolymerElement{
  static final duration = 2*Duration.MILLISECONDS_PER_SECOND;

  ChiCanvas canvas;

  void redrawLater(int frameIdx){
    var frames = canvas.frames;
    window.animationFrame.then((num n){
      int laterIdx = 0;
      var t = new Transformata(canvas);
      t.frame = laterIdx;
      if(frames.containsKey(frameIdx)){
        t.frame = frameIdx;
        bus.fire(t);
        if(frames.containsKey(frameIdx+1)){
          laterIdx++;
        }
      }
      var delay = new Duration(seconds: 1);
      if(frames.length>0)
        delay = new Duration(milliseconds: duration ~/ frames.length);
      new Future.delayed(delay, (){
        redrawLater(laterIdx);
      });
    });
  }

  void attached(){
    canvas = (this.parent.shadowRoot.host as ChiCanvas);
    redrawLater(0);
  }

  ChiAnimation.created() : super.created();
}