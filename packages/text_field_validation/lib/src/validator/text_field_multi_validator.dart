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

import 'package:text_field_validation/src/validator/data/validation_type.dart';
import 'package:text_field_validation/src/validator/data/validator_data.dart';
import 'package:text_field_validation/src/validator/text_field_validator.dart';

/// Множественный валидатор
/// Позволят алидировать несколько условий
class TextFieldMultiValidator extends TextFieldValidator {
  TextFieldMultiValidator(
    this.validators, {
    TextFieldValidationType validationType,
  })  : validationType = validationType ?? TextFieldValidationType.and,
        assert(validators != null),
        super();

  /// Список валидаторов
  final List<TextFieldValidator> validators;

  /// Тип валидации
  final TextFieldValidationType validationType;

  /// Проходит список валидаторов
  /// Возвращает первый попавшийся невалидный
  /// Иначе вернет валидатор [ValidatorData] с isValid] == true
  @override
  ValidatorData validate(String text) {
    ValidatorData _validatorData;
    for (final TextFieldValidator validator in validators) {
      _validatorData = validator.validate(text);
      if (_getNext(_validatorData)) continue;
      return _validatorData;
    }

    /// Может быть null только в случае пустого массива
    return _validatorData ?? ValidatorData(isValid: true);
  }

  bool _getNext(ValidatorData data) {
    switch (validationType) {
      case TextFieldValidationType.or:
        return data.isNotValid;
      case TextFieldValidationType.and:
      default:
        return data.isValid;
    }
  }
}
