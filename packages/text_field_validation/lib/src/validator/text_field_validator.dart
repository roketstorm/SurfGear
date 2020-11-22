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

import 'package:flutter/foundation.dart';
import 'package:text_field_validation/src/validator/data/validator_data.dart';

/// TODO попробовать без data и использовать массив валидаторов
/// Класс заглушка для валидатора текстового поля
abstract class TextFieldValidator {
  TextFieldValidator([ValidatorData data]) : data = data ?? ValidatorData();

  TextFieldValidator.fromText(String text)
      : data = ValidatorData(errorText: text);

  /// Данные валидатора
  final ValidatorData data;

  /// Функция проверяющая на валидность строк
  /// и возвращающая ValidatorError в случае невалидности
  ValidatorData validate(String text);

  /// Функция проверяющая невалидность строку
  bool isValid(String text) => validate(text).isValid;

  /// Функция проверяющая на невалидность строку
  bool isNotValid(String text) => validate(text).isNotValid;

  @protected
  ValidatorData getValidatorData(bool isValidText) {
    return data.copy(isValid: isValidText);
  }
}
