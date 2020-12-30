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

import 'package:flutter/material.dart';
import 'package:flutter/local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocalAuth example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LocalAuth example'),
      ),
      body: Center(
        child: OutlineButton(
          onPressed: selectedBiometric,
          child: Text('Показать биометрию'),
        ),
      ),
    );
  }

  Future<bool> selectedBiometric() async {
    return await _localAuth.authenticateWithBiometrics(
      localizedReason: 'Чтобы использовать приложение, требуется Touch ID',
      androidAuthStrings: const AndroidAuthMessages(
        signInTitle: 'Используйте Touch ID для приложения',
        fingerprintHint: '',
        cancelButton: 'Отменить',
      ),
      iOSAuthStrings: const IOSAuthMessages(
        lockOut: 'Войдите используя пинкод или повторите попытку позже',
        cancelButton: 'Отменить',
        goToSettingsButton: 'Перейти к настройке',
        goToSettingsDescription:
            'На вашем телефоне не настроена биометрия, Включите Touch ID или Face ID на своем телефоне.',
      ),
      onAuthenticationFailedAttempt: () {
        print('Попытка биометрии провалилась');
      },
    );
  }
}
