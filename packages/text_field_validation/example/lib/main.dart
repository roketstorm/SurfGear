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
import 'package:text_field_validation/text_field_validation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TextFieldValidator example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'TextFieldValidator example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextFieldMultiValidator _countValidator = TextFieldMultiValidator(
    [
      NoEmptyTextFieldValidator('Поле не должно быть пустым'),
      TextFieldMultiValidator(
        [
          LengthLimitTextFieldValidator(
            8,
            'Поле должно быть 8 или 10 символов',
          ),
          LengthLimitTextFieldValidator(
            10,
            'Поле должно быть 8 или 10 символов',
          ),
        ],
        validationType: TextFieldValidationType.or,
      )
    ],
    validationType: TextFieldValidationType.and,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTextField(
                labelText: 'Поле с не пустым текстом',
                validator: NoEmptyTextFieldValidator(
                  'Поле не должно быть пустым',
                ),
              ),
              _buildTextField(
                labelText: 'Email',
                validator: EmailTextFieldValidator(
                  emptyErrorText: 'Поле не должно быть пустым',
                  invalidText: 'Неподходящий email',
                ),
              ),
              _buildTextField(
                labelText:
                    'Поле не должно быть пустым, иметь 8 или 10 символов',
                validator: _countValidator,
              ),
              AnimatedPadding(
                duration: const Duration(milliseconds: 250),
                padding: MediaQuery.of(context).viewInsets,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    String labelText,
    TextFieldValidator validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
      ),
      autovalidate: true,
      validator: (String text) {
        final ValidatorData validatorData = validator.validate(text);
        return validatorData.isValid ? null : validatorData.errorText;
      },
    );
  }
}
