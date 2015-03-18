library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'package:polymer/src/build/log_injector.dart';
import 'package:chi/poly/chi_canvas.dart' as i0;
import 'package:chi/poly/chi_controls.dart' as i1;
import 'package:chi/poly/chi_meter.dart' as i2;
import 'package:chi/poly/chi_balance.dart' as i3;
import 'app.dart' as i4;
import 'package:smoke/smoke.dart' show Declaration, PROPERTY, METHOD;
import 'package:smoke/static.dart' show useGeneratedCode, StaticConfiguration;
import 'package:chi/poly/chi_canvas.dart' as smoke_0;
import 'package:polymer/polymer.dart' as smoke_1;
import 'package:observe/src/metadata.dart' as smoke_2;
import 'package:chi/poly/chi_controls.dart' as smoke_3;
import 'package:chi/poly/chi_meter.dart' as smoke_4;
import 'package:chi/poly/chi_balance.dart' as smoke_5;
abstract class _M0 {} // PolymerElement & ChangeNotifier

void main() {
  useGeneratedCode(new StaticConfiguration(
      checkedMode: false,
      getters: {
        #base: (o) => o.base,
        #doFeed: (o) => o.doFeed,
        #duration: (o) => o.duration,
        #href: (o) => o.href,
        #left: (o) => o.left,
        #order: (o) => o.order,
        #property: (o) => o.property,
        #top: (o) => o.top,
        #transparent: (o) => o.transparent,
      },
      setters: {
        #base: (o, v) { o.base = v; },
        #duration: (o, v) { o.duration = v; },
        #href: (o, v) { o.href = v; },
        #left: (o, v) { o.left = v; },
        #order: (o, v) { o.order = v; },
        #property: (o, v) { o.property = v; },
        #top: (o, v) { o.top = v; },
        #transparent: (o, v) { o.transparent = v; },
      },
      parents: {
        smoke_5.ChiBalance: _M0,
        smoke_0.ChiCanvas: _M0,
        smoke_0.ChiFrame: _M0,
        smoke_3.ChiControls: smoke_1.PolymerElement,
        smoke_4.ChiMeter: _M0,
        _M0: smoke_1.PolymerElement,
      },
      declarations: {
        smoke_5.ChiBalance: {
          #property: const Declaration(#property, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
        },
        smoke_0.ChiCanvas: {
          #base: const Declaration(#base, int, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #duration: const Declaration(#duration, int, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #left: const Declaration(#left, int, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #top: const Declaration(#top, int, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #transparent: const Declaration(#transparent, bool, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
        },
        smoke_0.ChiFrame: {
          #href: const Declaration(#href, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #order: const Declaration(#order, int, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
        },
        smoke_3.ChiControls: {},
        smoke_4.ChiMeter: {
          #property: const Declaration(#property, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
        },
      },
      names: {
        #base: r'base',
        #doFeed: r'doFeed',
        #duration: r'duration',
        #href: r'href',
        #left: r'left',
        #order: r'order',
        #property: r'property',
        #top: r'top',
        #transparent: r'transparent',
      }));
  new LogInjector().injectLogsFromUrl('index.html._buildLogs');
  configureForDeployment([
      () => Polymer.register('chi-canvas', i0.ChiCanvas),
      () => Polymer.register('chi-frame', i0.ChiFrame),
      () => Polymer.register('chi-controls', i1.ChiControls),
      () => Polymer.register('chi-meter', i2.ChiMeter),
      () => Polymer.register('chi-balance', i3.ChiBalance),
    ]);
  i4.main();
}
