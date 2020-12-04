import 'package:flutter/widgets.dart';
import 'package:mwwm/mwwm.dart';

/// [WidgetModel] для Template
class TemplateWm extends WidgetModel {
  TemplateWm(
    WidgetModelDependencies dependencies,
    this._navigator,
  ) : super(dependencies);

  final NavigatorState _navigator;

  @override
  void onLoad() {
    super.onLoad();
    //TODO
  }
}
