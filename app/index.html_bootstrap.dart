library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'package:polymer/src/build/log_injector.dart';
import 'package:chi/poly/chi_canvas.dart' as i0;
import 'app.dart' as i1;
import 'package:smoke/smoke.dart' show Declaration, PROPERTY, METHOD;
import 'package:smoke/static.dart' show useGeneratedCode, StaticConfiguration;
import 'package:chi/poly/chi_canvas.dart' as smoke_0;
import 'package:polymer/polymer.dart' as smoke_1;
import 'package:observe/src/metadata.dart' as smoke_2;
abstract class _M0 {} // PolymerElement & ChangeNotifier

void main() {
  useGeneratedCode(new StaticConfiguration(
      checkedMode: false,
      getters: {
        #base: (o) => o.base,
        #href: (o) => o.href,
        #transparent: (o) => o.transparent,
      },
      setters: {
        #base: (o, v) { o.base = v; },
        #href: (o, v) { o.href = v; },
        #transparent: (o, v) { o.transparent = v; },
      },
      parents: {
        smoke_0.ChiCanvas: _M0,
        _M0: smoke_1.PolymerElement,
      },
      declarations: {
        smoke_0.ChiCanvas: {
          #base: const Declaration(#base, int, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #href: const Declaration(#href, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #transparent: const Declaration(#transparent, bool, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
        },
      },
      names: {
        #base: r'base',
        #href: r'href',
        #transparent: r'transparent',
      }));
  new LogInjector().injectLogsFromUrl('index.html._buildLogs');
  configureForDeployment([
      () => Polymer.register('chi-canvas', i0.ChiCanvas),
    ]);
  i1.main();
}
