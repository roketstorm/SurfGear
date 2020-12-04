import 'package:flutter/widgets.dart';
import 'package:mwwm/mwwm.dart';

/// [WidgetModel] для Template
class TemplateWm extends WidgetModel {
  TemplateWm(
    WidgetModelDependencies dependencies,
    this.navigator,
  ) : super(dependencies);

  final NavigatorState navigator;

  @override
  void onLoad() {
    super.onLoad();
    //TODO
  }
}
