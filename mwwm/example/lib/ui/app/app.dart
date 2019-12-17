// Copyright (c) 2019-present,  SurfStudio LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:counter/ui/app/app_wm.dart';
import 'package:counter/ui/app/di/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mwwm/mwwm.dart';
import 'package:injector/injector.dart';

/// Widget приложения
class App extends MwwmWidget<AppComponent> {
  App()
      : super(
          dependenciesBuilder: (BuildContext context) => AppComponent(),
          widgetStateBuilder: () => _AppState(),
        );
}

class _AppState extends WidgetState<AppWidgetModel> {
  Key _navKey;

  @override
  void initState() {
    super.initState();
    _navKey = Injector.of<AppComponent>(context).component.navigatorKey;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      home: Scaffold(
        body: Center(
          child: Icon(
            Icons.plus_one,
            size: 200,
            color: Colors.indigo,
          ),
        ),
      ),
    );
  }
}
