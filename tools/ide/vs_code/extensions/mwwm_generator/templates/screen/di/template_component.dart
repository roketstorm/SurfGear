import 'package:flutter/material.dart';
import 'package:surf_injector/surf_injector.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

/// [Component] для Template
class TemplateComponent extends WidgetComponent {
  TemplateComponent(BuildContext context) : super(context) {
    _navigator = Navigator.of(context);
  }

  NavigatorState _navigator;
}

/// Билдер для TemplateWm
TemplateWm createTemplateWm(BuildContext context) {
  final component = Injector.of<TemplateComponent>(context).component;
  return TemplateWm(
    component.wmDependencies,
    component._navigator,
  );
}
