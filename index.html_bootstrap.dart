library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_input.dart' as i0;
import 'package:core_elements/core_meta.dart' as i1;
import 'package:core_elements/core_iconset.dart' as i2;
import 'package:core_elements/core_icon.dart' as i3;
import 'package:core_elements/core_iconset_svg.dart' as i4;
import 'package:core_elements/core_style.dart' as i5;
import 'package:paper_elements/paper_input_decorator.dart' as i6;
import 'package:paper_elements/paper_input.dart' as i7;
import 'package:core_elements/core_focusable.dart' as i8;
import 'package:paper_elements/paper_ripple.dart' as i9;
import 'package:paper_elements/paper_shadow.dart' as i10;
import 'package:paper_elements/paper_button_base.dart' as i11;
import 'package:paper_elements/paper_button.dart' as i12;
import 'main.dart' as i13;
import 'package:smoke/smoke.dart' show Declaration, PROPERTY, METHOD;
import 'package:smoke/static.dart' show useGeneratedCode, StaticConfiguration;

void main() {
  useGeneratedCode(new StaticConfiguration(
      checkedMode: false));
  new LogInjector().injectLogsFromUrl('index.html._buildLogs');
  configureForDeployment([
      i0.upgradeCoreInput,
      i1.upgradeCoreMeta,
      i2.upgradeCoreIconset,
      i3.upgradeCoreIcon,
      i4.upgradeCoreIconsetSvg,
      i5.upgradeCoreStyle,
      i6.upgradePaperInputDecorator,
      i7.upgradePaperInput,
      i9.upgradePaperRipple,
      i10.upgradePaperShadow,
      i11.upgradePaperButtonBase,
      i12.upgradePaperButton,
    ]);
  i13.main();
}
